// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import android.content.Context
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.models.CallCompositeAudioVideoMode
import com.acs_plugin.calling.models.CallCompositeButtonViewData
import com.acs_plugin.calling.models.CallCompositeSetupScreenOptions
import com.acs_plugin.calling.models.createButtonClickEvent
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.action.PermissionAction
import com.acs_plugin.calling.redux.state.AudioOperationalStatus
import com.acs_plugin.calling.redux.state.AudioState
import com.acs_plugin.calling.redux.state.BlurStatus
import com.acs_plugin.calling.redux.state.ButtonState
import com.acs_plugin.calling.redux.state.CallingState
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.redux.state.CameraState
import com.acs_plugin.calling.redux.state.PermissionState
import com.acs_plugin.calling.redux.state.PermissionStatus
import com.acs_plugin.calling.redux.state.isDisconnected
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class SetupControlBarViewModel(
    private val dispatch: (Action) -> Unit,
    private val logger: Logger,
) {
    private lateinit var isCameraButtonEnabledStateFlow: MutableStateFlow<Boolean>
    private lateinit var isCameraButtonVisibleStateFlow: MutableStateFlow<Boolean>

    private lateinit var isMicButtonVisibleStateFlow: MutableStateFlow<Boolean>
    private lateinit var isMicButtonEnabledStateFlow: MutableStateFlow<Boolean>
    private lateinit var isAudioDeviceButtonEnabledStateFlow: MutableStateFlow<Boolean>

    private lateinit var visibleStateFlow: MutableStateFlow<Boolean>
    private lateinit var cameraStateFlow: MutableStateFlow<CameraOperationalStatus>

    private lateinit var isAudioDeviceButtonVisibleFlow: MutableStateFlow<Boolean>
    private lateinit var audioOperationalStatusStateFlow: MutableStateFlow<AudioOperationalStatus>
    private lateinit var audioDeviceSelectionStatusStateFlow: MutableStateFlow<AudioState>

    private lateinit var blurStateFlow: MutableStateFlow<BlurStatus>
    private lateinit var isBlurEnabledStateFlow: MutableStateFlow<Boolean>

    private lateinit var isCameraSwitchEnabledStateFlow: MutableStateFlow<Boolean>

    private lateinit var openAudioDeviceSelectionMenu: () -> Unit

    private var cameraButton: CallCompositeButtonViewData? = null
    private var cameraSwitchButton: CallCompositeButtonViewData? = null
    private var micButton: CallCompositeButtonViewData? = null
    private var audioDeviceButton: CallCompositeButtonViewData? = null
    private var blurButton: CallCompositeButtonViewData? = null

    fun init(
        permissionState: PermissionState,
        cameraState: CameraState,
        audioVideoMode: CallCompositeAudioVideoMode,
        audioState: AudioState,
        callingState: CallingState,
        openAudioDeviceSelectionMenuCallback: () -> Unit,
        setupScreenOptions: CallCompositeSetupScreenOptions?,
        buttonState: ButtonState,
    ) {
        cameraButton = setupScreenOptions?.cameraButton
        micButton = setupScreenOptions?.microphoneButton
        audioDeviceButton = setupScreenOptions?.audioDeviceButton

        visibleStateFlow = MutableStateFlow(isVisible(permissionState.audioPermissionState))
        isCameraButtonEnabledStateFlow = MutableStateFlow(shouldCameraButtonBeEnabled(callingState, permissionState.cameraPermissionState, buttonState))
        isCameraButtonVisibleStateFlow = MutableStateFlow(shouldCameraButtonBeVisible(audioVideoMode, buttonState))

        isMicButtonVisibleStateFlow = MutableStateFlow(shouldMicButtonBeVisible(buttonState))
        isMicButtonEnabledStateFlow = MutableStateFlow(shouldMicButtonBeEnabled(callingState, audioState.operation, buttonState))
        isAudioDeviceButtonEnabledStateFlow = MutableStateFlow(shouldAudioDeviceButtonBeEnabled(callingState, buttonState))
        isAudioDeviceButtonVisibleFlow = MutableStateFlow(shouldAudioDeviceButtonBeVisible(buttonState))

        cameraStateFlow = MutableStateFlow(cameraState.operation)
        audioOperationalStatusStateFlow = MutableStateFlow(audioState.operation)
        openAudioDeviceSelectionMenu = openAudioDeviceSelectionMenuCallback
        audioDeviceSelectionStatusStateFlow = MutableStateFlow(audioState)

        isCameraSwitchEnabledStateFlow = MutableStateFlow(shouldSwitchCameraBeEnabled(cameraState.operation))

        blurStateFlow = MutableStateFlow(cameraState.blurStatus)
        isBlurEnabledStateFlow = MutableStateFlow(shouldBlurBeEnabled(cameraState.operation))

        if (permissionState.audioPermissionState == PermissionStatus.NOT_ASKED) {
            requestAudioPermission()
        }
    }

    fun update(
        permissionState: PermissionState,
        cameraState: CameraState,
        audioVideoMode: CallCompositeAudioVideoMode,
        audioState: AudioState,
        callingState: CallingState,
        buttonState: ButtonState,
    ) {
        visibleStateFlow.value = isVisible(permissionState.audioPermissionState)
        isCameraButtonEnabledStateFlow.value = shouldCameraButtonBeEnabled(callingState, permissionState.cameraPermissionState, buttonState)
        isCameraButtonVisibleStateFlow.value = shouldCameraButtonBeVisible(audioVideoMode, buttonState)

        isMicButtonEnabledStateFlow.value = shouldMicButtonBeEnabled(callingState, audioState.operation, buttonState)
        isMicButtonVisibleStateFlow.value = shouldMicButtonBeVisible(buttonState)

        isAudioDeviceButtonVisibleFlow.value = shouldAudioDeviceButtonBeVisible(buttonState)
        isAudioDeviceButtonEnabledStateFlow.value = shouldAudioDeviceButtonBeEnabled(callingState, buttonState)

        cameraStateFlow.value = cameraState.operation
        audioOperationalStatusStateFlow.value = audioState.operation
        audioDeviceSelectionStatusStateFlow.value = audioState

        isCameraSwitchEnabledStateFlow.value = shouldSwitchCameraBeEnabled(cameraState.operation)

        blurStateFlow.value = cameraState.blurStatus
        isBlurEnabledStateFlow.value = shouldBlurBeEnabled(cameraState.operation)
    }

    private fun isVisible(audioPermissionState: PermissionStatus): Boolean {
        return audioPermissionState != PermissionStatus.DENIED
    }

    val cameraIsEnabled: StateFlow<Boolean> get() = isCameraButtonEnabledStateFlow
    val cameraIsVisible: StateFlow<Boolean> get() = isCameraButtonVisibleStateFlow
    val micIsEnabled: StateFlow<Boolean> get() = isMicButtonEnabledStateFlow
    val micVisible: StateFlow<Boolean> get() = isMicButtonVisibleStateFlow

    val audioDeviceButtonVisible: StateFlow<Boolean> get() = isAudioDeviceButtonVisibleFlow
    val audioDeviceButtonEnabled: StateFlow<Boolean> get() = isAudioDeviceButtonEnabledStateFlow
    val isVisibleState: StateFlow<Boolean> get() = visibleStateFlow
    val cameraState: StateFlow<CameraOperationalStatus> get() = cameraStateFlow

    val audioOperationalStatusStat: StateFlow<AudioOperationalStatus> get() = audioOperationalStatusStateFlow
    val audioDeviceSelectionStatusState: StateFlow<AudioState> get() = audioDeviceSelectionStatusStateFlow

    val switchCameraEnabled: StateFlow<Boolean> get() = isCameraSwitchEnabledStateFlow

    val blurEnabled: StateFlow<Boolean> get() = isBlurEnabledStateFlow
    val blurState: StateFlow<BlurStatus> get() = blurStateFlow

    fun turnCameraOn(context: Context) {
        callOnClickHandler(context, cameraButton)
        dispatchAction(
            action = LocalParticipantAction.CameraPreviewOnRequested()
        )
    }

    fun turnCameraOff(context: Context) {
        callOnClickHandler(context, cameraButton)
        dispatchAction(
            action = LocalParticipantAction.CameraPreviewOffTriggered()
        )
    }

    fun turnMicOn(context: Context) {
        callOnClickHandler(context, micButton)
        dispatchAction(
            action = LocalParticipantAction.MicPreviewOnTriggered()
        )
    }

    fun turnMicOff(context: Context) {
        callOnClickHandler(context, micButton)
        dispatchAction(
            action = LocalParticipantAction.MicPreviewOffTriggered()
        )
    }

    fun switchCamera(context: Context) {
        callOnClickHandler(context, cameraSwitchButton)
        dispatchAction(
            action = (LocalParticipantAction.CameraSwitchTriggered())
        )
    }

    fun turnBlurOn(context: Context) {
        callOnClickHandler(context, blurButton)
        dispatchAction(
            action = LocalParticipantAction.BlurPreviewOnTriggered()
        )
    }

    fun turnBlurOff(context: Context) {
        callOnClickHandler(context, blurButton)
        dispatchAction(
            action = LocalParticipantAction.BlurPreviewOffTriggered()
        )
    }

    fun audioDeviceClicked(context: Context) {
        callOnClickHandler(context, audioDeviceButton)
        openAudioDeviceSelectionMenu()
    }

    private fun requestAudioPermission() {
        dispatchAction(action = PermissionAction.AudioPermissionRequested())
    }

    private fun dispatchAction(action: Action) {
        dispatch(action)
    }

    private fun shouldCameraButtonBeVisible(
        audioVideoMode: CallCompositeAudioVideoMode,
        buttonState: ButtonState,
    ): Boolean {
        return buttonState.setupScreenCameraButtonState?.isVisible ?: true &&
            audioVideoMode == CallCompositeAudioVideoMode.AUDIO_AND_VIDEO
    }

    private fun shouldCameraButtonBeEnabled(
        callingState: CallingState,
        cameraPermissionState: PermissionStatus,
        buttonState: ButtonState,
    ): Boolean {
        return !shouldControlsBeDisabled(callingState) &&
            cameraPermissionState != PermissionStatus.DENIED &&
            buttonState.setupScreenCameraButtonState?.isEnabled ?: true
    }

    private fun shouldMicButtonBeEnabled(
        callingState: CallingState,
        audioStateOperation: AudioOperationalStatus,
        buttonState: ButtonState
    ): Boolean {
        return !shouldControlsBeDisabled(callingState) &&
            audioStateOperation != AudioOperationalStatus.PENDING &&
            buttonState.setupScreenMicButtonState?.isEnabled != false
    }

    private fun shouldAudioDeviceButtonBeVisible(buttonState: ButtonState): Boolean {
        return buttonState.setupScreenAudioDeviceButtonState?.isVisible ?: true
    }

    private fun shouldAudioDeviceButtonBeEnabled(
        callingState: CallingState,
        buttonState: ButtonState
    ): Boolean {
        return buttonState.setupScreenAudioDeviceButtonState?.isEnabled ?: true &&
            !shouldControlsBeDisabled(callingState)
    }

    private fun shouldMicButtonBeVisible(buttonState: ButtonState): Boolean {
        return buttonState.setupScreenMicButtonState?.isVisible ?: true
    }

    private fun shouldControlsBeDisabled(callingState: CallingState): Boolean {
        if (callingState.isDisconnected())
            return false
        return callingState.joinCallIsRequested || callingState.callingStatus != CallingStatus.NONE
    }

    private fun shouldSwitchCameraBeEnabled(cameraOperationalStatus: CameraOperationalStatus): Boolean {
        return cameraOperationalStatus == CameraOperationalStatus.ON
    }

    private fun shouldBlurBeEnabled(cameraOperationalStatus: CameraOperationalStatus): Boolean {
        return cameraOperationalStatus == CameraOperationalStatus.ON
    }

    private fun callOnClickHandler(
        context: Context,
        buttonOptions: CallCompositeButtonViewData?,
    ) {
        try {
            buttonOptions?.onClickHandler?.handle(
                createButtonClickEvent(context, buttonOptions)
            )
        } catch (e: Exception) {
            logger.error("Call screen control bar button custom onClick exception.", e)
        }
    }
}
