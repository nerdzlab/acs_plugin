//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//
import AzureCommunicationCommon
import Combine
import Foundation
import AzureCommunicationCalling
import ReplayKit

enum CameraDevice {
    case front
    case back
}

class CompositeRemoteParticipant<WrappedType, VideoStreamType> {
    var identifier: CommunicationIdentifier
    var videoStreams: [CompositeRemoteVideoStream<VideoStreamType>]
    var wrappedObject: WrappedType

    init(id: CommunicationIdentifier,
         videoStreams: [CompositeRemoteVideoStream<VideoStreamType>],
         wrappedObject: WrappedType
    ) {
        self.identifier = id
        self.videoStreams = videoStreams
        self.wrappedObject = wrappedObject
    }
}

enum CompositeMediaStreamType {
    case cameraVideo
    case screenSharing
}

class CompositeRemoteVideoStream<WrappedType> {
    var id: Int
    var mediaStreamType: CompositeMediaStreamType = .cameraVideo
    var wrappedObject: WrappedType

    init(id: Int, mediaStreamType: CompositeMediaStreamType, wrappedObject: WrappedType) {
        self.id = id
        self.mediaStreamType = mediaStreamType
        self.wrappedObject = wrappedObject
    }
}

class CompositeLocalVideoStream<WrappedType> {
    var mediaStreamType: CompositeMediaStreamType = .cameraVideo
    var wrappedObject: WrappedType

    init(mediaStreamType: CompositeMediaStreamType, wrappedObject: WrappedType) {
        self.mediaStreamType = mediaStreamType
        self.wrappedObject = wrappedObject
    }
}

protocol CallingSDKWrapperProtocol {
    func getRemoteParticipant<ParticipantType, StreamType>(_ identifier: String)
    -> CompositeRemoteParticipant<ParticipantType, StreamType>?
    func getLocalVideoStream<LocalVideoStreamType>(_ identifier: String)
    -> CompositeLocalVideoStream<LocalVideoStreamType>?

    func startPreviewVideoStream() async throws -> String
    func updateDisplayName(_ displayName: String?)
    func setupCall() async throws
    func startCall(
        isCameraPreferred: Bool,
        isMicrophonePreferred: Bool,
        isNoiseSuppressionPreferred: Bool,
        isMuteIncomingAudio: Bool
    ) async throws
    func endCall() async throws
    func startCallLocalVideoStream() async throws -> String
    func stopLocalVideoStream() async throws
    func requestScreenSharingStream()
    func startScreenSharingStream() async throws
    func stopScreenSharingStream() async throws
    func requestStopScreenSharingStream()
    func switchCamera() async throws -> CameraDevice
    func muteLocalMic() async throws
    func unmuteLocalMic() async throws
    func holdCall() async throws
    func resumeCall() async throws
    func admitAllLobbyParticipants() async throws
    func admitLobbyParticipant(_ participantId: String) async throws
    func declineLobbyParticipant(_ participantId: String) async throws
    func startCaptions(_ language: String) async throws
    func stopCaptions() async throws
    func setCaptionsSpokenLanguage(_ language: String) async throws
    func setCaptionsCaptionLanguage(_ language: String) async throws
    func removeParticipant(_ participantId: String) async throws
    func getCapabilities() async throws -> Set<ParticipantCapabilityType>
    /* <CALL_START_TIME>
    func callStartTime() -> Date?
    </CALL_START_TIME> */
    func getLogFiles() -> [URL]
    
    func getRaiseHands() -> [RaisedHand]
    func lowerHand() async throws
    func raiseHand() async throws
    func setBackgroundEffect(_ effect: LocalUserState.BackgroundEffectType)
    func sendReaction(_ reaction: ReactionType) async throws
    var callingEventsHandler: CallingSDKEventsHandling { get }
    func dispose()
    func muteCall() async throws
    func unMuteCall() async throws
    func enableNoiseSuppression()
    func disableNoiseSuppression()
    func showChat(azureCorrelationId: String?)
    func captureOutput(sampleBuffer: CMSampleBuffer, sampleBufferType: RPSampleBufferType, error: Error?)
}

protocol CallingSDKEventsHandling {
    var participantsInfoListSubject: CurrentValueSubject<[ParticipantInfoModel], Never> { get }

    var callInfoSubject: PassthroughSubject<CallInfoModel, Never> { get }

    var isRecordingActiveSubject: PassthroughSubject<Bool, Never> { get }

    var isTranscriptionActiveSubject: PassthroughSubject<Bool, Never> { get }

    var isLocalUserMutedSubject: PassthroughSubject<Bool, Never> { get }

    var callIdSubject: PassthroughSubject<String, Never> { get }

    var dominantSpeakersSubject: CurrentValueSubject<[String], Never> { get }
    var participantRoleSubject: PassthroughSubject<ParticipantRoleEnum, Never> { get }
    var totalParticipantCountSubject: PassthroughSubject<Int, Never> { get }
    var networkQualityDiagnosticsSubject: PassthroughSubject<NetworkQualityDiagnosticModel, Never> { get }
    /* <CALL_START_TIME>
    var callStartTimeSubject: PassthroughSubject<Date, Never> { get }
    </CALL_START_TIME> */
    var networkDiagnosticsSubject: PassthroughSubject<NetworkDiagnosticModel, Never> { get }

    var mediaDiagnosticsSubject: PassthroughSubject<MediaDiagnosticModel, Never> { get }
    var captionsSupportedSpokenLanguages: CurrentValueSubject<[String], Never> { get }
    var captionsSupportedCaptionLanguages: CurrentValueSubject<[String], Never> { get }
    var isCaptionsTranslationSupported: CurrentValueSubject<Bool, Never> { get }
    var captionsReceived: PassthroughSubject<CallCompositeCaptionsData, Never> { get }
    var activeSpokenLanguageChanged: CurrentValueSubject<String, Never> { get }
    var activeCaptionLanguageChanged: CurrentValueSubject<String, Never> { get }
    var captionsEnabledChanged: CurrentValueSubject<Bool, Never> { get }
    var captionsTypeChanged: CurrentValueSubject<CallCompositeCaptionsType, Never> { get }
    var videoEffectError: PassthroughSubject<String, Never> { get }
    var localUserLowerHandSubject: PassthroughSubject<String, Never> { get }

    var capabilitiesChangedSubject: PassthroughSubject<CapabilitiesChangedEvent, Never> { get }

}
