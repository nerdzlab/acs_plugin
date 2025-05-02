// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.notification

import com.acs_plugin.calling.models.CallDiagnosticModel
import com.acs_plugin.calling.models.UpperMessageBarNotificationModel
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.CallDiagnosticsAction
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class UpperMessageBarNotificationViewModel(
    private val dispatch: (Action) -> Unit,
    val upperMessageBarNotificationModel: UpperMessageBarNotificationModel
) {
    private var upperMessageBarNotificationModelFlow: MutableStateFlow<UpperMessageBarNotificationModel> = MutableStateFlow(upperMessageBarNotificationModel)
    private var dismissUpperMessageBarNotificationFlow: MutableStateFlow<Boolean> = MutableStateFlow(false)

    fun getDismissUpperMessageBarNotificationFlow(): StateFlow<Boolean> = dismissUpperMessageBarNotificationFlow

    fun getUpperMessageBarNotificationModelFlow(): StateFlow<UpperMessageBarNotificationModel> = upperMessageBarNotificationModelFlow

    fun dismissNotification() {
        dismissUpperMessageBarNotificationFlow.value = true
    }

    fun dismissNotificationByUser() {
        upperMessageBarNotificationModel.mediaCallDiagnostic?.let {
            dismissNotification()
            val model = CallDiagnosticModel(upperMessageBarNotificationModel.mediaCallDiagnostic, false)
            dispatch(CallDiagnosticsAction.MediaCallDiagnosticsDismissed(model))
        }
    }
}
