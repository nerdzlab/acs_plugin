// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class PreviewAreaViewModel(
    private val dispatch: (Action) -> Unit,
) {
    private lateinit var videoStreamIDStateFlow: MutableStateFlow<String?>

    fun getVideoStreamIDStateFlow(): StateFlow<String?> {
        return videoStreamIDStateFlow
    }

    fun update(
        videoStreamID: String?,
    ) {
        videoStreamIDStateFlow.value = videoStreamID
    }

    fun init(
        videoStreamID: String?,
    ) {
        videoStreamIDStateFlow = MutableStateFlow(videoStreamID)
    }

    fun switchCamera() {
        dispatchAction(action = LocalParticipantAction.CameraSwitchTriggered())
    }

    private fun dispatchAction(action: Action) {
        dispatch(action)
    }
}
