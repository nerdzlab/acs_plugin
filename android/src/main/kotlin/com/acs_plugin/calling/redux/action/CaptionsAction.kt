// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.action

import com.acs_plugin.calling.models.CallCompositeCaptionsType
import com.acs_plugin.calling.redux.state.CaptionsStatus

internal sealed class CaptionsAction : Action {
    class StartRequested(val language: String?) : CaptionsAction()
    class StopRequested : CaptionsAction()
    class UpdateStatus(val status: CaptionsStatus) : CaptionsAction()
    class SetSpokenLanguageRequested(val language: String) : CaptionsAction()
    class SpokenLanguageChanged(val language: String) : CaptionsAction()
    class SetCaptionLanguageRequested(val language: String) : CaptionsAction()
    class CaptionLanguageChanged(val language: String) : CaptionsAction()
    class TypeChanged(val type: CallCompositeCaptionsType) : CaptionsAction()
    class IsTranslationSupportedChanged(val isSupported: Boolean) : CaptionsAction()
    class SupportedSpokenLanguagesChanged(val languages: List<String>) : CaptionsAction()
    class SupportedCaptionLanguagesChanged(val languages: List<String>) : CaptionsAction()
}
