// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

import com.acs_plugin.calling.models.CallCompositeAudioVideoMode
import com.acs_plugin.calling.models.CallCompositeLocalOptions
import com.acs_plugin.calling.models.ParticipantCapabilityType

internal class AppReduxState(
    displayName: String?,
    cameraOnByDefault: Boolean = false,
    microphoneOnByDefault: Boolean = false,
    skipSetupScreen: Boolean = false,
    avMode: CallCompositeAudioVideoMode = CallCompositeAudioVideoMode.AUDIO_AND_VIDEO,
    showCaptionsUI: Boolean = true,
    private val localOptions: CallCompositeLocalOptions? = null
) : ReduxState {

    fun copy(): AppReduxState {
        return AppReduxState(
            displayName = localParticipantState.displayName,
            cameraOnByDefault = localParticipantState.initialCallJoinState.startWithCameraOn,
            microphoneOnByDefault = localParticipantState.initialCallJoinState.startWithMicrophoneOn,
            skipSetupScreen = localParticipantState.initialCallJoinState.skipSetupScreen,
            avMode = localParticipantState.audioVideoMode,
            showCaptionsUI = captionsState.isCaptionsUIEnabled,
            localOptions = localOptions
        )
    }

    override var callState: CallingState = CallingState()

    override var remoteParticipantState: RemoteParticipantsState = RemoteParticipantsState(
        participantMap = HashMap(),
        participantMapModifiedTimestamp = 0,
        dominantSpeakersInfo = emptyList(),
        dominantSpeakersModifiedTimestamp = 0,
        lobbyErrorCode = null,
        totalParticipantCount = 0,
    )

    override var localParticipantState: LocalUserState =
        LocalUserState(
            CameraState(
                operation = CameraOperationalStatus.OFF,
                device = CameraDeviceSelectionStatus.FRONT,
                transmission = CameraTransmissionStatus.LOCAL,
                blurStatus = BlurStatus.OFF
            ),
            AudioState(
                operation = AudioOperationalStatus.OFF,
                device = AudioDeviceSelectionStatus.SPEAKER_SELECTED,
                noiseSuppression = NoiseSuppressionStatus.ON,
                bluetoothState = BluetoothState(
                    available = false,
                    deviceName = ""
                )
            ),
            videoStreamID = null,
            displayName = displayName,
            initialCallJoinState = InitialCallJoinState(
                startWithCameraOn = cameraOnByDefault,
                startWithMicrophoneOn = microphoneOnByDefault,
                skipSetupScreen = skipSetupScreen,
            ),
            localParticipantRole = null,
            audioVideoMode = avMode,
            capabilities = setOf(
                ParticipantCapabilityType.TURN_VIDEO_ON,
                ParticipantCapabilityType.UNMUTE_MICROPHONE
            ),
            currentCapabilitiesAreDefault = true,
        )

    override var permissionState: PermissionState =
        PermissionState(PermissionStatus.UNKNOWN, PermissionStatus.UNKNOWN)

    override var lifecycleState = LifecycleState(LifecycleStatus.FOREGROUND)

    override var errorState = ErrorState(fatalError = null, callStateError = null)

    override var navigationState = NavigationState(NavigationStatus.NONE)

    override var audioSessionState = AudioSessionState(audioFocusStatus = null)

    override var visibilityState = VisibilityState(status = VisibilityStatus.VISIBLE)

    override var callDiagnosticsState = CallDiagnosticsState(
        networkQualityCallDiagnostic = null,
        networkCallDiagnostic = null,
        mediaCallDiagnostic = null
    )

    override var toastNotificationState: ToastNotificationState = ToastNotificationState(emptyList())

    override var captionsState: CaptionsState = CaptionsState(isCaptionsUIEnabled = showCaptionsUI)

    override var callScreenInfoHeaderState: CallScreenInfoHeaderState = CallScreenInfoHeaderState(
        title = localOptions?.callScreenOptions?.headerViewData?.title,
        subtitle = localOptions?.callScreenOptions?.headerViewData?.subtitle,
        /* <CALL_START_TIME>
        // By default display call duration until Contoso set to false
        showCallDuration = localOptions?.callScreenOptions?.headerViewData?.showCallDuration ?: true,
        </CALL_START_TIME> */
    )

    override var rttState = RttState()

    override var buttonState: ButtonState = ButtonState(
        callScreenCameraButtonState = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.cameraButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.cameraButton?.isVisible,
        ),
        callScreenMicButtonState = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.microphoneButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.microphoneButton?.isVisible,
        ),
        callScreenAudioDeviceButtonState = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.audioDeviceButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.audioDeviceButton?.isVisible,
        ),
        liveCaptionsButton = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.liveCaptionsButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.liveCaptionsButton?.isVisible,
        ),
        liveCaptionsToggleButton = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.liveCaptionsButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.liveCaptionsToggleButton?.isVisible,
        ),
        spokenLanguageButton = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.spokenLanguageButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.spokenLanguageButton?.isVisible,
        ),
        captionsLanguageButton = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.captionsLanguageButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.captionsLanguageButton?.isVisible,
        ),
        shareDiagnosticsButton = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.shareDiagnosticsButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.shareDiagnosticsButton?.isVisible,
        ),
        reportIssueButton = DefaultButtonState(
            isEnabled = localOptions?.callScreenOptions?.controlBarOptions?.reportIssueButton?.isEnabled,
            isVisible = localOptions?.callScreenOptions?.controlBarOptions?.reportIssueButton?.isVisible,
        ),
        setupScreenAudioDeviceButtonState = DefaultButtonState(
            isEnabled = localOptions?.setupScreenOptions?.audioDeviceButton?.isEnabled,
            isVisible = localOptions?.setupScreenOptions?.audioDeviceButton?.isVisible,
        ),
        setupScreenCameraButtonState = DefaultButtonState(
            isEnabled = localOptions?.setupScreenOptions?.cameraButton?.isEnabled,
            isVisible = localOptions?.setupScreenOptions?.cameraButton?.isVisible,
        ),
        setupScreenMicButtonState = DefaultButtonState(
            isEnabled = localOptions?.setupScreenOptions?.microphoneButton?.isEnabled,
            isVisible = localOptions?.setupScreenOptions?.microphoneButton?.isVisible,
        ),
        setupScreenBlurButtonState = DefaultButtonState(
            isEnabled = localOptions?.setupScreenOptions?.blurButton?.isEnabled,
            isVisible = localOptions?.setupScreenOptions?.blurButton?.isVisible,
        ),
        setupScreenCameraSwitchButtonState = DefaultButtonState(
            isEnabled = localOptions?.setupScreenOptions?.cameraSwitchButton?.isEnabled,
            isVisible = localOptions?.setupScreenOptions?.cameraSwitchButton?.isVisible,
        ),
        callScreenCustomButtonsState = localOptions?.callScreenOptions?.controlBarOptions?.customButtons?.map {
            CustomButtonState(
                id = it.id,
                isEnabled = it.isEnabled,
                isVisible = it.isVisible,
                title = it.title,
                drawableId = it.drawableId,
            )
        } ?: emptyList(),
        callScreenHeaderCustomButtonsState = localOptions?.callScreenOptions?.headerViewData?.customButtons?.map {
            CustomButtonState(
                id = it.id,
                isEnabled = it.isEnabled,
                isVisible = it.isVisible,
                title = it.title,
                drawableId = it.drawableId,
            )
        } ?: emptyList()
    )

    override var deviceConfigurationState = DeviceConfigurationState(
        isSoftwareKeyboardVisible = false,
        isTablet = false,
        isPortrait = false,
    )
}
