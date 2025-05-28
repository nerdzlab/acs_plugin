package com.acs_plugin.chat.redux.state

internal interface ReduxState {
    var chatState: ChatState
    var participantState: ParticipantsState
    var lifecycleState: LifecycleState
    var errorState: ErrorState
    var navigationState: NavigationState
    var repositoryState: RepositoryState
    var networkState: NetworkState
}
