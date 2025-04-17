//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

public struct LocalUserState {
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
    
    enum RaiseHandOperationalStatus: Equatable {
        case handIsRise
        case handIsLower
        
        static func == (lhs: LocalUserState.RaiseHandOperationalStatus,
                        rhs: LocalUserState.RaiseHandOperationalStatus) -> Bool {
            switch (lhs, rhs) {
            case (.handIsRise, .handIsRise),
                (.handIsLower, .handIsLower):
                return true
            default:
                return false
            }
        }
    }
    
    enum ShareScreenOperationalStatus: Equatable {
        case screenIsSharing
        case screenNotShared
        
        static func == (lhs: LocalUserState.ShareScreenOperationalStatus,
                        rhs: LocalUserState.ShareScreenOperationalStatus) -> Bool {
            switch (lhs, rhs) {
            case (.screenIsSharing, .screenIsSharing),
                (.screenNotShared, .screenNotShared):
                return true
            default:
                return false
            }
        }
    }
    
    enum MeetingLayoutType: Equatable {
        case grid
        case speaker
        
        static func == (lhs: LocalUserState.MeetingLayoutType,
                        rhs: LocalUserState.MeetingLayoutType) -> Bool {
            switch (lhs, rhs) {
            case (.grid, .grid),
                (.speaker, .speaker):
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
    
    struct MeetingLayoutState {
        let operation: MeetingLayoutType
    }
    
    struct IncomingAudioState {
        let operation: IncomingAudioOperationalStatus
        var error: Error?
    }
    
    struct ShareScreenState {
        let operation: ShareScreenOperationalStatus
        var error: Error?
    }
    
    struct RaiseHandState {
        let operation: RaiseHandOperationalStatus
        var error: Error?
    }
    
    let cameraState: CameraState
    let audioState: AudioState
    let incomingAudioState: IncomingAudioState
    let noiseSuppressionState: NoiseSuppressionState
    let shareScreenState: ShareScreenState
    let raiseHandState: RaiseHandState
    let meetingLayoutState: MeetingLayoutState
    let initialDisplayName: String?
    let updatedDisplayName: String?
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
         initialDisplayName: String? = nil,
         updatedDisplayName: String? = nil,
         userId: String? = nil,
         localVideoStreamIdentifier: String? = nil,
         participantRole: ParticipantRoleEnum? = nil,
         capabilities: Set<ParticipantCapabilityType> = [.unmuteMicrophone, .turnVideoOn],
         currentCapabilitiesAreDefault: Bool = true,
         noiseSuppressionState: NoiseSuppressionState = NoiseSuppressionState(operation: .off, error: nil),
         incomingAudioState: IncomingAudioState = IncomingAudioState(operation: .unmuted, error: nil),
         meetingLayoutState: MeetingLayoutState = MeetingLayoutState(operation: .grid),
         raiseHandState: RaiseHandState = RaiseHandState(operation: .handIsLower),
         shareScreenState: ShareScreenState = ShareScreenState(operation: .screenNotShared)
    ) {
        self.cameraState = cameraState
        self.noiseSuppressionState = noiseSuppressionState
        self.audioState = audioState
        self.initialDisplayName = initialDisplayName
        self.updatedDisplayName = updatedDisplayName
        self.userId = userId
        self.localVideoStreamIdentifier = localVideoStreamIdentifier
        self.participantRole = participantRole
        self.capabilities = capabilities
        self.currentCapabilitiesAreDefault = currentCapabilitiesAreDefault
        self.incomingAudioState = incomingAudioState
        self.meetingLayoutState = meetingLayoutState
        self.raiseHandState = raiseHandState
        self.shareScreenState = shareScreenState
    }
}
