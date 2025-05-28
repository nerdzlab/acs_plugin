package com.acs_plugin.chat.redux.reducer

import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.action.ErrorAction
import com.acs_plugin.chat.redux.state.ErrorState

internal interface ErrorReducer : Reducer<ErrorState>

internal class ErrorReducerImpl : ErrorReducer {
    override fun reduce(state: ErrorState, action: Action): ErrorState {
        when (action) {
            is ErrorAction.ChatStateErrorOccurred -> {
                return state.copy(
                    chatCompositeErrorEvent = action.chatCompositeErrorEvent
                )
            }
        }
        return state
    }
}
