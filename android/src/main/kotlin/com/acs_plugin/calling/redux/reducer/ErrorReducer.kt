// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.ErrorAction
import com.acs_plugin.calling.redux.state.ErrorState

internal interface ErrorReducer : Reducer<ErrorState>

internal class ErrorReducerImpl : ErrorReducer {
    override fun reduce(state: ErrorState, action: Action): ErrorState {
        return when (action) {
            is ErrorAction.FatalErrorOccurred -> {
                state.copy(fatalError = action.error, callStateError = state.callStateError)
            }
            is ErrorAction.CallStateErrorOccurred -> {
                state.copy(fatalError = state.fatalError, callStateError = action.callStateError)
            }
            else -> state
        }
    }
}
