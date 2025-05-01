// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

internal enum class VisibilityStatus {
    VISIBLE,
    HIDE_REQUESTED,
    HIDDEN,
    PIP_MODE_ENTERED,
}

internal data class VisibilityState(val status: VisibilityStatus)
