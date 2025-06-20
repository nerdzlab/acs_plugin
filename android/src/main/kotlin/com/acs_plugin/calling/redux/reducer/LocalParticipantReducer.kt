// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.action.NavigationAction
import com.acs_plugin.calling.redux.state.AudioOperationalStatus
import com.acs_plugin.calling.redux.state.BlurStatus
import com.acs_plugin.calling.redux.state.CameraDeviceSelectionStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.redux.state.CameraTransmissionStatus
import com.acs_plugin.calling.redux.state.LocalUserState
import com.acs_plugin.calling.redux.state.MeetingViewMode
import com.acs_plugin.calling.redux.state.NoiseSuppressionStatus
import com.acs_plugin.calling.redux.state.RaisedHandStatus
import com.acs_plugin.calling.redux.state.ShareScreenStatus

internal interface LocalParticipantStateReducer : Reducer<LocalUserState>

internal class LocalParticipantStateReducerImpl : LocalParticipantStateReducer {

    override fun reduce(localUserState: LocalUserState, action: Action): LocalUserState {
        return when (action) {
            is LocalParticipantAction.CameraOnRequested -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.PENDING)
                )
            }
            is LocalParticipantAction.CameraOnTriggered -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.PENDING)
                )
            }
            is LocalParticipantAction.CameraOnSucceeded -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        operation = CameraOperationalStatus.ON,
                        error = null
                    ),
                    videoStreamID = action.videoStreamID
                )
            }
            is LocalParticipantAction.CameraOnFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        operation = CameraOperationalStatus.OFF,
                        error = action.error
                    )
                )
            }

            is LocalParticipantAction.CameraOffTriggered -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.PENDING)
                )
            }
            is LocalParticipantAction.CameraOffSucceeded -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.OFF),
                    videoStreamID = null
                )
            }
            is LocalParticipantAction.CameraOffFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        operation = CameraOperationalStatus.ON,
                        error = action.error
                    )
                )
            }

            is LocalParticipantAction.CameraSwitchTriggered -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(device = CameraDeviceSelectionStatus.SWITCHING)
                )
            }
            is LocalParticipantAction.CameraSwitchSucceeded -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        device = action.cameraDeviceSelectionStatus,
                    )
                )
            }
            is LocalParticipantAction.CameraSwitchFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        device = action.previousDevice,
                        error = action.error,
                    )
                )
            }

            is LocalParticipantAction.CameraPreviewOnRequested -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.PENDING)
                )
            }

            is LocalParticipantAction.CameraPreviewOnTriggered -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.PENDING)
                )
            }
            is LocalParticipantAction.CameraPreviewOnSucceeded -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        operation = CameraOperationalStatus.ON,
                        error = null
                    ),
                    videoStreamID = action.videoStreamID
                )
            }
            is LocalParticipantAction.CameraPreviewOnFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        operation = CameraOperationalStatus.OFF,
                        error = action.error
                    )
                )
            }
            is LocalParticipantAction.BlurOnFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        blurStatus = BlurStatus.OFF
                    )
                )
            }
            is LocalParticipantAction.BlurOffFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        blurStatus = BlurStatus.ON
                    )
                )
            }

            is LocalParticipantAction.CameraPreviewOffTriggered -> {
                localUserState.copy(
                    // in this case we go straight OFF
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.OFF),
                    videoStreamID = null
                )
            }
            is LocalParticipantAction.CameraPauseFailed -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(error = action.error)
                )
            }
            is LocalParticipantAction.CameraPauseSucceeded -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(operation = CameraOperationalStatus.PAUSED),
                    videoStreamID = null
                )
            }
            is LocalParticipantAction.CamerasCountUpdated -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(camerasCount = action.count)
                )
            }

            is LocalParticipantAction.MicPreviewOffTriggered -> {
                localUserState.copy(audioState = localUserState.audioState.copy(operation = AudioOperationalStatus.OFF))
            }
            is LocalParticipantAction.MicPreviewOnTriggered -> {
                localUserState.copy(audioState = localUserState.audioState.copy(operation = AudioOperationalStatus.ON))
            }
            is LocalParticipantAction.MicOffTriggered -> {
                localUserState.copy(audioState = localUserState.audioState.copy(operation = AudioOperationalStatus.PENDING))
            }
            is LocalParticipantAction.AudioStateOperationUpdated -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        operation = action.audioOperationalStatus,
                        error = null
                    )
                )
            }
            is LocalParticipantAction.MicOffFailed -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        operation = AudioOperationalStatus.ON,
                        error = action.error
                    )
                )
            }
            is LocalParticipantAction.MicOnTriggered -> {
                localUserState.copy(audioState = localUserState.audioState.copy(operation = AudioOperationalStatus.PENDING))
            }
            is LocalParticipantAction.MicOnFailed -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        operation = AudioOperationalStatus.OFF,
                        error = action.error
                    )
                )
            }
            is LocalParticipantAction.AudioDeviceBluetoothSCOAvailable -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        bluetoothState = localUserState.audioState.bluetoothState.copy(
                            available = action.available,
                            deviceName = action.deviceName
                        )

                    )
                )
            }
            is LocalParticipantAction.AudioDeviceHeadsetAvailable -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        isHeadphonePlugged = action.available
                    )
                )
            }
            is LocalParticipantAction.AudioDeviceChangeRequested -> {

                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        device = action.requestedAudioDevice,
                        error = null
                    )
                )
            }

            is LocalParticipantAction.AudioDeviceChangeSucceeded -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        device = action.selectedAudioDevice,
                        error = null
                    )
                )
            }
            is LocalParticipantAction.AudioDeviceChangeFailed -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(
                        device = action.previousDevice,
                        error = action.error
                    )
                )
            }
            is LocalParticipantAction.DisplayNameIsSet -> {
                localUserState.copy(
                    displayName = action.displayName
                )
            }
            is NavigationAction.CallLaunched, is NavigationAction.CallLaunchWithoutSetup -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        transmission = CameraTransmissionStatus.REMOTE
                    )
                )
            }
            is NavigationAction.SetupLaunched -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(
                        transmission = CameraTransmissionStatus.LOCAL
                    )
                )
            }
            is LocalParticipantAction.RoleChanged -> {
                localUserState.copy(
                    localParticipantRole = action.participantRole
                )
            }
            is LocalParticipantAction.SetCapabilities -> {
                localUserState.copy(
                    capabilities = action.capabilities,
                    currentCapabilitiesAreDefault = false,
                )
            }
            is LocalParticipantAction.BlurPreviewOnTriggered -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(blurStatus = BlurStatus.ON)
                )
            }

            is LocalParticipantAction.BlurPreviewOffTriggered -> {
                localUserState.copy(
                    cameraState = localUserState.cameraState.copy(blurStatus = BlurStatus.OFF)
                )
            }
            is LocalParticipantAction.NoiseSuppressionOnTriggered -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(noiseSuppression = NoiseSuppressionStatus.ON)
                )
            }

            is LocalParticipantAction.NoiseSuppressionOffTriggered -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(noiseSuppression = NoiseSuppressionStatus.OFF)
                )
            }
            is LocalParticipantAction.NoiseSuppressionOffFailed -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(noiseSuppression = NoiseSuppressionStatus.ON)
                )
            }

            is LocalParticipantAction.NoiseSuppressionOnFailed -> {
                localUserState.copy(
                    audioState = localUserState.audioState.copy(noiseSuppression = NoiseSuppressionStatus.OFF)
                )
            }
            is LocalParticipantAction.RaiseHandTriggered -> {
                localUserState.copy(
                    raisedHandStatus = RaisedHandStatus.RAISED
                )
            }

            is LocalParticipantAction.LowerHandTriggered -> {
                localUserState.copy(
                    raisedHandStatus = RaisedHandStatus.LOWER
                )
            }
            is LocalParticipantAction.RaiseHandFailed -> {
                localUserState.copy(
                    raisedHandStatus = RaisedHandStatus.LOWER
                )
            }

            is LocalParticipantAction.LowerHandFailed -> {
                localUserState.copy(
                    raisedHandStatus = RaisedHandStatus.RAISED
                )
            }

            is LocalParticipantAction.SendReactionTriggered -> {
                localUserState.copy(
                    reactionType = action.reactionType
                )
            }
            is LocalParticipantAction.SendReactionFailed -> {
                localUserState.copy(
                    reactionType = null
                )
            }

            is LocalParticipantAction.ShareScreenTriggered -> {
                localUserState.copy(
                    shareScreenStatus = ShareScreenStatus.ON
                )
            }
            is LocalParticipantAction.ShareScreenFailed -> {
                localUserState.copy(
                    shareScreenStatus = ShareScreenStatus.OFF
                )
            }

            is LocalParticipantAction.StopShareScreenTriggered -> {
                localUserState.copy(
                    shareScreenStatus = ShareScreenStatus.OFF
                )
            }
            is LocalParticipantAction.StopShareScreenFailed -> {
                localUserState.copy(
                    shareScreenStatus = ShareScreenStatus.ON
                )
            }

            is LocalParticipantAction.GalleryViewTriggered -> {
                localUserState.copy(
                    meetingViewModeModifiedTimestamp = System.currentTimeMillis(),
                    meetingViewMode = MeetingViewMode.GALLERY
                )
            }
            is LocalParticipantAction.SpeakerViewTriggered -> {
                localUserState.copy(
                    meetingViewModeModifiedTimestamp = System.currentTimeMillis(),
                    meetingViewMode = MeetingViewMode.SPEAKER
                )
            }

            else -> localUserState
        }
    }
}
