// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

import com.acs_plugin.calling.error.CallCompositeError
import com.acs_plugin.calling.models.CallCompositeAudioVideoMode
import com.acs_plugin.calling.models.ParticipantCapabilityType
import com.acs_plugin.calling.models.ParticipantRole

internal enum class CameraOperationalStatus {
    PENDING,
    ON,
    OFF,
    PAUSED,
}

internal enum class CameraDeviceSelectionStatus {
    FRONT,
    BACK,
    UNKNOWN,
    RIGHT_FRONT,
    LEFT_FRONT,
    PANORAMIC,
    EXTERNAL,
    SWITCHING,
}

internal enum class CameraTransmissionStatus {
    LOCAL,
    REMOTE,
}

internal enum class BlurStatus {
    ON,
    OFF
}

internal enum class AudioOperationalStatus {
    ON,
    OFF,
    PENDING,
}

internal enum class AudioDeviceSelectionStatus {
    SPEAKER_SELECTED,
    SPEAKER_REQUESTED,
    RECEIVER_SELECTED,
    RECEIVER_REQUESTED,
    BLUETOOTH_SCO_SELECTED,
    BLUETOOTH_SCO_REQUESTED,
    AUDIO_OFF_SELECTED,
    AUDIO_OFF_REQUESTED,
}

internal enum class NoiseSuppressionStatus {
    ON,
    OFF
}

internal enum class RaisedHandStatus {
    RAISED,
    LOWER
}

internal data class CameraState(
    val operation: CameraOperationalStatus,
    val device: CameraDeviceSelectionStatus,
    val transmission: CameraTransmissionStatus,
    val camerasCount: Int = 0,
    val error: CallCompositeError? = null,
    val blurStatus: BlurStatus
)

internal data class AudioState(
    val operation: AudioOperationalStatus,
    val device: AudioDeviceSelectionStatus,
    val bluetoothState: BluetoothState,
    val noiseSuppression: NoiseSuppressionStatus,
    val error: CallCompositeError? = null,
    val isHeadphonePlugged: Boolean = false
)

internal data class BluetoothState(
    val available: Boolean,
    val deviceName: String,
)

internal data class InitialCallJoinState(
    val startWithCameraOn: Boolean = false,
    val startWithMicrophoneOn: Boolean = false,
    val skipSetupScreen: Boolean = false,
)

// Actual default values are set in the AppReduxState
internal data class LocalUserState(
    val cameraState: CameraState,
    val audioState: AudioState,
    val videoStreamID: String?,
    val displayName: String?,
    val initialCallJoinState: InitialCallJoinState = InitialCallJoinState(),
    val localParticipantRole: ParticipantRole?,
    val audioVideoMode: CallCompositeAudioVideoMode = CallCompositeAudioVideoMode.AUDIO_AND_VIDEO,
    val capabilities: Set<ParticipantCapabilityType> = emptySet(),
    val currentCapabilitiesAreDefault: Boolean = true,
    val raisedHandStatus: RaisedHandStatus
)
