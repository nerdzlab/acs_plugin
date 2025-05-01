// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.action

import com.acs_plugin.calling.redux.state.ToastNotificationKind

internal sealed class ToastNotificationAction : Action {
    class ShowNotification(val kind: ToastNotificationKind) : ToastNotificationAction()
    class DismissNotification(val kind: ToastNotificationKind) : ToastNotificationAction()
}
