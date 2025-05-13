// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import android.media.AudioManager
import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.error.CallStateError
import com.acs_plugin.calling.error.ErrorCode
import com.acs_plugin.calling.presentation.manager.NetworkManager
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.CallingAction
import com.acs_plugin.calling.redux.action.ErrorAction
import com.acs_plugin.calling.redux.state.CallingState
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.redux.state.PermissionStatus
import com.acs_plugin.calling.redux.state.isDisconnected
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class JoinCallButtonHolderViewModel(
    private val dispatch: (Action) -> Unit,
    private val audioManager: AudioManager,
    private val callType: CallType? = null,
    private val isTelecomManagerEnabled: Boolean = false,
) {

    private lateinit var joinCallButtonEnabledFlow: MutableStateFlow<Boolean>
    private var disableJoinCallButtonFlow = MutableStateFlow(false)
    private lateinit var networkManager: NetworkManager
    private var onStartCallBtnClicked: () -> Unit = {}

    fun getJoinCallButtonEnabledFlow(): StateFlow<Boolean> = joinCallButtonEnabledFlow

    fun getDisableJoinCallButtonFlow(): StateFlow<Boolean> = disableJoinCallButtonFlow

    fun isStartCall() = callType == CallType.ONE_TO_N_OUTGOING

    fun launchCallScreen() {
        val networkAvailable = isNetworkAvailable()
        // We try to check for mic availability for the current application through current audio mode
        val normalAudioMode = audioManager.mode == AudioManager.MODE_NORMAL

        if (!networkAvailable) {
            handleOffline()
        } else if (!normalAudioMode && !isTelecomManagerEnabled) {
            handleMicrophoneUnavailability()
        } else {
            onStartCallBtnClicked.invoke()
            dispatch(CallingAction.CallStartRequested())
            disableJoinCallButtonFlow.value = true
        }
    }

    fun init(
        audioPermissionState: PermissionStatus,
        cameraPermissionState: PermissionStatus,
        cameraOperationalStatus: CameraOperationalStatus,
        camerasCount: Int,
        networkManager: NetworkManager,
        onStartCallBtnClicked: () -> Unit
    ) {
        joinCallButtonEnabledFlow =
            MutableStateFlow(
                audioPermissionState == PermissionStatus.GRANTED &&
                    cameraPermissionState != PermissionStatus.UNKNOWN &&
                    (camerasCount == 0 || cameraOperationalStatus != CameraOperationalStatus.PENDING)
            )
        disableJoinCallButtonFlow.value = false
        this.networkManager = networkManager
        this.onStartCallBtnClicked = onStartCallBtnClicked
    }

    fun update(
        audioPermissionState: PermissionStatus,
        callingState: CallingState,
        cameraPermissionState: PermissionStatus,
        cameraOperationalStatus: CameraOperationalStatus,
        camerasCount: Int,
    ) {
        disableJoinCallButtonFlow.value =
            callingState.callingStatus != CallingStatus.NONE

        joinCallButtonEnabledFlow.value =
            audioPermissionState == PermissionStatus.GRANTED &&
            cameraPermissionState != PermissionStatus.UNKNOWN &&
            (camerasCount == 0 || cameraOperationalStatus != CameraOperationalStatus.PENDING)

        if (callingState.isDisconnected()) {
            disableJoinCallButtonFlow.value = false
        } else {
            disableJoinCallButtonFlow.value =
                callingState.callingStatus != CallingStatus.NONE || callingState.joinCallIsRequested
        }
    }

    fun handleOffline() {
        dispatch(ErrorAction.CallStateErrorOccurred(CallStateError(ErrorCode.NETWORK_NOT_AVAILABLE)))
    }

    fun handleMicrophoneUnavailability() {
        dispatch(ErrorAction.CallStateErrorOccurred(CallStateError(ErrorCode.MICROPHONE_NOT_AVAILABLE)))
    }

    fun isNetworkAvailable(): Boolean {
        return this.networkManager.isNetworkConnectionAvailable()
    }
}
