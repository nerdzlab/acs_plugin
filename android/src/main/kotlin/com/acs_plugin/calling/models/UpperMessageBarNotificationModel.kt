// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal data class UpperMessageBarNotificationModel(
    val notificationIconId: Int,
    val notificationMessageId: Int,
    val mediaCallDiagnostic: MediaCallDiagnostic?
) {
    fun isEmpty(): Boolean {
        return notificationIconId == 0 && notificationMessageId == 0
    }
}
