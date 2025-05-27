//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationChat
import AzureCommunicationCommon
import Combine
import Foundation

protocol ChatSDKEventsHandling {
    func handle(response: TrouterEvent)
}

class ChatSDKEventsHandler: NSObject, ChatSDKEventsHandling {
    private let logger: Logger
    private let chatCompositeEventsHandler: ChatAdapter.Events
    
    init(
        logger: Logger,
        chatCompositeEventsHandler: ChatAdapter.Events
    ) {
        self.logger = logger
        self.chatCompositeEventsHandler = chatCompositeEventsHandler
    }

    // swiftlint:disable function_body_length
    func handle(response: TrouterEvent) {
        switch response {
        case .realTimeNotificationConnected:
            logger.info("Received a RealTimeNotificationConnected event")
            chatCompositeEventsHandler.onRealTimeNotificationConnected?()
            
        case .realTimeNotificationDisconnected:
            logger.info("Received a RealTimeNotificationDisconnected event")
            chatCompositeEventsHandler.onRealTimeNotificationDisconnected?()
            
        case let .chatMessageReceivedEvent(event):
            logger.info("Received a chatMessageReceivedEvent")
            chatCompositeEventsHandler.onChatMessageReceived?(event)
            
        case let .chatMessageEdited(event):
            logger.info("Received a chatMessageEdited")
            chatCompositeEventsHandler.onChatMessageEdited?(event)
            
        case let .chatMessageDeleted(event):
            logger.info("Received a chatMessageDeleted")
            chatCompositeEventsHandler.onChatMessageDeleted?(event)
            
        case let .typingIndicatorReceived(event):
            logger.info("Received a typingIndicatorReceived")
            chatCompositeEventsHandler.onTypingIndicatorReceived?(event)
            
        case let .readReceiptReceived(event):
            logger.info("Received a readReceiptReceived")
            chatCompositeEventsHandler.onReadReceiptReceived?(event)
            
        case let .chatThreadDeleted(event):
            logger.info("Received a chatThreadDeleted")
            chatCompositeEventsHandler.onChatThreadDeleted?(event)
            
        case let .chatThreadPropertiesUpdated(event):
            logger.info("Received a chatThreadPropertiesUpdated")
            chatCompositeEventsHandler.onChatThreadPropertiesUpdated?(event)
            
        case let .participantsAdded(event):
            logger.info("Received a participantsAdded")
            chatCompositeEventsHandler.onParticipantsAdded?(event)
            
        case let .participantsRemoved(event):
            logger.info("Received a participantsRemoved")
            chatCompositeEventsHandler.onParticipantsRemoved?(event)
            
        case let .chatThreadCreated(event):
            logger.info("Received a chatThreadCreated")
            chatCompositeEventsHandler.onChatThreadCreated?(event)
        }
    }
    // swiftlint:enable function_body_length
}
