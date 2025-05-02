// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

internal enum class LifecycleStatus {
    FOREGROUND,
    BACKGROUND,
}

internal data class LifecycleState(val state: LifecycleStatus)
