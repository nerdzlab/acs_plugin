//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine

enum LocalUserAction: Equatable {

    case cameraPreviewOnTriggered
    case cameraOnTriggered
    case cameraOnSucceeded(videoStreamIdentifier: String)
    case cameraOnFailed(error: Error)

    case cameraOffTriggered
    case cameraOffSucceeded
    case cameraOffFailed(error: Error)

    case cameraPausedSucceeded
    case cameraPausedFailed(error: Error)

    case cameraSwitchTriggered
    case cameraSwitchSucceeded(cameraDevice: CameraDevice)
    case cameraSwitchFailed(previousCamera: LocalUserState.CameraDeviceSelectionStatus, error: Error)

    case microphoneOnTriggered
    case microphoneOnFailed(error: Error)
    
    case screenShareOnRequested
    case screenShareOnSucceeded
    case screenShareOnTriggeredFailed(error: Error)
    
    case screenShareOffRequested
    case screenShareOffSucceeded
    case screenShareOffTriggeredFailed(error: Error)

    case microphoneOffTriggered
    case microphoneOffFailed(error: Error)
    
    case raiseHandRequested
    case raiseHandFailed(error: Error)
    case raiseHandSucceeded
    
    case lowerHandRequested
    case lowerHandFailed(error: Error)
    case lowerHandSucceeded
    
    case backgroundEffectRequested(effect: LocalUserState.BackgroundEffectType)
    case backgroundEffectSetFailed(error: Error)
    
    case sendReaction(reaction: ReactionType)
    case resetLocalUserReaction

    case microphoneMuteStateUpdated(isMuted: Bool)

    case microphonePreviewOn
    case microphonePreviewOff
    
    case noiseSuppressionPreviewOn
    case noiseSuppressionPreviewOff
    
    case noiseSuppressionCallOn
    case noiseSuppressionCallOff
    
    case muteIncomingAudioRequested
    
    case gridLayoutSelected
    case speakerLayoutSelected
    
    case changeDisplayNameRequested(displayName: String?)

    case audioDeviceChangeRequested(device: AudioDeviceType)
    case audioDeviceChangeSucceeded(device: AudioDeviceType)
    case audioDeviceChangeFailed(error: Error)

    case participantRoleChanged(participantRole: ParticipantRoleEnum)
    case setCapabilities(capabilities: Set<ParticipantCapabilityType>)
    case onCapabilitiesChanged(event: CapabilitiesChangedEvent)
    
    case showChat(azureCorrelationId: String?)

    static func == (lhs: LocalUserAction, rhs: LocalUserAction) -> Bool {

        switch (lhs, rhs) {
        case let (.cameraOnFailed(lErr), .cameraOnFailed(rErr)),
            let (.cameraOffFailed(lErr), .cameraOffFailed(rErr)),
            let (.cameraPausedFailed(lErr), .cameraPausedFailed(rErr)),
            let (.microphoneOnFailed(lErr), .microphoneOnFailed(rErr)),
            let (.microphoneOffFailed(lErr), .microphoneOffFailed(rErr)),
            let (.screenShareOnTriggeredFailed(lErr), .screenShareOnTriggeredFailed(rErr)),
            let (.screenShareOffTriggeredFailed(lErr), .screenShareOffTriggeredFailed(rErr)),
            let (.audioDeviceChangeFailed(lErr), .audioDeviceChangeFailed(rErr)):

            return (lErr as NSError).code == (rErr as NSError).code

        case (.cameraPreviewOnTriggered, .cameraPreviewOnTriggered),
            (.cameraOnTriggered, .cameraOnTriggered),
            (.cameraOffTriggered, .cameraOffTriggered),
            (.cameraOffSucceeded, .cameraOffSucceeded),
            (.cameraPausedSucceeded, .cameraPausedSucceeded),
            (.cameraSwitchTriggered, .cameraSwitchTriggered),
            (.microphoneOnTriggered, .microphoneOnTriggered),
            (.microphoneOffTriggered, .microphoneOffTriggered),
            (.microphonePreviewOn, .microphonePreviewOn),
            (.noiseSuppressionPreviewOn, .noiseSuppressionPreviewOn),
            (.noiseSuppressionPreviewOff, .noiseSuppressionPreviewOff),
            (.gridLayoutSelected, .gridLayoutSelected),
            (.speakerLayoutSelected, .speakerLayoutSelected),
            (.muteIncomingAudioRequested, .muteIncomingAudioRequested),
            (.screenShareOnRequested, .screenShareOnRequested),
            (.screenShareOffRequested, .screenShareOffRequested),
            (.screenShareOffSucceeded, .screenShareOffSucceeded),
            (.microphonePreviewOff, .microphonePreviewOff):
            return true

        case let (.audioDeviceChangeRequested(lDev), .audioDeviceChangeRequested(rDev)),
            let (.audioDeviceChangeSucceeded(lDev), .audioDeviceChangeSucceeded(rDev)):
            return lDev == rDev

        case let (.microphoneMuteStateUpdated(lMuted), .microphoneMuteStateUpdated(rMuted)):
            return lMuted == rMuted

        case let (.cameraOnSucceeded(lId), .cameraOnSucceeded(rId)):
            return lId == rId
            
        case let (.changeDisplayNameRequested(lId), .changeDisplayNameRequested(rId)):
            return lId == rId

        case let (.cameraSwitchSucceeded(lDev), .cameraSwitchSucceeded(rDev)):
            return lDev == rDev

        case let (.cameraSwitchFailed(lPreviousDevice, lErr), .cameraSwitchFailed(rPreviousDevice, rErr)):
            return lPreviousDevice == rPreviousDevice && (lErr as NSError).code == (rErr as NSError).code

        case let (.setCapabilities(lCapabilities), .setCapabilities(rCapabilities)):
            return lCapabilities == rCapabilities
        case let (.onCapabilitiesChanged(lEvent), .onCapabilitiesChanged(rEvent)):
            return lEvent == rEvent

        default:
            return false
        }
    }
}
