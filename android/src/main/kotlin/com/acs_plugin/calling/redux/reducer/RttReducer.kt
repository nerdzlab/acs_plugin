// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.RttAction
import com.acs_plugin.calling.redux.state.RttState

internal interface RttReducer : Reducer<RttState>

internal class RttReducerImpl : RttReducer {
    override fun reduce(state: RttState, action: Action): RttState {

        return when (action) {
            is RttAction.EnableRtt -> {
                state.copy(isRttActive = true)
            }
            is RttAction.UpdateMaximized -> {
                state.copy(isMaximized = action.isMaximized)
            }
            else -> state
        }
    }
}
