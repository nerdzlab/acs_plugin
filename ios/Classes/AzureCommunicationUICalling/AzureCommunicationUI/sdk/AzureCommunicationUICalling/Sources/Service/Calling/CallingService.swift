//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation

protocol CallingServiceProtocol {
    var participantsInfoListSubject: CurrentValueSubject<[ParticipantInfoModel], Never> { get }
    var callInfoSubject: PassthroughSubject<CallInfoModel, Never> { get }
    var isRecordingActiveSubject: PassthroughSubject<Bool, Never> { get }
    var isTranscriptionActiveSubject: PassthroughSubject<Bool, Never> { get }
    var isLocalUserMutedSubject: PassthroughSubject<Bool, Never> { get }
    var callIdSubject: PassthroughSubject<String, Never> { get }
    var dominantSpeakersSubject: CurrentValueSubject<[String], Never> { get }
    var participantRoleSubject: PassthroughSubject<ParticipantRoleEnum, Never> { get }
    var totalParticipantCountSubject: PassthroughSubject<Int, Never> { get }
    var localUserLowerHandSubject: PassthroughSubject<String, Never> { get }
    /* <CALL_START_TIME>
    var callStartTimeSubject: PassthroughSubject<Date, Never> { get }
    </CALL_START_TIME> */

    var networkQualityDiagnosticsSubject: PassthroughSubject<NetworkQualityDiagnosticModel, Never> { get }
    var networkDiagnosticsSubject: PassthroughSubject<NetworkDiagnosticModel, Never> { get }
    var mediaDiagnosticsSubject: PassthroughSubject<MediaDiagnosticModel, Never> { get }
    var supportedSpokenLanguagesSubject: CurrentValueSubject<[String], Never> { get }
    var supportedCaptionLanguagesSubject: CurrentValueSubject<[String], Never> { get }
    var isCaptionsTranslationSupported: CurrentValueSubject<Bool, Never> { get }
    var captionsDataSubject: PassthroughSubject<CallCompositeCaptionsData, Never> { get }
    var activeSpokenLanguageSubject: CurrentValueSubject<String, Never> { get }
    var activeCaptionLanguageSubject: CurrentValueSubject<String, Never> { get }
    var captionsEnabledChanged: CurrentValueSubject<Bool, Never> { get }
    var captionsTypeSubject: CurrentValueSubject<CallCompositeCaptionsType, Never> { get }
    var capabilitiesChangedSubject: PassthroughSubject<CapabilitiesChangedEvent, Never> {get}
    var videoEffectErrorSubject: PassthroughSubject<String, Never> { get }

    func updateDisplayName(_ displayName: String?)
    func setupCall() async throws
    func startCall(
        isCameraPreferred: Bool,
        isMicrophonePreferred: Bool,
        isNoiseSuppressionPreferred: Bool,
        isMuteIncomingAudio: Bool
    ) async throws
    
    func endCall() async throws

    func requestCameraPreviewOn() async throws -> String
    func startLocalVideoStream() async throws -> String
    func stopLocalVideoStream() async throws
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
    
    func raiseHand() async throws
    func lowerHand() async throws
    
    func setBackgroundEffect(_ effect: LocalUserState.BackgroundEffectType)
    
    func sendReaction(_ reaction: ReactionType) async throws
    /* <CALL_START_TIME>
    func callStartTime() -> Date?
    </CALL_START_TIME> */
    
    func muteCall() async throws
    func unMuteCall() async throws
    
    func noiseSuppressionCallOn()
    func noiseSuppressionCallOff()
    
    func requestScreenSharingStream()
    func requestStopScreenSharingStream()
    func stopScreenSharing() async throws
    func showChat(azureCorrelationId: String?)
}

class CallingService: NSObject, CallingServiceProtocol {
    private let logger: Logger
    private let callingSDKWrapper: CallingSDKWrapperProtocol

    var isRecordingActiveSubject: PassthroughSubject<Bool, Never>
    var isTranscriptionActiveSubject: PassthroughSubject<Bool, Never>

