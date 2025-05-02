// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal fun buildCallCompositeAudioSelectionChangedEvent(mode: CallCompositeAudioSelectionMode): CallCompositeAudioSelectionChangedEvent {
    return CallCompositeAudioSelectionChangedEvent(mode)
}
