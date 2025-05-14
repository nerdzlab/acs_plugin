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
            if let arguments = call.arguments as? [String: Any],
               let endpoint = arguments["endpoint"] as? String,
               let threadId = arguments["threadId"] as? String
            {
                setupChatAdapter(endpoint: endpoint, threadId: threadId, result: result)
                
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, name and userId are required", details: nil))
            }
            
            return true
            
        case Constants.MethodChannels.disconnectChat:
            disconnectChat(result: result)
            
            return true
            
        default:
            return false
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
                
                result("Chat connected")
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
    
    private func disconnectChat(result: @escaping FlutterResult) {
        Task {
            do {
                try await chatAdapter?.disconnect()
                
                result("Chat disconnected")
            } catch {
                handleChatError(error, result: result)
            }
        }
    }
}