    var isLocalUserMutedSubject: PassthroughSubject<Bool, Never>
    var participantsInfoListSubject: CurrentValueSubject<[ParticipantInfoModel], Never>
    var callInfoSubject: PassthroughSubject<CallInfoModel, Never>
    var callIdSubject: PassthroughSubject<String, Never>
    var dominantSpeakersSubject: CurrentValueSubject<[String], Never>
    var participantRoleSubject: PassthroughSubject<ParticipantRoleEnum, Never>
    var totalParticipantCountSubject: PassthroughSubject<Int, Never>
    var networkQualityDiagnosticsSubject = PassthroughSubject<NetworkQualityDiagnosticModel, Never>()
    var networkDiagnosticsSubject = PassthroughSubject<NetworkDiagnosticModel, Never>()
    var mediaDiagnosticsSubject = PassthroughSubject<MediaDiagnosticModel, Never>()
    var capabilitiesChangedSubject: PassthroughSubject<CapabilitiesChangedEvent, Never>
    var localUserLowerHandSubject: PassthroughSubject<String, Never>
    /* <CALL_START_TIME>
    var callStartTimeSubject: PassthroughSubject<Date, Never>
    </CALL_START_TIME> */

    var supportedSpokenLanguagesSubject: CurrentValueSubject<[String], Never>
    var supportedCaptionLanguagesSubject: CurrentValueSubject<[String], Never>
    var isCaptionsTranslationSupported: CurrentValueSubject<Bool, Never>
    var captionsDataSubject: PassthroughSubject<CallCompositeCaptionsData, Never>
    var activeSpokenLanguageSubject: CurrentValueSubject<String, Never>
    var activeCaptionLanguageSubject: CurrentValueSubject<String, Never>
    var captionsEnabledChanged: CurrentValueSubject<Bool, Never>
    var captionsTypeSubject: CurrentValueSubject<CallCompositeCaptionsType, Never>
    var videoEffectErrorSubject: PassthroughSubject<String, Never>
    
    init(logger: Logger,
         callingSDKWrapper: CallingSDKWrapperProtocol ) {
        self.logger = logger
        self.callingSDKWrapper = callingSDKWrapper
        isRecordingActiveSubject = callingSDKWrapper.callingEventsHandler.isRecordingActiveSubject
        isTranscriptionActiveSubject = callingSDKWrapper.callingEventsHandler.isTranscriptionActiveSubject
        isLocalUserMutedSubject = callingSDKWrapper.callingEventsHandler.isLocalUserMutedSubject
        participantsInfoListSubject = callingSDKWrapper.callingEventsHandler.participantsInfoListSubject
        callInfoSubject = callingSDKWrapper.callingEventsHandler.callInfoSubject
        callIdSubject = callingSDKWrapper.callingEventsHandler.callIdSubject
        dominantSpeakersSubject = callingSDKWrapper.callingEventsHandler.dominantSpeakersSubject
        participantRoleSubject = callingSDKWrapper.callingEventsHandler.participantRoleSubject
        networkQualityDiagnosticsSubject = callingSDKWrapper.callingEventsHandler.networkQualityDiagnosticsSubject
        networkDiagnosticsSubject = callingSDKWrapper.callingEventsHandler.networkDiagnosticsSubject
        mediaDiagnosticsSubject = callingSDKWrapper.callingEventsHandler.mediaDiagnosticsSubject
        supportedSpokenLanguagesSubject = callingSDKWrapper.callingEventsHandler.captionsSupportedSpokenLanguages
        supportedCaptionLanguagesSubject = callingSDKWrapper.callingEventsHandler.captionsSupportedCaptionLanguages
        isCaptionsTranslationSupported = callingSDKWrapper.callingEventsHandler.isCaptionsTranslationSupported
        captionsDataSubject = callingSDKWrapper.callingEventsHandler.captionsReceived
        activeSpokenLanguageSubject = callingSDKWrapper.callingEventsHandler.activeSpokenLanguageChanged
        activeCaptionLanguageSubject = callingSDKWrapper.callingEventsHandler.activeCaptionLanguageChanged
        captionsEnabledChanged = callingSDKWrapper.callingEventsHandler.captionsEnabledChanged
        captionsTypeSubject = callingSDKWrapper.callingEventsHandler.captionsTypeChanged
        capabilitiesChangedSubject = callingSDKWrapper.callingEventsHandler.capabilitiesChangedSubject
        totalParticipantCountSubject = callingSDKWrapper.callingEventsHandler.totalParticipantCountSubject
        /* <CALL_START_TIME>
        callStartTimeSubject = callingSDKWrapper.callingEventsHandler.callStartTimeSubject
        </CALL_START_TIME> */
        videoEffectErrorSubject = callingSDKWrapper.callingEventsHandler.videoEffectError
        localUserLowerHandSubject = callingSDKWrapper.callingEventsHandler.localUserLowerHandSubject
    }

