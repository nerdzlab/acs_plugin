// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.ToastNotificationAction
import com.acs_plugin.calling.redux.state.ToastNotificationState

internal interface ToastNotificationReducer : Reducer<ToastNotificationState>

internal class ToastNotificationReducerImpl : ToastNotificationReducer {
    override fun reduce(state: ToastNotificationState, action: Action): ToastNotificationState {
        return when (action) {
            is ToastNotificationAction.ShowNotification -> {
                state.copy(kinds = state.kinds + action.kind)
            }
            is ToastNotificationAction.DismissNotification -> {
                state.copy(kinds = state.kinds.filter { it != action.kind })
            }
            else -> state
        }
    }
}
