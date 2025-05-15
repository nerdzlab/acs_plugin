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

final class ChatHandler: MethodHandler {
    
    private enum Constants {
        enum MethodChannels {
            static let setupChat = "setupChat"
            static let disconnectChat = "disconnectChat"
            static let getInitialMessages = "getInitialMessages"
            static let retrieveChatThreadProperties = "retrieveChatThreadProperties"
            static let getListOfParticipants = "getListOfParticipants"
            static let getPreviousMessages = "getPreviousMessages"
            static let sendMessage = "sendMessage"
            static let editMessage = "editMessage"
            static let deleteMessage = "deleteMessage"
            static let sendReadReceipt = "sendReadReceipt"
            static let sendTypingIndicator = "sendTypingIndicator"
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
    
    private var chatAdapter: ChatAdapter?
    
    init(
        channel: FlutterMethodChannel,
        onGetUserData: @escaping () -> UserDataHandler.UserData?,
        onSendEvent: @escaping (Event) -> Void
    ) {
        self.channel = channel
        self.onGetUserData = onGetUserData
        self.onSendEvent = onSendEvent
    }
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case Constants.MethodChannels.setupChat:
            guard let args = call.arguments as? [String: Any],
                  let endpoint = args["endpoint"] as? String,
                  let threadId = args["threadId"] as? String
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing 'endpoint' or 'threadId'", details: nil))
                return true
            }
            setupChatAdapter(endpoint: endpoint, threadId: threadId, result: result)
            return true

        case Constants.MethodChannels.sendMessage:
            guard let args = call.arguments as? [String: Any],
                  let content = args["content"] as? String,
                  let senderDisplayName = args["senderDisplayName"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'content' or 'senderDisplayName'", details: nil))
                return true
            }
            sendMessage(content: content, senderDisplayName: senderDisplayName, result: result)
            return true

        case Constants.MethodChannels.editMessage:
            guard let args = call.arguments as? [String: Any],
                  let messageId = args["messageId"] as? String,
                  let content = args["content"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'messageId' or 'content'", details: nil))
                return true
            }
            editMessage(messageId: messageId, content: content, result: result)
            return true

        case Constants.MethodChannels.deleteMessage:
            guard let args = call.arguments as? [String: Any],
                  let messageId = args["messageId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'messageId'", details: nil))
                return true
            }
            deleteMessage(messageId: messageId, result: result)
            return true

        case Constants.MethodChannels.sendReadReceipt:
            guard let args = call.arguments as? [String: Any],
                  let messageId = args["messageId"] as? String
            else {
                result(FlutterError(code: "MISSING_ARGUMENTS", message: "Missing 'messageId'", details: nil))
                return true
            }
            sendReadReceipt(messageId: messageId, result: result)
            return true

        case Constants.MethodChannels.sendTypingIndicator:
            sendTypingIndicator(result: result)
            return true
            
        case Constants.MethodChannels.disconnectChat:
            disconnectChat(result: result)
            return true

        case Constants.MethodChannels.getInitialMessages:
            getInitialMessages(result: result)
            return true

        case Constants.MethodChannels.retrieveChatThreadProperties:
            retrieveChatThreadProperties(result: result)
            return true

        case Constants.MethodChannels.getListOfParticipants:
            getListOfParticipants(result: result)
            return true

        case Constants.MethodChannels.getPreviousMessages:
            getPreviousMessages(result: result)
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
    
    private func setupChatAdapter(endpoint: String, threadId: String, result: @escaping FlutterResult) {
        guard let userData = onGetUserData() else {
            result(FlutterError(code: "INVALID_ARGUMENTS", message: "User data not set", details: nil))
            return }
        
        Task {
            do {
                let credential = try CommunicationTokenCredential(token: userData.token)
                
                self.chatAdapter = ChatAdapter(
                    endpoint: endpoint,
                    identifier: CommunicationUserIdentifier(userData.userId),
                    credential: credential,
                    threadId: threadId,
                    displayName: userData.name
                )
                
                try await chatAdapter?.connect()
                self.subscribeToChatEvents()
                
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
    
    private func disconnectChat(result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.disconnect()
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
    
    private func getInitialMessages(result: @escaping FlutterResult) {
        Task {
            do {
                let messages = try await chatAdapter?.getInitialMessages() ?? []
                result(messages.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func retrieveChatThreadProperties(result: @escaping FlutterResult) {
        Task {
            do {
                let properties = try await chatAdapter?.retrieveChatThreadProperties()
                result(properties?.toJson())
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func getListOfParticipants(result: @escaping FlutterResult) {
        Task {
            do {
                let participants = try await chatAdapter?.getListOfParticipants() ?? []
                result(participants.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func getPreviousMessages(result: @escaping FlutterResult) {
        Task {
            do {
                let messages = try await chatAdapter?.getPreviousMessages() ?? []
                result(messages.map { $0.toJson() })
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func sendMessage(content: String, senderDisplayName: String, result: @escaping FlutterResult) {
        Task {
            do {
                let messageId = try await chatAdapter?.sendMessage(content: content, senderDisplayName: senderDisplayName)
                result(messageId)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func editMessage(messageId: String, content: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.editMessage(messageId: messageId, content: content)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func deleteMessage(messageId: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.deleteMessage(messageId: messageId)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func sendReadReceipt(messageId: String, result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.sendReadReceipt(messageId: messageId)
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }

    private func sendTypingIndicator(result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.sendTypingIndicator()
                result(nil)
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
}
