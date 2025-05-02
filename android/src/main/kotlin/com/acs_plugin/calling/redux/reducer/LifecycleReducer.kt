// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LifecycleAction
import com.acs_plugin.calling.redux.state.LifecycleState
import com.acs_plugin.calling.redux.state.LifecycleStatus

internal interface LifecycleReducer : Reducer<LifecycleState>

internal class LifecycleReducerImpl : LifecycleReducer {
    override fun reduce(state: LifecycleState, action: Action): LifecycleState {
        return when (action) {
            is LifecycleAction.EnterBackgroundSucceeded -> {
                state.copy(state = LifecycleStatus.BACKGROUND)
            }
            is LifecycleAction.EnterForegroundSucceeded -> {
                state.copy(state = LifecycleStatus.FOREGROUND)
            }
            else -> state
        }
    }
}
