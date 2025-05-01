// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

internal enum class AudioFocusStatus {
    REQUESTING,
    APPROVED,
    REJECTED,
    INTERRUPTED,
}

internal data class AudioSessionState(val audioFocusStatus: AudioFocusStatus?,)
