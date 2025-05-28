package com.acs_plugin.chat.redux.reducer

import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.state.LifecycleState

internal interface LifecycleReducer : Reducer<LifecycleState>

internal class LifecycleReducerImpl : LifecycleReducer {
    override fun reduce(state: LifecycleState, action: Action): LifecycleState {
        return state
    }
}
