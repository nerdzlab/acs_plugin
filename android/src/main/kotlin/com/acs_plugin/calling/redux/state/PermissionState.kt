// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

internal enum class PermissionStatus {
    UNKNOWN,
    GRANTED,
    DENIED,
    NOT_ASKED,
    REQUESTING,
}

internal data class PermissionState(
    // TODO: rename to micPermissionState
    val audioPermissionState: PermissionStatus,
    val cameraPermissionState: PermissionStatus,
)
