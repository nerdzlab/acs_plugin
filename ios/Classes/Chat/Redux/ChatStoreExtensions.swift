//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation

typealias ChatActionDispatch = CommonActionDispatch<ActionChat>

extension Store where State == ChatAppState, Action == ActionChat {
    static func constructStore(
        logger: Logger,
        chatService: ChatServiceProtocol,
        messageRepository: MessageRepositoryManagerProtocol,
        chatConfiguration: ChatConfiguration,
        chatThreadId: String,
        connectEventHandler: ((Result<Void, ChatCompositeError>) -> Void)?
    ) -> Store<State, Action> {

        return Store<State, Action>(
            reducer: .appStateReducer(),
            middlewares: [
                .liveChatMiddleware(
                    chatActionHandler: ChatActionHandler(
                        chatService: chatService,
                        logger: logger,
                        connectEventHandler: connectEventHandler
                    ),
                    chatServiceEventHandler: ChatServiceEventHandler(
                        chatService: chatService, logger: logger
                    )
                ),
                .liveRepositoryMiddleware(
                    repositoryMiddlewareHandler: RepositoryMiddlewareHandler(
                        messageRepository: messageRepository,
                        logger: logger
                    )
                )
            ],
            state: ChatAppState(
                chatState: ChatState(
                    localUser: ChatParticipantInfoModel(
                        identifier: chatConfiguration.identifier,
                        displayName: chatConfiguration.displayName ?? "",
                        isLocalParticipant: true
                    ),
                    threadId: chatThreadId
                )
            )
        )
    }
}
