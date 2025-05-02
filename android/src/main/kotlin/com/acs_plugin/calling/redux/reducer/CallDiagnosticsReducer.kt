// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.CallDiagnosticsAction
import com.acs_plugin.calling.redux.state.CallDiagnosticsState

internal interface CallDiagnosticsReducer : Reducer<CallDiagnosticsState>

internal class CallDiagnosticsReducerImpl : CallDiagnosticsReducer {

    override fun reduce(
        state: CallDiagnosticsState,
        action: Action
    ): CallDiagnosticsState {
        return when (action) {
            is CallDiagnosticsAction.NetworkQualityCallDiagnosticsUpdated -> {
                state.copy(networkQualityCallDiagnostic = action.networkQualityCallDiagnosticModel)
            }
            is CallDiagnosticsAction.NetworkCallDiagnosticsUpdated -> {
                state.copy(networkCallDiagnostic = action.networkCallDiagnosticModel)
            }
            is CallDiagnosticsAction.MediaCallDiagnosticsUpdated -> {
                state.copy(mediaCallDiagnostic = action.mediaCallDiagnosticModel)
            }
            is CallDiagnosticsAction.NetworkQualityCallDiagnosticsDismissed -> {
                state.copy(networkQualityCallDiagnostic = action.networkQualityCallDiagnosticModel)
            }
            is CallDiagnosticsAction.NetworkCallDiagnosticsDismissed -> {
                state.copy(networkCallDiagnostic = action.networkCallDiagnosticModel)
            }
            is CallDiagnosticsAction.MediaCallDiagnosticsDismissed -> {
                state.copy(mediaCallDiagnostic = action.mediaCallDiagnosticModel)
            }
            else -> state
        }
    }
}
