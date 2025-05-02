// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

import com.acs_plugin.calling.models.CallCompositeCaptionsType

internal enum class CaptionsStatus {
    START_REQUESTED,
    STARTED,
    STOP_REQUESTED,
    STOPPED,
    NONE
}

internal data class CaptionsState(
    val isCaptionsUIEnabled: Boolean = false,
    val status: CaptionsStatus = CaptionsStatus.NONE,
    val supportedSpokenLanguages: List<String> = emptyList(),
    val spokenLanguage: String? = null,
    val supportedCaptionLanguages: List<String> = emptyList(),
    val captionLanguage: String? = null,
    val isTranslationSupported: Boolean = false,
    val captionsType: CallCompositeCaptionsType = CallCompositeCaptionsType.NONE,
)
