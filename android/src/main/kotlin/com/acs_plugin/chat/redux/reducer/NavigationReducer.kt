package com.acs_plugin.chat.redux.reducer

import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.action.NavigationAction
import com.acs_plugin.chat.redux.state.NavigationState
import com.acs_plugin.chat.redux.state.NavigationStatus

internal interface NavigationReducer : Reducer<NavigationState>

internal class NavigationReducerImpl : NavigationReducer {
    override fun reduce(state: NavigationState, action: Action): NavigationState {
        return when (action) {
            is NavigationAction.GotoParticipants -> {
                state.copy(navigationStatus = NavigationStatus.PARTICIPANTS)
            }
            is NavigationAction.Pop -> {
                state.copy(navigationStatus = NavigationStatus.NONE)
            }
            else -> state
        }
    }
}
