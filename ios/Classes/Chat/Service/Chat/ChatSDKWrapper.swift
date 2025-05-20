//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCore
import AzureCommunicationChat
import Foundation

// swiftlint:disable type_body_length
class ChatSDKWrapper: NSObject, ChatSDKWrapperProtocol {
    let chatEventsHandler: ChatSDKEventsHandling
    
    private let logger: Logger
    private let chatConfiguration: ChatConfiguration
    private var chatClient: ChatClient?
    
    private var chatThreadClients: Set<ChatThreadClient> = []
    private var chatMessagePagedCollections: [String: PagedCollection<ChatMessage>] = [:]
    private var readReceiptPagedCollections: [String: PagedCollection<ChatMessageReadReceipt>] = [:]
    
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
            
            return try await withCheckedThrowingContinuation { continuation in
                var didResume = false

                logger.info("Calling listMessages for threadId: \(threadId)")

                chatThreadClient.listMessages(withOptions: listChatMessagesOptions) { result, _ in
                    guard !didResume else {
                        self.logger.warning("Continuation already resumed for getInitialMessages")
                        return
                    }
                    didResume = true

                    switch result {
                    case .success(let messagesResult):
                        self.logger.info("Successfully received messages for thread \(threadId), count: \(messagesResult.items?.count ?? 0)")
                        self.chatMessagePagedCollections[threadId] = messagesResult
                        continuation.resume(returning: messagesResult.items ?? [])
                    case .failure(let error):
                        self.logger.error("Failed to list messages for thread \(threadId): \(error)")
                        self.chatMessagePagedCollections.removeValue(forKey: threadId)
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            logger.error("Failed to retrieve initial messages: \(error)")
            throw error
        }
    }

    
    func getListOfParticipants(for threadId: String) async throws -> [ChatParticipant] {
        do {
            let participantsPageSize: Int32 = 200
            let listParticipantsOptions = ListChatParticipantsOptions(maxPageSize: participantsPageSize)
            let chatThreadClient = try await getChatThreadClient(threadId: threadId)
            
            let pagedCollectionResult = try await chatThreadClient.listParticipants(
                withOptions: listParticipantsOptions)
            
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
            
            return try await withCheckedThrowingContinuation { continuation in
                if messagePagedCollection.isExhausted {
                    continuation.resume(returning: [])
                } else {
                    messagePagedCollection.nextPage { result in
                        switch result {
                        case .success(let messagesResult):
                            let previousMessages = messagesResult
                            continuation.resume(returning: previousMessages)
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
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
            
            return try await withCheckedThrowingContinuation { continuation in
                chatThreadClient.send(message: messageRequest) { result, _ in
                    switch result {
                    case let .success(result):
                        continuation.resume(returning: result.id)
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            logger.error("Retrieve Thread Topic failed: \(error)")
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
            
            return try await withCheckedThrowingContinuation { continuation in
                chatThreadClient.update(message: messageId, parameters: messageRequest) { result, _ in
                    switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
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
            
            return try await withCheckedThrowingContinuation { continuation in
                chatThreadClient.delete(message: messageId) { result, _ in
                    switch result {
                    case .success:
                        continuation.resume()
                    case .failure(let error):
                        continuation.resume(throwing: error)
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

            return try await withCheckedThrowingContinuation { continuation in
                chatThreadClient.listReadReceipts(withOptions: options) { result, _ in
                    switch result {
                    case .success(let pagedCollection):
                        self.readReceiptPagedCollections[threadId] = pagedCollection
                        continuation.resume(returning: pagedCollection.items ?? [])
                    case .failure(let error):
                        continuation.resume(throwing: error)
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
            
            return try await withCheckedThrowingContinuation { continuation in
                chatThreadClient.sendReadReceipt(
                    forMessage: messageId,
                    withOptions: SendChatReadReceiptOptions()) { result, error  in
                        switch result {
                        case .success:
                            continuation.resume(returning: Void())
                        case .failure(let error):
                            continuation.resume(throwing: error)
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
            
            return try await withCheckedThrowingContinuation { continuation in
                chatThreadClient.sendTypingNotification(from: self.chatConfiguration.displayName) { result, _ in
                    switch result {
                    case .success:
                        continuation.resume(returning: Void())
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        } catch {
            self.logger.error("Send Typing Indicator failed: \(error)")
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
        return try await withCheckedThrowingContinuation { continuation in
            do {
                logger.info("Creating Chat Thread Client...")

                guard let chatClient = self.chatClient else {
                    continuation.resume(throwing: NSError(
                        domain: "ChatThreadClientCreation",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "chatClient is nil"]
                    ))
                    return
                }

                let chatThreadClient = try chatClient.createClient(forThread: threadId)
                self.chatThreadClients.insert(chatThreadClient)
                continuation.resume(returning: chatThreadClient)
            } catch {
                logger.error("Create Chat Thread Client failed: \(error)")
                continuation.resume(throwing: error)
            }
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
    
    func unregisterRealTimeNotifications() async throws {
        guard let client = self.chatClient else {
            return
        }
        
        do {
            return try await withCheckedThrowingContinuation { continuation in
                client.stopRealTimeNotifications()
                continuation.resume(returning: Void())
            }
        } catch {
            self.logger.error("Stop real time notification failed: \(error)")
            throw error
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
}
// swiftlint:enable type_body_length
