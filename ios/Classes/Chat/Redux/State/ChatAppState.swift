//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

struct ChatAppState {
    let lifeCycleState: ChatLifeCycleState
    let chatState: ChatState
    let participantsState: ChatParticipantsState
    let navigationState: ChatNavigationState
    let repositoryState: RepositoryState
    let errorState: ChatErrorState

    init(lifeCycleState: ChatLifeCycleState = .init(),
         chatState: ChatState = .init(),
         participantsState: ChatParticipantsState = .init(),
         navigationState: ChatNavigationState = .init(),
         repositoryState: RepositoryState = .init(),
         errorState: ChatErrorState = .init()) {
        self.lifeCycleState = lifeCycleState
        self.chatState = chatState
        self.participantsState = participantsState
        self.navigationState = navigationState
        self.repositoryState = repositoryState
        self.errorState = errorState
    }
}
