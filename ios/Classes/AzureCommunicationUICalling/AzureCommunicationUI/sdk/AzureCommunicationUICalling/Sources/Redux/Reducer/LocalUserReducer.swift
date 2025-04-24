//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation

extension Reducer where State == LocalUserState,
                        Actions == LocalUserAction {
    static var liveLocalUserReducer: Self = Reducer { localUserState, action in

        var cameraStatus = localUserState.cameraState.operation
        var cameraDeviceStatus = localUserState.cameraState.device
        var cameraTransmissionStatus = localUserState.cameraState.transmission
        var cameraError = localUserState.cameraState.error

        var audioOperationStatus = localUserState.audioState.operation
        var audioDeviceStatus = localUserState.audioState.device
        var audioError = localUserState.audioState.error
        
        var backgroundEffectsOperationStatus = localUserState.backgroundEffectsState.operation
        var backgroundEffectsSelectedType = localUserState.backgroundEffectsState.effect
        var backgroundEffectsError = localUserState.backgroundEffectsState.error

        let initialDisplayName = localUserState.initialDisplayName
        var updatedDisplayName = localUserState.updatedDisplayName
        var localVideoStreamIdentifier = localUserState.localVideoStreamIdentifier
        var participantRole = localUserState.participantRole
        var capabilities = localUserState.capabilities
        var currentCapabilitiesAreDefault = localUserState.currentCapabilitiesAreDefault
        
        var noiseSuppressionStatus = localUserState.noiseSuppressionState.operation
        var incomingAudioStatus = localUserState.incomingAudioState.operation
        var meetingLayoutStatus = localUserState.meetingLayoutState.operation
        
        var raiseHandStatus = localUserState.raiseHandState.operation
        var raiseHandError = localUserState.raiseHandState.error
        var shareScreenStatus = localUserState.shareScreenState.operation
        
        switch action {
        case .cameraPreviewOnTriggered:
            cameraTransmissionStatus = .local
            cameraStatus = .pending
        case .cameraOnTriggered:
            cameraTransmissionStatus = .remote
            cameraStatus = .pending
        case .cameraOffTriggered:
            cameraStatus = .pending
        case .cameraOnSucceeded(let videoStreamId):
            localVideoStreamIdentifier = videoStreamId
            cameraStatus = .on
        case .cameraOnFailed(let error):
            cameraStatus = .off
            cameraError = error
        case .cameraOffSucceeded:
            localVideoStreamIdentifier = nil
            cameraStatus = .off
        case .cameraOffFailed(let error):
            cameraError = error
        case .cameraPausedSucceeded:
            cameraStatus = .paused
        case .cameraPausedFailed(let error):
            cameraError = error
        case .cameraSwitchTriggered:
            cameraDeviceStatus = .switching
        case .cameraSwitchSucceeded(let cameraDevice):
            cameraDeviceStatus = cameraDevice == .front ? .front : .back
        case .cameraSwitchFailed(let previousCamera, let error):
            cameraDeviceStatus = previousCamera
            cameraError = error
        case .microphoneOnTriggered,
                .microphoneOffTriggered:
            audioOperationStatus = .pending
        case .microphonePreviewOn:
            audioOperationStatus = .on
        case .microphoneOnFailed(let error):
            audioOperationStatus = .off
            audioError = error
        case .microphonePreviewOff:
            audioOperationStatus = .off
        case .microphoneMuteStateUpdated(let isMuted):
            audioOperationStatus = isMuted ? .off : .on
        case .microphoneOffFailed(let error):
            audioOperationStatus = .on
            audioError = error
        case .audioDeviceChangeRequested(let device):
            audioDeviceStatus = getRequestedDeviceStatus(for: device)
        case .audioDeviceChangeSucceeded(let device):
            audioDeviceStatus = getSelectedDeviceStatus(for: device)
            incomingAudioStatus = .unmuted
        case .audioDeviceChangeFailed(let error):
            audioError = error
        case .participantRoleChanged(let newParticipantRole):
            participantRole = newParticipantRole
        case .setCapabilities(let newCapabilities):
            capabilities = newCapabilities
            currentCapabilitiesAreDefault = false
        case .onCapabilitiesChanged(event: let event):
            break
        case .noiseSuppressionPreviewOn:
            noiseSuppressionStatus = .on
        case .noiseSuppressionPreviewOff:
            noiseSuppressionStatus = .off
        case .muteIncomingAudioOnPreviewRequested:
            incomingAudioStatus = .muted
        case .changeDisplayNameRequested(displayName: let name):
            updatedDisplayName = name
        case .gridLayoutSelected:
            meetingLayoutStatus = .grid
        case .speakerLayoutSelected:
            meetingLayoutStatus = .speaker
        case .raiseHandRequested:
            raiseHandStatus = .panding
            raiseHandError = nil
        case .raiseHandSucceeded:
            raiseHandStatus = .handIsRise
            raiseHandError = nil
        case .lowerHandRequested:
            raiseHandStatus = .panding
            raiseHandError = nil
        case .lowerHandSucceeded:
            raiseHandStatus = .handIsLower
            raiseHandError = nil
        case .raiseHandFailed(let error):
            raiseHandStatus = raiseHandStatus
            raiseHandError = error
        case .lowerHandFailed(let error):
            raiseHandStatus = raiseHandStatus
            raiseHandError = error
        case .backgroundEffectRequested(effect: let effect):
            backgroundEffectsOperationStatus = effect == .none ? .off : .on
            backgroundEffectsSelectedType = effect
        case .backgroundEffectSetFailed(error: let error):
            backgroundEffectsOperationStatus = .off
            backgroundEffectsSelectedType = .none
            backgroundEffectsError = error
        }

        let cameraState = LocalUserState.CameraState(operation: cameraStatus,
                                                     device: cameraDeviceStatus,
                                                     transmission: cameraTransmissionStatus,
                                                     error: cameraError)
        let audioState = LocalUserState.AudioState(operation: audioOperationStatus,
                                                   device: audioDeviceStatus,
                                                   error: audioError)
        
        let noiseSuppressionState = LocalUserState.NoiseSuppressionState(operation: noiseSuppressionStatus)
        
        let incomingAudioState = LocalUserState.IncomingAudioState(operation: incomingAudioStatus)
        
        let meetingLayoutState = LocalUserState.MeetingLayoutState(operation: meetingLayoutStatus)
        
        let raiseHandState = LocalUserState.RaiseHandState(operation: raiseHandStatus, error: raiseHandError)
        let shareScreenState = LocalUserState.ShareScreenState(operation: shareScreenStatus)
        
        let backgroundEffectsState = LocalUserState.BackgroundEffectsState(
            operation: backgroundEffectsOperationStatus,
            effect: backgroundEffectsSelectedType,
            error: backgroundEffectsError
        )
        
        return LocalUserState(cameraState: cameraState,
                              audioState: audioState,
                              initialDisplayName: initialDisplayName,
                              updatedDisplayName: updatedDisplayName,
                              localVideoStreamIdentifier: localVideoStreamIdentifier,
                              participantRole: participantRole,
                              capabilities: capabilities,
                              currentCapabilitiesAreDefault: currentCapabilitiesAreDefault,
                              noiseSuppressionState: noiseSuppressionState, incomingAudioState: incomingAudioState,
                              meetingLayoutState: meetingLayoutState,
                              raiseHandState: raiseHandState,
                              shareScreenState: shareScreenState,
                              backgroundEffectsState: backgroundEffectsState
        )
    }
}

private func getRequestedDeviceStatus(for audioDeviceType: AudioDeviceType)
-> LocalUserState.AudioDeviceSelectionStatus {
    switch audioDeviceType {
    case .speaker:
        return .speakerRequested
    case .receiver:
        return .receiverRequested
    case .bluetooth:
        return .bluetoothRequested
    case .headphones:
        return .headphonesRequested
    }
}

private func getSelectedDeviceStatus(for audioDeviceType: AudioDeviceType)
-> LocalUserState.AudioDeviceSelectionStatus {
    switch audioDeviceType {
    case .speaker:
        return .speakerSelected
    case .receiver:
        return .receiverSelected
    case .bluetooth:
        return .bluetoothSelected
    case .headphones:
        return .headphonesSelected
    }
}
