//
//  UserDataHandler 2.swift
//  Pods
//
//  Created by Yriy Malyts on 13.05.2025.
//

import Flutter
import ReplayKit
import UIKit
import AzureCommunicationCalling
import AzureCommunicationCommon
import PushKit
import AzureCommunicationChat

final class ChatHandler: MethodHandler {
    
    private enum Constants {
        enum MethodChannels {
            static let setupChatService = "setupChatService"
            static let disconnectChatService = "disconnectChatService"
            static let initChatThread = "initChatThread"
            static let getInitialMessages = "getInitialMessages"
            static let retrieveChatThreadProperties = "retrieveChatThreadProperties"
            static let getListOfParticipants = "getListOfParticipants"
            static let getPreviousMessages = "getPreviousMessages"
            static let sendMessage = "sendMessage"
            static let editMessage = "editMessage"
            static let deleteMessage = "deleteMessage"
            static let sendReadReceipt = "sendReadReceipt"
            static let sendTypingIndicator = "sendTypingIndicator"
            static let isChatHasMoreMessages = "isChatHasMoreMessages"
            static let getListReadReceipts = "getListReadReceipts"
        }
        
        enum FlutterEvents {
            static let onChatError = "onChatError"
            static let onRemoteParticipantJoined = "onRemoteParticipantJoined"
            static let onUnreadMessagesCountChanged = "onUnreadMessagesCountChanged"
            static let onNewMessageReceived = "onNewMessageReceived"
            
            static let onRealTimeNotificationConnected = "onRealTimeNotificationConnected"
            static let onRealTimeNotificationDisconnected = "onRealTimeNotificationDisconnected"
            static let onChatMessageReceived = "onChatMessageReceived"
            static let onTypingIndicatorReceived = "onTypingIndicatorReceived"
            static let onReadReceiptReceived = "onReadReceiptReceived"
            static let onChatMessageEdited = "onChatMessageEdited"
            static let onChatMessageDeleted = "onChatMessageDeleted"
            static let onChatThreadCreated = "onChatThreadCreated"
            static let onChatThreadPropertiesUpdated = "onChatThreadPropertiesUpdated"
            static let onChatThreadDeleted = "onChatThreadDeleted"
            static let onParticipantsAdded = "onParticipantsAdded"
            static let onParticipantsRemoved = "onParticipantsRemoved"
        }
    }
        
    private let channel: FlutterMethodChannel
    private let onGetUserData: () -> UserDataHandler.UserData?
    private let onSendEvent: (Event) -> Void
    private let tokenRefresher: ((@escaping (String?, Error?) -> Void) -> Void)?
    
    private var apnsToken: String?
    private var appGroupId: String?
    private var chatAdapter: ChatAdapter?
    
    init(
        channel: FlutterMethodChannel,
        onGetUserData: @escaping () -> UserDataHandler.UserData?,
        onSendEvent: @escaping (Event) -> Void,
        tokenRefresher: ((@escaping (String?, Error?) -> Void) -> Void)?
    ) {
        self.channel = channel
        self.onGetUserData = onGetUserData
        self.onSendEvent = onSendEvent
        self.tokenRefresher = tokenRefresher
    }
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case Constants.MethodChannels.setupChatService:
            guard let args = call.arguments as? [String: Any],
                  let endpoint = args["endpoint"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing 'endpoint'", details: nil))
                return true
            }
            setupChatAdapter(endpoint: endpoint, result: result)
            return true
            
        case Constants.MethodChannels.initChatThread:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            initializeChatThread(threadId: threadId, result: result)
            return true
            

