//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationChat
import Combine

protocol ChatSDKWrapperProtocol {
    func initializeChat() async throws
    func getInitialMessages(for threadId: String) async throws -> [ChatMessage]
    func getListOfParticipants(for threadId: String) async throws -> [ChatParticipant]
    func getPreviousMessages(for threadId: String) async throws -> [ChatMessage]
    func deleteMessage(threadId: String, messageId: String) async throws
    func sendReadReceipt(threadId: String, messageId: String) async throws
    func sendTypingIndicator(threadId: String) async throws
    func isChatHasMoreMessages(threadId: String) async throws -> Bool
    func unregisterRealTimeNotifications() async throws
    var chatEventsHandler: ChatSDKEventsHandling { get }
    
    func sendMessage(
        threadId: String,
        content: String,
        senderDisplayName: String,
        type: ChatMessageType?,
        metadata: [String: String]?
    ) async throws -> String
    
    func editMessage(
        threadId: String,
        messageId: String,
        content: String,
        metadata: [String: String]?
    ) async throws
}
