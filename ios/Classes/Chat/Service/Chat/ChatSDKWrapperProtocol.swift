//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationChat
import Combine

protocol ChatSDKWrapperProtocol {
    func initializeChat() async throws
    func getInitialMessages() async throws -> [ChatMessage]
    func retrieveChatThreadProperties() async throws -> ChatThreadProperties
    func getListOfParticipants() async throws -> [ChatParticipant]
    func getPreviousMessages() async throws -> [ChatMessage]
    func sendMessage(content: String, senderDisplayName: String) async throws -> String
    func editMessage(messageId: String, content: String) async throws
    func deleteMessage(messageId: String) async throws
    func sendReadReceipt(messageId: String) async throws
    func sendTypingIndicator() async throws

    func unregisterRealTimeNotifications() async throws
    var chatEventsHandler: ChatSDKEventsHandling { get }
}
