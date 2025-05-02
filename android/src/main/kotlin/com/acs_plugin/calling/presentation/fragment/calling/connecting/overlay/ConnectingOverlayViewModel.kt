// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.connecting.overlay

import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.error.ErrorCode
import com.acs_plugin.calling.error.FatalError
import com.acs_plugin.calling.presentation.manager.NetworkManager
import com.acs_plugin.calling.redux.action.ErrorAction
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.PermissionAction
import com.acs_plugin.calling.redux.state.AudioOperationalStatus
import com.acs_plugin.calling.redux.state.AudioState
import com.acs_plugin.calling.redux.state.CallingState
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.redux.state.CameraState
import com.acs_plugin.calling.redux.state.InitialCallJoinState
import com.acs_plugin.calling.redux.state.PermissionState
import com.acs_plugin.calling.redux.state.PermissionStatus
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class ConnectingOverlayViewModel(
    private val dispatch: (Action) -> Unit,
    private val isTelecomManagerEnabled: Boolean = false,
    private val callType: CallType? = null,
) {

    private lateinit var displayOverlayFlow: MutableStateFlow<Boolean>
    private lateinit var networkManager: NetworkManager

    private lateinit var cameraStateFlow: MutableStateFlow<CameraOperationalStatus>
    private lateinit var audioOperationalStatusStateFlow: MutableStateFlow<AudioOperationalStatus>

    fun isTelecomManagerEnabled() = isTelecomManagerEnabled

    fun getDisplayOverlayFlow(): StateFlow<Boolean> = displayOverlayFlow

    fun init(
        callingState: CallingState,
        permissionState: PermissionState,
        networkManager: NetworkManager,
        cameraState: CameraState,
        audioState: AudioState,
        initialCallJoinState: InitialCallJoinState,
    ) {
        this.networkManager = networkManager
        val displayOverlay = shouldDisplayOverlay(callingState, permissionState, initialCallJoinState)
        displayOverlayFlow = MutableStateFlow(displayOverlay)
        cameraStateFlow = MutableStateFlow(cameraState.operation)
        audioOperationalStatusStateFlow = MutableStateFlow(audioState.operation)
        if (displayOverlay) {
            handleOffline(this.networkManager)
        }
        if (permissionState.audioPermissionState == PermissionStatus.NOT_ASKED) {
            requestAudioPermission()
        }
    }

    fun update(
        callingState: CallingState,
        cameraOperationalStatus: CameraOperationalStatus,
        permissionState: PermissionState,
        audioOperationalStatus: AudioOperationalStatus,
        initialCallJoinState: InitialCallJoinState,
    ) {
        val displayOverlay = shouldDisplayOverlay(callingState, permissionState, initialCallJoinState)
        displayOverlayFlow.value = displayOverlay

        audioOperationalStatusStateFlow.value = audioOperationalStatus
        cameraStateFlow.value = cameraOperationalStatus

        handlePermissionDeniedEvent(permissionState)
        if (displayOverlay) {
            handleOffline(this.networkManager)
        }
    }

    fun getCameraStateFlow(): StateFlow<CameraOperationalStatus> {
        return cameraStateFlow
    }

    fun handleMicrophoneAccessFailed() {
        dispatchAction(
            action = ErrorAction.FatalErrorOccurred(
                FatalError(
                    Throwable(),
                    ErrorCode.MICROPHONE_NOT_AVAILABLE
                )
            )
        )
    }

    private fun requestAudioPermission() {
        dispatchAction(action = PermissionAction.AudioPermissionRequested())
    }

    private fun dispatchAction(action: Action) {
        dispatch(action)
    }

    private fun shouldDisplayOverlay(
        callingState: CallingState,
        permissionState: PermissionState,
        initialCallJoinState: InitialCallJoinState,
    ) =
        (
            callingState.callingStatus == CallingStatus.NONE ||
                (callingState.callingStatus == CallingStatus.CONNECTING && callType != CallType.ONE_TO_N_OUTGOING)
            ) &&
            permissionState.audioPermissionState != PermissionStatus.DENIED &&
            initialCallJoinState.skipSetupScreen

    private fun handleOffline(networkManager: NetworkManager) {
        if (!networkManager.isNetworkConnectionAvailable()) {
            dispatchAction(
                action = ErrorAction.FatalErrorOccurred(
                    FatalError(
                        Throwable(),
                        ErrorCode.INTERNET_NOT_AVAILABLE
                    )
                )
            )
        }
    }

    private fun handlePermissionDeniedEvent(permissionState: PermissionState) {
        if (permissionState.audioPermissionState == PermissionStatus.DENIED) {
            dispatchAction(
                action = ErrorAction.FatalErrorOccurred(
                    FatalError(
                        Throwable(),
                        ErrorCode.MIC_PERMISSION_DENIED
                    )
                )
            )
        }
    }
}
