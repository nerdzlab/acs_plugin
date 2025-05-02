// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class SetupGradientViewModel {
    private lateinit var displaySetupGradientFlow: MutableStateFlow<Boolean>

    fun getDisplaySetupGradientFlow(): StateFlow<Boolean> = displaySetupGradientFlow

    fun update(
        videoStreamID: String?,
        cameraOperationalStatus: CameraOperationalStatus,
    ) {
        displaySetupGradientFlow.value = isVideoDisplayed(videoStreamID, cameraOperationalStatus)
    }

    fun init(
        videoStreamID: String?,
        cameraOperationalStatus: CameraOperationalStatus,
    ) {
        displaySetupGradientFlow =
            MutableStateFlow(isVideoDisplayed(videoStreamID, cameraOperationalStatus))
    }

    private fun isVideoDisplayed(
        videoStreamID: String?,
        cameraOperationalStatus: CameraOperationalStatus,
    ) = !videoStreamID.isNullOrEmpty() && cameraOperationalStatus == CameraOperationalStatus.ON
}
