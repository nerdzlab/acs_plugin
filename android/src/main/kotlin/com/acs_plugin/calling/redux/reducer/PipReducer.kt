// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.PipAction
import com.acs_plugin.calling.redux.state.VisibilityState
import com.acs_plugin.calling.redux.state.VisibilityStatus

// TODO: VisibilityReducer
internal interface PipReducer : Reducer<VisibilityState>

internal class PipReducerImpl : PipReducer {
    override fun reduce(state: VisibilityState, action: Action): VisibilityState {
        return when (action) {
            is PipAction.PipModeEntered -> {
                state.copy(status = VisibilityStatus.PIP_MODE_ENTERED)
            }
            is PipAction.ShowNormalEntered -> {
                state.copy(status = VisibilityStatus.VISIBLE)
            }
            is PipAction.HideRequested -> {
                state.copy(status = VisibilityStatus.HIDE_REQUESTED)
            }
            is PipAction.HideEntered -> {
                state.copy(status = VisibilityStatus.HIDDEN)
            }
            else -> state
        }
    }
}
