package com.acs_plugin.chat.redux.reducer

import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.action.RepositoryAction
import com.acs_plugin.chat.redux.state.RepositoryState

internal interface RepositoryReducer : Reducer<RepositoryState>

internal class RepositoryReducerImpl : RepositoryReducer {
    override fun reduce(state: RepositoryState, action: Action): RepositoryState {
        return when (action) {
            is RepositoryAction.RepositoryUpdated -> state.copy(lastUpdatedTimestamp = System.currentTimeMillis())
            else -> state
        }
    }
}
