// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.PermissionAction
import com.acs_plugin.calling.redux.state.PermissionState
import com.acs_plugin.calling.redux.state.PermissionStatus

internal interface PermissionStateReducer : Reducer<PermissionState>

internal class PermissionStateReducerImpl :
    PermissionStateReducer {
    override fun reduce(state: PermissionState, action: Action): PermissionState {
        return when (action) {
            is PermissionAction.AudioPermissionIsSet -> {
                state.copy(audioPermissionState = action.permissionState)
            }
            is PermissionAction.CameraPermissionIsSet -> {
                state.copy(cameraPermissionState = action.permissionState)
            }
            is PermissionAction.AudioPermissionRequested -> {
                state.copy(audioPermissionState = PermissionStatus.REQUESTING)
            }
            is PermissionAction.CameraPermissionRequested -> {
                state.copy(cameraPermissionState = PermissionStatus.REQUESTING)
            }
            else -> state
        }
    }
}
