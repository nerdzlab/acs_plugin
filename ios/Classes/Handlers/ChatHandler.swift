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
        }
    }
    
    private let channel: FlutterMethodChannel
    private let onGetUserData: () -> UserDataHandler.UserData?
    private let onSendEvent: (String) -> Void
    
    private var chatAdapter: ChatAdapter?
    
    init(
        channel: FlutterMethodChannel,
        onGetUserData: @escaping () -> UserDataHandler.UserData?,
        onSendEvent: @escaping (String) -> Void
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
}
