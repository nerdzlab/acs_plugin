//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

struct LocalUserState {
    enum CameraOperationalStatus: Equatable {
        case on
        case off
        case paused
        case pending

        static func == (lhs: LocalUserState.CameraOperationalStatus,
                        rhs: LocalUserState.CameraOperationalStatus) -> Bool {
            switch (lhs, rhs) {
            case (.on, .on),
                 (.off, .off),
                 (.paused, paused),
                 (.pending, .pending):
                return true
            default:
                return false
            }
        }
    }

    enum CameraDeviceSelectionStatus: Equatable {
        case front
        case back
        case switching

        static func == (lhs: LocalUserState.CameraDeviceSelectionStatus,
                        rhs: LocalUserState.CameraDeviceSelectionStatus) -> Bool {
            switch (lhs, rhs) {
            case (.front, .front),
                 (.back, .back),
                 (.switching, switching):
                return true
            default:
                return false
            }
        }
    }

    enum CameraTransmissionStatus: Equatable {
        case local
        case remote

        static func == (lhs: LocalUserState.CameraTransmissionStatus,
                        rhs: LocalUserState.CameraTransmissionStatus) -> Bool {
            switch (lhs, rhs) {
            case (.local, .local),
                 (.remote, .remote):
                return true
            default:
                return false
            }
        }
    }

    enum AudioOperationalStatus: Equatable {
        case on
        case off
        case pending

        static func == (lhs: LocalUserState.AudioOperationalStatus,
                        rhs: LocalUserState.AudioOperationalStatus) -> Bool {
            switch (lhs, rhs) {
            case (.on, .on),
                 (.off, .off),
                 (.pending, .pending):
                return true
            default:
                return false
            }
        }
    }
    
    enum NoiseSuppressionOperationalStatus: Equatable {
        case on
        case off

        static func == (lhs: LocalUserState.NoiseSuppressionOperationalStatus,
                        rhs: LocalUserState.NoiseSuppressionOperationalStatus) -> Bool {
            switch (lhs, rhs) {
            case (.on, .on),
                (.off, .off):
                return true
            default:
                return false
            }
        }
    }
    
    enum IncomingAudioOperationalStatus: Equatable {
        case muted
        case unmuted

        static func == (lhs: LocalUserState.IncomingAudioOperationalStatus,
                        rhs: LocalUserState.IncomingAudioOperationalStatus) -> Bool {
            switch (lhs, rhs) {
            case (.muted, .muted),
                (.unmuted, .unmuted):
                return true
            default:
                return false
            }
        }
    }

    enum AudioDeviceSelectionStatus: Equatable {
        case speakerSelected
        case speakerRequested
        case receiverSelected
        case receiverRequested
        case bluetoothSelected
        case bluetoothRequested
        case headphonesSelected
        case headphonesRequested

        static func == (lhs: LocalUserState.AudioDeviceSelectionStatus,
                        rhs: LocalUserState.AudioDeviceSelectionStatus) -> Bool {
            switch (lhs, rhs) {
            case (.speakerSelected, .speakerSelected),
                 (.speakerRequested, .speakerRequested),
                 (.receiverSelected, receiverSelected),
                 (.receiverRequested, .receiverRequested),
                 (.bluetoothSelected, bluetoothSelected),
                 (.bluetoothRequested, .bluetoothRequested),
                 (.headphonesSelected, headphonesSelected),
                 (.headphonesRequested, .headphonesRequested):
                return true
            default:
                return false
            }
        }

        static func isSelected(for audioDeviceStatus: LocalUserState.AudioDeviceSelectionStatus) -> Bool {
            switch audioDeviceStatus {
            case .speakerSelected, .receiverSelected, .bluetoothSelected, .headphonesSelected:
                return true
            default:
                return false
            }
        }
    }

    struct CameraState {
        let operation: CameraOperationalStatus
        let device: CameraDeviceSelectionStatus
        let transmission: CameraTransmissionStatus
        var error: Error?
    }

    struct AudioState {
        let operation: AudioOperationalStatus
        let device: AudioDeviceSelectionStatus
        var error: Error?
    }
    
    struct NoiseSuppressionState {
        let operation: NoiseSuppressionOperationalStatus
        var error: Error?
    }
    
    struct IncomingAudioState {
        let operation: IncomingAudioOperationalStatus
        var error: Error?
    }

    let cameraState: CameraState
    let audioState: AudioState
    let incomingAudioState: IncomingAudioState
    let noiseSuppressionState: NoiseSuppressionState
    let displayName: String?
    let userId: String?
    let localVideoStreamIdentifier: String?
    let participantRole: ParticipantRoleEnum?
    let capabilities: Set<ParticipantCapabilityType>
    let currentCapabilitiesAreDefault: Bool

    init(cameraState: CameraState = CameraState(operation: .off,
                                                device: .front,
                                                transmission: .local),
         audioState: AudioState = AudioState(operation: .off,
                                             device: .receiverSelected),
         displayName: String? = nil,
         userId: String? = nil,
         localVideoStreamIdentifier: String? = nil,
         participantRole: ParticipantRoleEnum? = nil,
         capabilities: Set<ParticipantCapabilityType> = [.unmuteMicrophone, .turnVideoOn],
         currentCapabilitiesAreDefault: Bool = true,
         noiseSuppressionState: NoiseSuppressionState = NoiseSuppressionState(operation: .off, error: nil),
         incomingAudioState: IncomingAudioState = IncomingAudioState(operation: .unmuted, error: nil)
    ) {
        self.cameraState = cameraState
        self.noiseSuppressionState = noiseSuppressionState
        self.audioState = audioState
        self.displayName = displayName
        self.userId = userId
        self.localVideoStreamIdentifier = localVideoStreamIdentifier
        self.participantRole = participantRole
        self.capabilities = capabilities
        self.currentCapabilitiesAreDefault = currentCapabilitiesAreDefault
        self.incomingAudioState = incomingAudioState
    }
}
