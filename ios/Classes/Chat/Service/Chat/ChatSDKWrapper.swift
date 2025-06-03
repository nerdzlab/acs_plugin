//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCore
import AzureCommunicationChat
import Foundation

// swiftlint:disable type_body_length
class ChatSDKWrapper: NSObject {
    let chatEventsHandler: ChatSDKEventsHandling
    
    private let logger: Logger
    private let chatConfiguration: ChatConfiguration
    private var chatClient: ChatClient?
    
    private var chatThreadClients: Set<ChatThreadClient> = []
    private var chatMessagePagedCollections: [String: PagedCollection<ChatMessage>] = [:]
    private var readReceiptPagedCollections: [String: PagedCollection<ChatMessageReadReceipt>] = [:]
    private var threadsPagedCollection: PagedCollection<ChatThreadItem>?
    
    init(
        logger: Logger,
        chatEventsHandler: ChatSDKEventsHandling,
        chatConfiguration: ChatConfiguration
    ) {
        self.logger = logger
        self.chatEventsHandler = chatEventsHandler
        self.chatConfiguration = chatConfiguration
        super.init()
    }
    
    deinit {
        logger.debug("ChatSDKWrapper deallocated")
    }
    
    func initializeChat() async throws {
        do {
            try createChatClient()
            try registerRealTimeNotifications()
        } catch {
            throw error
        }
    }
    
    func initializeChatThread(threadId: String) async throws {
        do {
            _ = try await createChatThreadClient(threadId: threadId)
            _ = try await retrieveChatThreadProperties(for: threadId).topic
        } catch {
            throw error
        }
    }
    