        case Constants.MethodChannels.sendMessage:
            guard let args = call.arguments as? [String: Any],
                  let content = args["content"] as? String,
                  let senderDisplayName = args["senderDisplayName"] as? String,
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'content' or 'senderDisplayName'", details: nil))
                return true
            }
            
            var type: ChatMessageType?
            
            if let rawType = args["type"] as? String {
                type = ChatMessageType(rawType)
            }
            
            var metadata: [String : String]?
            
            if let rawMetaData = args["metadata"] as? [String : String] {
                metadata = rawMetaData
            }
            
            sendMessage(
                threadId: threadId,
                content: content,
                senderDisplayName: senderDisplayName,
                type: type,
                metadata: metadata,
                result: result
            )
            return true

        case Constants.MethodChannels.editMessage:
            guard let args = call.arguments as? [String: Any],
                  let messageId = args["messageId"] as? String,
                  let content = args["content"] as? String,
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'messageId' or 'content'", details: nil))
                return true
            }
            
            var metadata: [String : String]?
            
            if let rawMetaData = args["metadata"] as? [String : String] {
                metadata = rawMetaData
            }
            
            editMessage(
                threadId: threadId,
                messageId: messageId,
                content: content,
                metadata: metadata,
                result: result
            )
            return true

        case Constants.MethodChannels.deleteMessage:
            guard let args = call.arguments as? [String: Any],
                  let messageId = args["messageId"] as? String,
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'messageId'", details: nil))
                return true
            }
            deleteMessage(threadId: threadId, messageId: messageId, result: result)
            return true

        case Constants.MethodChannels.sendReadReceipt:
            guard let args = call.arguments as? [String: Any],
                  let messageId = args["messageId"] as? String,
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'messageId'", details: nil))
                return true
            }
            sendReadReceipt(threadId: threadId, messageId: messageId, result: result)
            return true

        case Constants.MethodChannels.sendTypingIndicator:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            sendTypingIndicator(threadId: threadId, result: result)
            return true
            
        case Constants.MethodChannels.disconnectChatService:
            disconnectChatService(result: result)
            return true

        case Constants.MethodChannels.getInitialMessages:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            getInitialMessages(threadId: threadId, result: result)
            return true

        case Constants.MethodChannels.retrieveChatThreadProperties:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            retrieveChatThreadProperties(threadId: threadId, result: result)
            return true

        case Constants.MethodChannels.getListOfParticipants:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            getListOfParticipants(threadId: threadId, result: result)
            return true

        case Constants.MethodChannels.getPreviousMessages:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            getPreviousMessages(threadId: threadId, result: result)
            return true

        case Constants.MethodChannels.isChatHasMoreMessages:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            isChatHasMoreMessages(threadId: threadId, result: result)
            return true
            
        case Constants.MethodChannels.getListReadReceipts:
            guard let args = call.arguments as? [String: Any],
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'threadId'", details: nil))
                return true
            }
            
            getListReadReceipts(threadId: threadId, result: result)
            return true


        default:
            return false
        }
    }
    
    private func subscribeToChatEvents() {
        // Listening for when the real-time notification connection is established
        chatAdapter?.events.onRealTimeNotificationConnected = { [weak self] in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onRealTimeNotificationConnected
                )
            )
        }
        
        // Listening for when the real-time notification connection is disconnected
        chatAdapter?.events.onRealTimeNotificationDisconnected = { [weak self] in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onRealTimeNotificationDisconnected
                )
            )
        }
        
        // Listening for a new chat message received
        chatAdapter?.events.onChatMessageReceived = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onChatMessageReceived,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a typing indicator received
        chatAdapter?.events.onTypingIndicatorReceived = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onTypingIndicatorReceived,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a read receipt received
        chatAdapter?.events.onReadReceiptReceived = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onReadReceiptReceived,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a chat message edited
        chatAdapter?.events.onChatMessageEdited = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onChatMessageEdited,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a chat message deleted
        chatAdapter?.events.onChatMessageDeleted = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onChatMessageDeleted,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a new chat thread created
        chatAdapter?.events.onChatThreadCreated = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onChatThreadCreated,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a chat thread properties updated
        chatAdapter?.events.onChatThreadPropertiesUpdated = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onChatThreadPropertiesUpdated,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for a chat thread deleted
        chatAdapter?.events.onChatThreadDeleted = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onChatThreadDeleted,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for participants added to a chat thread
        chatAdapter?.events.onParticipantsAdded = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onParticipantsAdded,
                    payload: event.toJson()
                )
            )
        }
        
        // Listening for participants removed from a chat thread
        chatAdapter?.events.onParticipantsRemoved = { [weak self] event in
            self?.onSendEvent(
                Event(
                    name: Constants.FlutterEvents.onParticipantsRemoved,
                    payload: event.toJson()
                )
            )
        }
    }
    
    private func setupChatAdapter(endpoint: String, result: @escaping FlutterResult) {
        guard let userData = onGetUserData() else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "User data not set", details: nil))
            return }
        
        Task {
            do {
                guard let tokenRefresher = self.tokenRefresher else {
                    return
                }
                
                let refreshOptions = CommunicationTokenRefreshOptions(
                    initialToken: userData.token,
                    refreshProactively: true,
                    tokenRefresher: tokenRefresher
                )
                
                let credential = try CommunicationTokenCredential(withOptions: refreshOptions)
                
                self.chatAdapter = ChatAdapter(
                    endpoint: endpoint,
                    identifier: CommunicationUserIdentifier(userData.userId),
                    credential: credential,
                    displayName: userData.name
                )
                
                try await chatAdapter?.connect()
                self.subscribeToChatEvents()
                self.setupPushnotifications()
                
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func initializeChatThread(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.initializeChatThread(threadId: threadId)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func handleChatError(_ error: Error, result: @escaping FlutterResult) {
        if let chatError = error as? ChatCompositeError {
            result(FlutterError(
                code: "ChatCompositeError",
                message: "ErrorCode: \(chatError.code), Message: \(chatError.error?.localizedDescription ?? "")",
                details: nil
            ))
        } else {
            result(FlutterError(
                code: "UnknownError",
                message: error.localizedDescription,
                details: nil
            ))
        }
    }
    
    private func disconnectChatService(result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.disconnect()
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func getInitialMessages(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                let messages = try await chatAdapter?.getInitialMessages(threadId: threadId) ?? []
                result(messages.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func retrieveChatThreadProperties(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                let properties = try await chatAdapter?.retrieveChatThreadProperties(threadId: threadId)
                result(properties?.toJson())
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func getListOfParticipants(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                let participants = try await chatAdapter?.getListOfParticipants(threadId: threadId) ?? []
                result(participants.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func getPreviousMessages(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                let messages = try await chatAdapter?.getPreviousMessages(threadId: threadId) ?? []
                result(messages.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func getListReadReceipts(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                let readReceipts = try await chatAdapter?.getListReadReceipts(threadId: threadId) ?? []
                result(readReceipts.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func sendMessage(
        threadId: String,
        content: String,
        senderDisplayName: String,
        type: ChatMessageType?,
        metadata: [String: String]?,
        result: @escaping FlutterResult
    ) {
        Task {
            do {
                let messageId = try await chatAdapter?.sendMessage(
                    threadId: threadId,
                    content: content,
                    senderDisplayName: senderDisplayName,
                    type: type,
                    metadata: metadata
                )
                result(messageId)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func editMessage(
        threadId: String,
        messageId: String,
        content: String,
        metadata: [String: String]?,
        result: @escaping FlutterResult
    ) {
        Task {
            do {
                try await chatAdapter?.editMessage(
                    threadId: threadId,
                    messageId: messageId,
                    content: content,
                    metadata: metadata
                )
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func deleteMessage(threadId: String, messageId: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.deleteMessage(threadId: threadId, messageId: messageId)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func sendReadReceipt(threadId: String, messageId: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.sendReadReceipt(threadId: threadId, messageId: messageId)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func sendTypingIndicator(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.sendTypingIndicator(threadId: threadId)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func isChatHasMoreMessages(threadId: String, result: @escaping FlutterResult) {
        Task {
            do {
                let isChatHasMoreMessages = try await chatAdapter?.isChatHasMoreMessages(threadId: threadId)
                result(isChatHasMoreMessages)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func setupPushnotifications() {
        guard let apnsToken = apnsToken, let appGroupId = appGroupId else {
            return
        }
        
        chatAdapter?.setupPushNotifications(apnsToken: apnsToken, appGroupId: appGroupId)
    }
    
    func setAPNSData(apnsToken: String, appGroupId: String) {
        self.apnsToken = apnsToken
        self.appGroupId = appGroupId
        
        setupPushnotifications()
    }
}
