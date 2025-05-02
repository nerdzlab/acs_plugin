// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.state.PermissionState
import com.acs_plugin.calling.redux.state.PermissionStatus
import kotlinx.coroutines.flow.MutableStateFlow

internal class PermissionWarningViewModel(private val dispatch: (Action) -> Unit) {
    lateinit var cameraPermissionStateFlow: MutableStateFlow<PermissionStatus>
    lateinit var audioPermissionStateFlow: MutableStateFlow<PermissionStatus>

    fun update(
        permissionState: PermissionState,
    ) {
        cameraPermissionStateFlow.value = permissionState.cameraPermissionState
        audioPermissionStateFlow.value = permissionState.audioPermissionState
    }

    fun init(
        permissionState: PermissionState,
    ) {
        cameraPermissionStateFlow = MutableStateFlow(permissionState.cameraPermissionState)
        audioPermissionStateFlow = MutableStateFlow(permissionState.audioPermissionState)
    }

    fun turnCameraOn() {
        dispatchAction(action = LocalParticipantAction.CameraPreviewOnRequested())
    }

    private fun dispatchAction(action: Action) {
        dispatch(action)
    }
}