    func getInitialMessages(for threadId: String) async throws -> [ChatMessage] {
        do {
            let listChatMessagesOptions = ListChatMessagesOptions(
                maxPageSize: chatConfiguration.pageSize
            )
            
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            return try await safeAsync { completion in
                self.logger.info("Calling listMessages for threadId: \(threadId)")
                
                chatThreadClient.listMessages(withOptions: listChatMessagesOptions) { result, _ in
                    switch result {
                    case .success(let messagesResult):
                        self.logger.info("Successfully received messages for thread \(threadId), count: \(messagesResult.items?.count ?? 0)")
                        self.chatMessagePagedCollections[threadId] = messagesResult
                        completion(.success(messagesResult.items ?? []))
                        
                    case .failure(let error):
                        self.chatMessagePagedCollections.removeValue(forKey: threadId)
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Failed to retrieve initial messages: \(error)")
            throw error
        }
    }
    
    func getLastMessage(for threadId: String) async throws -> ChatMessage? {
        do {
            let listChatMessagesOptions = ListChatMessagesOptions(
                maxPageSize: 1
            )
            
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            return try await safeAsync { completion in
                self.logger.info("Calling getLastMessage for threadId: \(threadId)")
                
                chatThreadClient.listMessages(withOptions: listChatMessagesOptions) { result, _ in
                    switch result {
                    case .success(let messagesResult):
                        self.logger.info("Successfully received last message for thread \(threadId), count: \(messagesResult.items?.count ?? 0)")
                        completion(.success(messagesResult.items?.first))
                        
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Failed to retrieve last message: \(error)")
            throw error
        }
    }
    
    func retrieveChatThreadProperties(for threadId: String) async throws -> ChatThreadProperties {
        do {
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            return try await safeAsync { completion in
                chatThreadClient.getProperties { result, _ in
                    switch result {
                    case .success(let threadProperties):
                        let topic = threadProperties.topic
                        let createdBy = threadProperties.createdBy.stringValue
                        self.logger.info("Retrieved thread topic: \(topic) and createdBy: \(createdBy)")
                        completion(result) // Pass the whole result
                        
                    case .failure(let error):
                        self.logger.error("Retrieve Thread Properties failed: \(error.errorDescription ?? "")")
                        completion(result) // Pass failure result
                    }
                }
            }
        } catch {
            logger.error("Retrieve Thread Properties failed: \(error)")
            throw error
        }
    }
    
    func getListOfParticipants(for threadId: String) async throws -> [ChatParticipant] {
        do {
            let participantsPageSize: Int32 = 200
            let listParticipantsOptions = ListChatParticipantsOptions(maxPageSize: participantsPageSize)
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            let pagedCollectionResult: PagedCollection<ChatParticipant> = try await safeAsync { completion in
                chatThreadClient.listParticipants(withOptions: listParticipantsOptions) { result, _ in
                    switch result {
                    case .success(let pagedCollection):
                        completion(.success(pagedCollection))
                    case .failure(let error):
                        self.logger.error("List Participants failed: \(error.errorDescription ?? "")")
                        completion(.failure(error))
                    }
                }
            }
            
            guard let items = pagedCollectionResult.items else {
                return []
            }
            var allChatParticipants = items
            
            while !pagedCollectionResult.isExhausted {
                let nextPage = try await pagedCollectionResult.nextPage()
                let pageParticipants = nextPage
                
                allChatParticipants.append(contentsOf: pageParticipants)
            }
            return allChatParticipants
        } catch {
            logger.error("Get List of Participants failed: \(error)")
            throw error
        }
    }
    
    func getPreviousMessages(for threadId: String) async throws -> [ChatMessage] {
        do {
            guard let messagePagedCollection = self.chatMessagePagedCollections[threadId] else {
                return try await self.getInitialMessages(for: threadId)
            }
            
            if messagePagedCollection.isExhausted {
                return []
            }
            
            return try await safeAsync { completion in
                messagePagedCollection.nextPage { result in
                    switch result {
                    case .success(let messagesResult):
                        completion(.success(messagesResult))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Retrieve previous messages failed: \(error)")
            throw error
        }
    }
    
    func sendMessage(
        threadId: String,
        content: String,
        senderDisplayName: String,
        type: ChatMessageType?,
        metadata: [String: String]?
    ) async throws -> String {
        do {
            let messageRequest = SendChatMessageRequest(
                content: content,
                senderDisplayName: senderDisplayName,
                type: type,
                metadata: metadata
            )
            
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            return try await safeAsync { completion in
                chatThreadClient.send(message: messageRequest) { result, _ in
                    switch result {
                    case let .success(result):
                        completion(.success(result.id))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Send message failed: \(error)")
            throw error
        }
    }
    
    func editMessage(
        threadId: String,
        messageId: String,
        content: String,
        metadata: [String: String]?
    ) async throws {
        do {
            let messageRequest = UpdateChatMessageRequest(
                content: content,
                metadata: metadata
            )
            
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            try await safeAsync { completion in
                chatThreadClient.update(message: messageId, parameters: messageRequest) { result, _ in
                    switch result {
                    case .success:
                        completion(.success(())) // Void success
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Edit Message failed: \(error)")
            throw error
        }
    }
    
    func deleteMessage(threadId: String, messageId: String) async throws {
        do {
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            try await safeAsync { completion in
                chatThreadClient.delete(message: messageId) { result, _ in
                    switch result {
                    case .success:
                        completion(.success(()))  // Void success
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Delete Message failed: \(error)")
            throw error
        }
    }
    
    func getListReadReceipts(threadId: String, options: ListChatReadReceiptsOptions? = nil) async throws -> [ChatMessageReadReceipt] {
        do {
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            return try await safeAsync { completion in
                chatThreadClient.listReadReceipts(withOptions: options) { result, _ in
                    switch result {
                    case .success(let pagedCollection):
                        self.readReceiptPagedCollections[threadId] = pagedCollection
                        completion(.success(pagedCollection.items ?? []))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("List Read Receipts failed: \(error)")
            throw error
        }
    }
    
    func sendReadReceipt(threadId: String, messageId: String) async throws {
        do {
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            try await safeAsync { completion in
                chatThreadClient.sendReadReceipt(
                    forMessage: messageId,
                    withOptions: SendChatReadReceiptOptions()
                ) { result, _ in
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Failed to send read receipt: \(error)")
            throw error
        }
    }
    
    func sendTypingIndicator(threadId: String) async throws {
        do {
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            try await safeAsync { completion in
                chatThreadClient.sendTypingNotification(from: self.chatConfiguration.displayName) { result, _ in
                    switch result {
                    case .success:
                        completion(.success(()))  // Void success
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            self.logger.error("Send Typing Indicator failed: \(error)")
            throw error
        }
    }
    
    /// Gets the list of ChatThreads for the user.
    func getInitialListThreads() async throws -> [ChatThreadItem] {
        let listThreadsOptions = ListChatThreadsOptions(
            maxPageSize: 20
        )
        
        return try await safeAsync { completion in
            self.chatClient?.listThreads(withOptions: listThreadsOptions) { result, httpResponse in
                switch result {
                case .success(let chatThreadResult):
                    self.threadsPagedCollection = chatThreadResult
                    completion(.success(chatThreadResult.items ?? []))
                    
                case .failure(let error):
                    self.threadsPagedCollection = nil
                    completion(.failure(error))
                }
            }
        }
    }
    
    func getNextThreads() async throws -> [ChatThreadItem] {
        do {
            guard let threadsPagedCollection = self.threadsPagedCollection else {
                return try await self.getInitialListThreads()
            }
            
            if threadsPagedCollection.isExhausted {
                return []
            }
            
            return try await safeAsync { completion in
                threadsPagedCollection.nextPage { result in
                    switch result {
                    case .success(let threads):
                        completion(.success(threads))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            logger.error("Retrieve previous threads failed: \(error)")
            throw error
        }
    }
    
    func isMoreThreadsAvailable() async throws -> Bool {
        do {
            guard let threadsPagedCollection = self.threadsPagedCollection else {
                _ = try await self.getInitialListThreads()
                return !(self.threadsPagedCollection?.isExhausted ?? false)
            }
            
            return !(threadsPagedCollection.isExhausted)
        } catch {
            logger.error("Failed to get info about more threads: \(error)")
            throw error
        }
    }
    
    func isChatHasMoreMessages(threadId: String) async throws -> Bool {
        do {
            guard let messagePagedCollection = self.chatMessagePagedCollections[threadId] else {
                _ = try await self.getInitialMessages(for: threadId)
                return !(self.chatMessagePagedCollections[threadId]?.isExhausted ?? false)
            }
            
            return !(messagePagedCollection.isExhausted)
        } catch {
            logger.error("Failed to get info about more messages: \(error)")
            throw error
        }
    }
    
    private func createChatClient() throws {
        do {
            logger.info("Creating Chat Client...")
            let appId = self.chatConfiguration.diagnosticConfig.tags
                .joined(separator: "/")
            let telemetryOptions = TelemetryOptions(applicationId: appId)
            let clientOptions = AzureCommunicationChatClientOptions(telemetryOptions: telemetryOptions)
            self.chatClient = try ChatClient(
                endpoint: self.chatConfiguration.endpoint,
                credential: self.chatConfiguration.credential,
                withOptions: clientOptions)
        } catch {
            logger.error("Create Chat Client failed: \(error)")
            throw error
        }
    }
    
    private func createChatThreadClient(threadId: String) async throws -> ChatThreadClient {
        logger.info("Creating Chat Thread Client...")
        
        guard let chatClient = self.chatClient else {
            throw AzureError.client("ChatClient is nil", NSError(
                domain: "ChatThreadClientCreation",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "chatClient is nil"]
            ))
        }
        
        do {
            let chatThreadClient = try chatClient.createClient(forThread: threadId)
            self.chatThreadClients.insert(chatThreadClient)
            return chatThreadClient
        } catch {
            logger.error("Create Chat Thread Client failed: \(error)")
            throw error
        }
    }
    
    private func getChatThreadClient(threadId: String) async throws -> ChatThreadClient {
        // Check if already present
        if let existingClient = chatThreadClients.first(where: { $0.threadId == threadId }) {
            return existingClient
        }
        
        // If not present, create and return
        return try await createChatThreadClient(threadId: threadId)
    }
    
    private func registerRealTimeNotifications() throws {
        self.chatClient?.startRealTimeNotifications { [self] (result: Result<Void, AzureError>) in
            switch result {
            case .success:
                logger.info("Real-time notifications started.")
                self.registerEvents()
            case .failure(let error):
                logger.error("Failed to start real-time notifications. \(error)")
            }
        }
    }
    
    func unregisterRealTimeNotifications() {
        guard let client = self.chatClient else {
            return
        }
        
        client.stopRealTimeNotifications()
    }
    
    func setupPushNotifications(apnsToken: String, appGroupId: String, completion: @escaping () -> Void) {
        let keyTag = "PNKey"
        
        do{
            guard let appGroupPushNotificationKeyStorage: PushNotificationKeyStorage = try AppGroupPushNotificationKeyStorage(appGroupId: appGroupId, keyTag: keyTag) else {
                completion()
                return
            }
            
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global(qos: .background).async { [weak self] in
                guard let self = self else {
                    completion()
                    return
                }
                
                guard let chatClient = self.chatClient else {
                    completion()
                    return
                }
                
                chatClient.pushNotificationKeyStorage = appGroupPushNotificationKeyStorage
                
                chatClient.startPushNotifications(deviceToken: apnsToken) { result in
                    switch result {
                    case .success:
                        print("succeeded to start Push Notifications")
                    case let .failure(error):
                        print("failed to start Push Notifications \(error.localizedDescription)")
                    }
                    
                    completion()
                    semaphore.signal()
                }
                semaphore.wait()
            }
        } catch {
            completion()
            return
        }
    }
    
    private func registerEvents() {
        guard let client = self.chatClient else {
            return
        }
        client.register(event: .realTimeNotificationConnected, handler: chatEventsHandler.handle)
        client.register(event: .realTimeNotificationDisconnected, handler: chatEventsHandler.handle)
        client.register(event: .chatMessageReceived, handler: chatEventsHandler.handle)
        client.register(event: .chatMessageEdited, handler: chatEventsHandler.handle)
        client.register(event: .chatMessageDeleted, handler: chatEventsHandler.handle)
        client.register(event: .typingIndicatorReceived, handler: chatEventsHandler.handle)
        client.register(event: .readReceiptReceived, handler: chatEventsHandler.handle)
        client.register(event: .chatThreadDeleted, handler: chatEventsHandler.handle)
        client.register(event: .chatThreadPropertiesUpdated, handler: chatEventsHandler.handle)
        client.register(event: .participantsAdded, handler: chatEventsHandler.handle)
        client.register(event: .participantsRemoved, handler: chatEventsHandler.handle)
    }
    
    func safeAsync<T>(_ operation: @escaping (@escaping (Result<T, AzureError>) -> Void) -> Void) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            var didResume = false
            
            operation { result in
                guard !didResume else {
                    self.logger.debug("Continuation was already resumed")
                    return
                }
                
                didResume = true
                
                switch result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
// swiftlint:enable type_body_length