    func setupCall() async throws {
        try await callingSDKWrapper.setupCall()
    }
    
    func updateDisplayName(_ displayName: String?) {
        callingSDKWrapper.updateDisplayName(displayName)
    }

    func startCall(
        isCameraPreferred: Bool,
        isMicrophonePreferred: Bool,
        isNoiseSuppressionPreferred: Bool,
        isMuteIncomingAudio: Bool
    ) async throws {
        try await callingSDKWrapper.startCall(
            isCameraPreferred: isCameraPreferred,
            isMicrophonePreferred: isMicrophonePreferred, isNoiseSuppressionPreferred: isNoiseSuppressionPreferred,
            isMuteIncomingAudio: isMuteIncomingAudio
        )
    }

    func endCall() async throws {
       try await callingSDKWrapper.endCall()
    }

    /* <CALL_START_TIME>
    func callStartTime() -> Date? {
        return callingSDKWrapper.callStartTime()
    }
    </CALL_START_TIME> */

    func requestCameraPreviewOn() async throws -> String {
        return try await callingSDKWrapper.startPreviewVideoStream()
    }

    func startLocalVideoStream() async throws -> String {
        return try await callingSDKWrapper.startCallLocalVideoStream()
    }

    func stopLocalVideoStream() async throws {
        try await callingSDKWrapper.stopLocalVideoStream()
    }

    func switchCamera() async throws -> CameraDevice {
        try await callingSDKWrapper.switchCamera()
    }

    func muteLocalMic() async throws {
        try await callingSDKWrapper.muteLocalMic()
    }

    func unmuteLocalMic() async throws {
        try await callingSDKWrapper.unmuteLocalMic()
    }

    func holdCall() async throws {
        try await callingSDKWrapper.holdCall()
    }

    func resumeCall() async throws {
        try await callingSDKWrapper.resumeCall()
    }

    func admitAllLobbyParticipants() async throws {
        try await callingSDKWrapper.admitAllLobbyParticipants()
    }

    func admitLobbyParticipant(_ participantId: String) async throws {
        try await callingSDKWrapper.admitLobbyParticipant(participantId)
    }

    func declineLobbyParticipant(_ participantId: String) async throws {
        try await callingSDKWrapper.declineLobbyParticipant(participantId)
    }

    func startCaptions(_ spokenLanguage: String) async throws {
        try await callingSDKWrapper.startCaptions(spokenLanguage)
    }

    func stopCaptions() async throws {
        try await callingSDKWrapper.stopCaptions()
    }

    func setCaptionsSpokenLanguage(_ language: String) async throws {
        try await callingSDKWrapper.setCaptionsSpokenLanguage(language)
    }

    func setCaptionsCaptionLanguage(_ language: String) async throws {
        try await callingSDKWrapper.setCaptionsCaptionLanguage(language)
    }

    func removeParticipant(_ participantId: String) async throws {
        try await callingSDKWrapper.removeParticipant(participantId)
    }

    func getCapabilities() async throws -> Set<ParticipantCapabilityType> {
        try await callingSDKWrapper.getCapabilities()
    }
    
    func raiseHand() async throws {
        try await callingSDKWrapper.raiseHand()
    }
    
    func lowerHand() async throws {
        try await callingSDKWrapper.lowerHand()
    }
    
    func setBackgroundEffect(_ effect: LocalUserState.BackgroundEffectType) {
        callingSDKWrapper.setBackgroundEffect(effect)
    }
    
    func sendReaction(_ reaction: ReactionType) async throws {
        try await callingSDKWrapper.sendReaction(reaction)
    }
    
    func unMuteCall() async throws {
        try await callingSDKWrapper.unMuteCall()
    }
    
    func muteCall() async throws {
        try await callingSDKWrapper.muteCall()
    }
    
    func noiseSuppressionCallOn() {
        callingSDKWrapper.enableNoiseSuppression()
    }
    
    func noiseSuppressionCallOff() {
        callingSDKWrapper.disableNoiseSuppression()
    }
    
    func requestScreenSharingStream() {
        callingSDKWrapper.requestScreenSharingStream()
    }
    
    func requestStopScreenSharingStream() {
        callingSDKWrapper.requestStopScreenSharingStream()
    }
    
    func stopScreenSharing() async throws {
        try await callingSDKWrapper.stopScreenSharingStream()
    }
    
    func showChat(azureCorrelationId: String?) {
        callingSDKWrapper.showChat(azureCorrelationId: azureCorrelationId)
    }
}
