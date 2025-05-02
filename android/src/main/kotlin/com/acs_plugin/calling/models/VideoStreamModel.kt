// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal enum class StreamType {
    VIDEO,
    SCREEN_SHARING,
}

internal data class VideoStreamModel(val videoStreamID: String, val streamType: StreamType)
