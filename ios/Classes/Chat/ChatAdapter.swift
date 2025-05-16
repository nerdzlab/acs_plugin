//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationCommon
import AzureCommunicationChat

/// This class represents the data-layer components of the Chat Composite.
public class ChatAdapter {
    
    /// The class to configure events closures for Chat Composite.
    public class Events {
        /// Closure to execute when error event occurs inside Chat Composite.
        public var onError: ((ChatCompositeError) -> Void)?
        /// Closure to execute when the real-time notification connection is established.
        var onRealTimeNotificationConnected: (() -> Void)?
        /// Closure to execute when the real-time notification connection is disconnected.
        var onRealTimeNotificationDisconnected: (() -> Void)?
        /// Closure to execute when a new chat message is received.
        var onChatMessageReceived: ((ChatMessageReceivedEvent) -> Void)?
        /// Closure to execute when a typing indicator is received.
        var onTypingIndicatorReceived: ((TypingIndicatorReceivedEvent) -> Void)?
        /// Closure to execute when a read receipt is received.
        var onReadReceiptReceived: ((ReadReceiptReceivedEvent) -> Void)?
        /// Closure to execute when a chat message is edited.
        var onChatMessageEdited: ((ChatMessageEditedEvent) -> Void)?
        /// Closure to execute when a chat message is deleted.
        var onChatMessageDeleted: ((ChatMessageDeletedEvent) -> Void)?
        /// Closure to execute when a new chat thread is created.
        var onChatThreadCreated: ((ChatThreadCreatedEvent) -> Void)?
        /// Closure to execute when a chat thread's properties are updated.
        var onChatThreadPropertiesUpdated: ((ChatThreadPropertiesUpdatedEvent) -> Void)?
        /// Closure to execute when a chat thread is deleted.
        var onChatThreadDeleted: ((ChatThreadDeletedEvent) -> Void)?
        /// Closure to execute when participants are added to a chat thread.
        var onParticipantsAdded: ((ParticipantsAddedEvent) -> Void)?
        /// Closure to execute when participants are removed from a chat thread.
        var onParticipantsRemoved: ((ParticipantsRemovedEvent) -> Void)?
    }
    
    /// The events handler for Chat Composite
    public let events: Events
    
    // Dependencies
    var logger: Logger = DefaultLogger(category: "ChatComponent")
    
    private var chatConfiguration: ChatConfiguration
    private var chatSDKWrapper: ChatSDKWrapper!
    private var lifeCycleManager: ChatLifeCycleManagerProtocol?
    
    private var threadId: String = ""
    /// Create an instance of this class with options.
    /// - Parameters:
    ///    - endpoint: The endpoint URL of The Communication Services.
    ///    - identifier: The CommunicationIdentifier that uniquely identifies an user
    ///    - credential: The credential that authenticates the user to a chat thread
    ///    - threadId: The unique identifier of a chat thread
    ///    - displayName: The display name that would be used when sending a chat message
    ///                   If this is `nil` the display name defined when adding the user to
    ///                   chat thread from the service would be used
    public init(endpoint: String,
                identifier: CommunicationIdentifier,
                credential: CommunicationTokenCredential,
                threadId: String,
                displayName: String? = nil) {
        self.chatConfiguration = ChatConfiguration(
            endpoint: endpoint,
            identifier: identifier,
            credential: credential,
            displayName: displayName)
        self.events = Events()
        self.threadId = threadId
    }
    
    deinit {
        logger.debug("Composite deallocated")
    }
    
    /// Start connection with chat client and registers for chat events
    /// This function should be called before adding the Chat Composite to a view
    public func connect() async throws {
        constructDependencies(
            chatConfiguration: self.chatConfiguration,
            chatThreadId: threadId,
            chatCompositeEventsHandler: events
        )
        
        try await initializeChat()
    }
    
    /// Unsubscribe all the chat client events from Azure Communication Service
    public func disconnect() async throws {
        try await unregisterRealTimeNotifications()
    }
    
    public func getInitialMessages() async throws -> [ChatMessage] {
        try await chatSDKWrapper.getInitialMessages()
    }
    
    public func retrieveChatThreadProperties() async throws -> ChatThreadProperties {
        return try await chatSDKWrapper.retrieveChatThreadProperties()
    }
    
    public func getListOfParticipants() async throws -> [ChatParticipant] {
        try await chatSDKWrapper.getListOfParticipants()
    }
    
    public func getPreviousMessages() async throws -> [ChatMessage] {
        try await chatSDKWrapper.getPreviousMessages()
    }
    
    public func sendMessage(
        content: String,
        senderDisplayName: String,
        type: ChatMessageType?,
        metadata: [String : String]?
    ) async throws -> String {
        return try await chatSDKWrapper.sendMessage(
            content: content,
            senderDisplayName: senderDisplayName,
            type: type,
            metadata: metadata
        )
    }
    
    public func editMessage(
        messageId: String,
        content: String,
        metadata: [String : String]?
    ) async throws {
        try await chatSDKWrapper.editMessage(
            messageId: messageId,
            content: content,
            metadata: metadata
        )
    }
    
    public func deleteMessage(messageId: String) async throws {
        try await chatSDKWrapper.deleteMessage(messageId: messageId)
    }
    
    public func sendReadReceipt(messageId: String) async throws {
        try await chatSDKWrapper.sendReadReceipt(messageId: messageId)
    }
    
    public func sendTypingIndicator() async throws {
        try await chatSDKWrapper.sendTypingIndicator()
    }
    
    private func unregisterRealTimeNotifications() async throws {
        try await chatSDKWrapper.unregisterRealTimeNotifications()
    }
    
    private func initializeChat() async throws {
        try await chatSDKWrapper.initializeChat()
    }
    
    private func cleanUpComposite() {
        self.lifeCycleManager = nil
    }
    
    public func isChatHasMoreMessages() async throws -> Bool {
        return try await chatSDKWrapper.isChatHasMoreMessages()
    }
    
    private func constructDependencies(
        chatConfiguration: ChatConfiguration,
        chatThreadId: String,
        chatCompositeEventsHandler: ChatAdapter.Events
    ) {
        let eventHandler = ChatSDKEventsHandler(
            logger: logger,
            chatCompositeEventsHandler: events
        )
        
        chatSDKWrapper = ChatSDKWrapper(
            logger: logger,
            chatEventsHandler: eventHandler,
            chatConfiguration: chatConfiguration,
            chatThreadId: chatThreadId
        )
        
        lifeCycleManager = ChatUIKitAppLifeCycleManager(
            logger: logger
        )
    }
}
