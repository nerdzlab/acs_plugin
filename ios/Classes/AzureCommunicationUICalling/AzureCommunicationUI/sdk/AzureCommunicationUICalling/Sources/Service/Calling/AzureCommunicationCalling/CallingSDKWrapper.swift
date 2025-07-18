//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationCalling

import Combine
import Foundation
import ReplayKit
import AVFoundation
import Accelerate

// swiftlint:disable file_length
// swiftlint:disable type_body_length
class CallingSDKWrapper: NSObject, CallingSDKWrapperProtocol {
    let callingEventsHandler: CallingSDKEventsHandling
    
    private let logger: Logger
    private let callConfiguration: CallConfiguration
    private var call: Call?
    private var deviceManager: DeviceManager?
    private var localVideoStream: AzureCommunicationCalling.LocalVideoStream?
    private var localScreenShareOutgoingVideoStream: AzureCommunicationCalling.ScreenShareOutgoingVideoStream?
    private var newVideoDeviceAddedHandler: ((VideoDeviceInfo) -> Void)?
    private var callKitRemoteInfo: CallKitRemoteInfo?
    private var callingSDKInitializer: CallingSDKInitializer
    private var replacementEffect: BackgroundReplacementEffect
    private var screenRecorder: RPScreenRecorder = RPScreenRecorder.shared()
    
    init(logger: Logger,
         callingEventsHandler: CallingSDKEventsHandling,
         callConfiguration: CallConfiguration,
         callKitRemoteInfo: CallKitRemoteInfo?,
         callingSDKInitializer: CallingSDKInitializer) {
        self.logger = logger
        self.callingEventsHandler = callingEventsHandler
        self.callConfiguration = callConfiguration
        self.callKitRemoteInfo = callKitRemoteInfo
        self.callingSDKInitializer = callingSDKInitializer
        self.replacementEffect = BackgroundReplacementEffect()
        super.init()
    }
    
    deinit {
        logger.debug("CallingSDKWrapper deallocated")
    }
    
    func dispose() {
        call = nil
        resetVideoEffects()
    }
    
    func setupCall() async throws {
        try await setupCallClientAndDeviceManager()
    }
    
    func updateDisplayName(_ displayName: String?) {
        callingSDKInitializer.updateDisplayName(displayName)
    }
    
    func startCall(
        isCameraPreferred: Bool,
        isMicrophonePreferred: Bool,
        isNoiseSuppressionPreferred: Bool,
        isMuteIncomingAudio: Bool
    ) async throws {
        logger.debug("Reset Subjects in callingEventsHandler")
        if let callingEventsHandler = self.callingEventsHandler
            as? CallingSDKEventsHandler {
            callingEventsHandler.setupProperties()
        }
        logger.debug( "Starting call")
        if callConfiguration.compositeCallType == .groupCall ||
            callConfiguration.compositeCallType == .teamsMeeting ||
            callConfiguration.compositeCallType == .roomsCall {
            try await joinCall(isCameraPreferred: isCameraPreferred, isMicrophonePreferred: isMicrophonePreferred, isNoiseSuppressionPreferred: isNoiseSuppressionPreferred, isMuteIncomingAudio: isMuteIncomingAudio)
        } else if callConfiguration.compositeCallType == .oneToNOutgoing {
            try await outgoingCall(isCameraPreferred: isCameraPreferred, isMicrophonePreferred: isMicrophonePreferred, isNoiseSuppressionPreferred: isNoiseSuppressionPreferred)
        } else if callConfiguration.compositeCallType == .oneToOneIncoming {
            try await incomingCall(isCameraPreferred: isCameraPreferred, isMicrophonePreferred: isMicrophonePreferred, isNoiseSuppressionPreferred: isNoiseSuppressionPreferred)
        } else {
            logger.error("Unknown calltype access")
            throw CallCompositeInternalError.callJoinFailed
        }
    }
    
    func joinCall(isCameraPreferred: Bool, isMicrophonePreferred: Bool, isNoiseSuppressionPreferred: Bool, isMuteIncomingAudio: Bool) async throws {
        logger.debug( "Joining call")
        let joinCallOptions = JoinCallOptions()
        
        // to fix iOS 15 issue
        // by default on iOS 15 calling SDK incoming type is raw video
        // because of this on iOS 15 remote video start event is not received
        let incomingVideoOptions = IncomingVideoOptions()
        incomingVideoOptions.streamType = .remoteIncoming
        
        if isCameraPreferred,
           let localVideoStream = localVideoStream {
            let localVideoStreamArray = [localVideoStream]
            
            let videoOptions = OutgoingVideoOptions()
            videoOptions.streams = localVideoStreamArray
            joinCallOptions.outgoingVideoOptions = videoOptions
        }
        
        joinCallOptions.outgoingAudioOptions = OutgoingAudioOptions()
        
        if isNoiseSuppressionPreferred {
            let filters = OutgoingAudioFilters()
            filters.noiseSuppressionMode = NoiseSuppressionMode.high
            filters.analogAutomaticGainControlEnabled = true
            filters.digitalAutomaticGainControlEnabled = true
            filters.musicModeEnabled = true
            filters.acousticEchoCancellationEnabled = true
            joinCallOptions.outgoingAudioOptions?.filters = filters
        }
        
        if isMuteIncomingAudio {
            joinCallOptions.incomingAudioOptions = IncomingAudioOptions()
            joinCallOptions.incomingAudioOptions?.muted = isMuteIncomingAudio
        }
        
        joinCallOptions.outgoingAudioOptions?.muted = !isMicrophonePreferred
        joinCallOptions.incomingVideoOptions = incomingVideoOptions
        if let remoteInfo = callKitRemoteInfo {
            let callKitRemoteInfo = AzureCommunicationCalling.CallKitRemoteInfo()
            callKitRemoteInfo.displayName = remoteInfo.displayName
            callKitRemoteInfo.handle = remoteInfo.handle
            joinCallOptions.callKitRemoteInfo = callKitRemoteInfo
        }
        var joinLocator: JoinMeetingLocator
        if callConfiguration.compositeCallType == .groupCall, let groupId = callConfiguration.groupId {
            joinLocator = GroupCallLocator(groupId: groupId)
        }
        else if callConfiguration.compositeCallType == .teamsMeeting, let meetingLink = callConfiguration.meetingLink {
            joinLocator = TeamsMeetingLinkLocator(
                meetingLink: meetingLink.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        else if callConfiguration.compositeCallType == .teamsMeeting, let meetingId = callConfiguration.meetingId?.trimmingCharacters(in: .whitespacesAndNewlines), let meetingPasscode = callConfiguration.meetingPasscode?.trimmingCharacters(in: .whitespacesAndNewlines) {
            joinLocator = TeamsMeetingIdLocator(with: meetingId, passcode: meetingPasscode)
        }
        else if callConfiguration.compositeCallType == .roomsCall, let roomId = callConfiguration.roomId {
            joinLocator = RoomCallLocator(roomId: roomId.trimmingCharacters(in: .whitespacesAndNewlines))
        }
        else {
            logger.error("Invalid groupID / meeting link")
            throw CallCompositeInternalError.callJoinFailed
        }
        
        do {
            //MTODO
            let callAgent = try await callingSDKInitializer.setupCallAgent(isNeedRenewCallAgent: false)
            
            //MTODO: Displayname
            //            callAgent.
            let joinedCall = try await callAgent.join(with: joinLocator, joinCallOptions: joinCallOptions)
            if let callingEventsHandler = self.callingEventsHandler as? CallingSDKEventsHandler {
                joinedCall.delegate = callingEventsHandler
            }
            call = joinedCall
            setupFeatures()
        } catch {
            logger.error( "Join call failed")
            throw CallCompositeInternalError.callJoinFailed
        }
    }
    
    func outgoingCall(isCameraPreferred: Bool, isMicrophonePreferred: Bool, isNoiseSuppressionPreferred: Bool) async throws {
        logger.debug( "Starting outgoing call")
        let startCallOptions = StartCallOptions()
        
        // to fix iOS 15 issue
        // by default on iOS 15 calling SDK incoming type is raw video
        // because of this on iOS 15 remote video start event is not received
        let incomingVideoOptions = IncomingVideoOptions()
        incomingVideoOptions.streamType = .remoteIncoming
        
        if isCameraPreferred,
           let localVideoStream = localVideoStream {
            let localVideoStreamArray = [localVideoStream]
            
            let videoOptions = OutgoingVideoOptions()
            videoOptions.streams = localVideoStreamArray
            startCallOptions.outgoingVideoOptions = videoOptions
        }
        
        startCallOptions.outgoingAudioOptions = OutgoingAudioOptions()
        startCallOptions.outgoingAudioOptions?.muted = !isMicrophonePreferred
        
        if isNoiseSuppressionPreferred {
            let filters = OutgoingAudioFilters()
            filters.noiseSuppressionMode = NoiseSuppressionMode.high
            filters.analogAutomaticGainControlEnabled = true
            filters.digitalAutomaticGainControlEnabled = true
            filters.musicModeEnabled = true
            filters.acousticEchoCancellationEnabled = true
            startCallOptions.outgoingAudioOptions?.filters = filters
        }
        
        startCallOptions.incomingVideoOptions = incomingVideoOptions
        if let remoteInfo = callKitRemoteInfo {
            let callKitRemoteInfo = AzureCommunicationCalling.CallKitRemoteInfo()
            callKitRemoteInfo.displayName = remoteInfo.displayName
            callKitRemoteInfo.handle = remoteInfo.handle
            startCallOptions.callKitRemoteInfo = callKitRemoteInfo
        }
        do {
            //MTODO
            let callAgent = try await callingSDKInitializer.setupCallAgent(isNeedRenewCallAgent: false)
            if let participants = callConfiguration.participants {
                let joinedCall = try await callAgent.startCall(participants: participants,
                                                               options: startCallOptions)
                if let callingEventsHandler = self.callingEventsHandler as? CallingSDKEventsHandler {
                    joinedCall.delegate = callingEventsHandler
                }
                call = joinedCall
                setupFeatures()
            } else {
                logger.error( "Start call failed")
                throw CallCompositeInternalError.callJoinFailed
            }
        }
        catch {
            logger.error( "Start call failed")
            throw CallCompositeInternalError.callJoinFailed
        }
    }
    
    func incomingCall(isCameraPreferred: Bool, isMicrophonePreferred: Bool, isNoiseSuppressionPreferred: Bool) async throws {
        logger.debug( "incoming call")
        do {
            //MTODO
            let callAgent = try await callingSDKInitializer.setupCallAgent(isNeedRenewCallAgent: false)
            call = callAgent.calls.first
            // call is not accepted by callkit
            if call == nil && callingSDKInitializer.getIncomingCall()?.id == callConfiguration.callId {
                logger.debug( "accept incoming call")
                let options = AcceptCallOptions()
                let incomingVideoOptions = IncomingVideoOptions()
                incomingVideoOptions.streamType = .remoteIncoming
                
                if isCameraPreferred,
                   let localVideoStream = localVideoStream {
                    let localVideoStreamArray = [localVideoStream]
                    
                    let videoOptions = OutgoingVideoOptions()
                    videoOptions.streams = localVideoStreamArray
                    options.outgoingVideoOptions = videoOptions
                }
                options.outgoingAudioOptions = OutgoingAudioOptions()
                options.outgoingAudioOptions?.muted = !isMicrophonePreferred
                options.incomingVideoOptions = incomingVideoOptions
                
                if isNoiseSuppressionPreferred {
                    let filters = OutgoingAudioFilters()
                    filters.noiseSuppressionMode = NoiseSuppressionMode.high
                    filters.analogAutomaticGainControlEnabled = true
                    filters.digitalAutomaticGainControlEnabled = true
                    filters.musicModeEnabled = true
                    filters.acousticEchoCancellationEnabled = true
                    options.outgoingAudioOptions?.filters = filters
                }
                
                if let remoteInfo = callKitRemoteInfo {
                    let callKitRemoteInfo = AzureCommunicationCalling.CallKitRemoteInfo()
                    callKitRemoteInfo.displayName = remoteInfo.displayName
                    callKitRemoteInfo.handle = remoteInfo.handle
                    options.callKitRemoteInfo = callKitRemoteInfo
                }
                
                if let incomngCall = callingSDKInitializer.getIncomingCall() {
                    do {
                        call = try await incomngCall.accept(options: options)
                    } catch let error as NSError {
                        logger.debug( "call error \(error.localizedDescription) \(error.code)")
                        throw CallCompositeInternalError.callJoinFailed
                    }
                } else {
                    throw CallCompositeInternalError.callJoinFailed
                }
            } else {
                if call == nil || call?.id != callConfiguration.callId {
                    throw CallCompositeInternalError.callJoinFailed
                }
            }
            callingSDKInitializer.onIncomingCallAccpeted()
            if let callingEventsHandler = self.callingEventsHandler as? CallingSDKEventsHandler,
               let call = call {
                call.delegate = callingEventsHandler
            }
            setupFeatures()
        } catch {
            logger.error( "incoming call join failed")
            throw CallCompositeInternalError.callJoinFailed
        }
    }
    
    func endCall() async throws {
        guard call != nil else {
            throw CallCompositeInternalError.callEndFailed
        }
        do {
            try await call?.hangUp(options: HangUpOptions())
            logger.debug("Call ended successfully")
        } catch {
            logger.error( "It was not possible to hangup the call.")
            throw error
        }
    }
    
    func getRemoteParticipant<ParticipantType, StreamType>(_ identifier: String)
    -> CompositeRemoteParticipant<ParticipantType, StreamType>? {
        guard let remote = findParticipant(identifier: identifier) else {
            return nil
        }
        
        let remoteParticipant = AzureCommunicationCalling.RemoteParticipant
            .toCompositeRemoteParticipant(acsRemoteParticipant: remote)
        guard let castValue = remoteParticipant as? CompositeRemoteParticipant<ParticipantType, StreamType> else {
            return nil
        }
        return castValue
    }
    
    private func findParticipant(identifier: String) -> AzureCommunicationCalling.RemoteParticipant? {
        call?.remoteParticipants.first(where: { $0.identifier.rawId == identifier })
    }
    
    func getLocalVideoStream<LocalVideoStreamType>(_ identifier: String)
    -> CompositeLocalVideoStream<LocalVideoStreamType>? {
        
        guard getLocalVideoStreamIdentifier() == identifier else {
            return nil
        }
        guard let videoStream = localVideoStream,
              let castVideoStream = videoStream as? LocalVideoStreamType else {
            return nil
        }
        guard videoStream is LocalVideoStreamType else {
            return nil
        }
        return CompositeLocalVideoStream(
            mediaStreamType: videoStream.sourceType.asCompositeMediaStreamType,
            wrappedObject: castVideoStream
        )
    }
    
    func startCallLocalVideoStream() async throws -> String {
        let stream = await getValidLocalVideoStream()
        return try await startCallVideoStream(stream)
    }
    
    func stopLocalVideoStream() async throws {
        guard let call = self.call,
              let videoStream = self.localVideoStream else {
            logger.debug("Local video stopped successfully without call")
            return
        }
        do {
            try await call.stopVideo(stream: videoStream)
            logger.debug("Local video stopped successfully")
        } catch {
            logger.error( "Local video failed to stop. \(error)")
            throw error
        }
    }
    
    //Event to plugin to start broadcast, and return via completion buffer
    
    func startScreenSharingStream() async throws {
        let stream = getValidScreenShareStream()
        try await startCallScreenShareStream(stream)
    }
    
    func requestScreenSharingStream() {
        callingSDKInitializer.requestScreenSharing()
    }
    
    private func startCallScreenShareStream(
        _ videoStream: AzureCommunicationCalling.ScreenShareOutgoingVideoStream
    ) async throws {
        guard let call = self.call else {
            let error = CallCompositeInternalError.cameraOnFailed
            self.logger.error( "Start share screen video stream failed")
            throw error
        }
        do {
            try await call.startVideo(stream: videoStream)
            
            logger.debug("Screen share video started successfully")
        } catch {
            logger.error( "Screen share video failed to start. \(error)")
            throw error
        }
    }
    
    func captureOutput(sampleBuffer: CMSampleBuffer, sampleBufferType: RPSampleBufferType, error: Error?) {
        if sampleBufferType != .video {
            return
        }
        
        // Extract the pixel buffer from the sample buffer
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let rawVideoFrameBuffer = RawVideoFrameBuffer()
        rawVideoFrameBuffer.buffer = pixelBuffer
        
        // Set the format if necessary
        if let format = localScreenShareOutgoingVideoStream?.format {
            let width = CVPixelBufferGetWidth(pixelBuffer)
            let height = CVPixelBufferGetHeight(pixelBuffer)
            let bytesPerRow = CVPixelBufferGetBytesPerRow(pixelBuffer)
            
            format.width = Int32(width)
            format.height = Int32(height)
            format.stride1 = Int32(bytesPerRow)
            rawVideoFrameBuffer.streamFormat = format
        }
        
        // Send the raw video frame
        sendRawVideoFrame(rawVideoFrameBuffer: rawVideoFrameBuffer)
    }
    
    private func sendRawVideoFrame(rawVideoFrameBuffer: RawVideoFrameBuffer) {
        let canSendRawVideoFrames = localScreenShareOutgoingVideoStream != nil &&
        localScreenShareOutgoingVideoStream?.format != nil &&
        localScreenShareOutgoingVideoStream?.state == .started
        
        if canSendRawVideoFrames {
            localScreenShareOutgoingVideoStream?.send(frame: rawVideoFrameBuffer) { [weak self] error in
                if (error != nil) {
                    Task {
                        self?.callingSDKInitializer.requestStopSharing()
                        try? await self?.stopScreenSharingStream()
                    }
                    
                    self?.logger.debug("Share screen error \(error!)")
                }
            }
        }
    }
    
    func requestStopScreenSharingStream() {
        callingSDKInitializer.requestStopSharing()
    }
    
    func stopScreenSharingStream() async throws {
        guard let call = self.call,
              let videoStream = self.localScreenShareOutgoingVideoStream else {
            logger.debug("Share screen video stopped successfully without call")
            return
        }
        do {
            try await call.stopVideo(stream: videoStream)
            self.localScreenShareOutgoingVideoStream?.delegate = nil
            self.localScreenShareOutgoingVideoStream = nil
            
            logger.debug("Share screen video stopped successfully")
        } catch {
            logger.error( "Share screen video failed to stop. \(error)")
            throw error
        }
    }
    
    func switchCamera() async throws -> CameraDevice {
        guard let videoStream = localVideoStream else {
            let error = CallCompositeInternalError.cameraSwitchFailed
            logger.error("\(error)")
            throw error
        }
        let currentCamera = videoStream.source
        let flippedFacing: CameraFacing = currentCamera.cameraFacing == .front ? .back : .front
        
        let deviceInfo = await getVideoDeviceInfo(flippedFacing)
        try await change(videoStream, source: deviceInfo)
        return flippedFacing.toCameraDevice()
    }
    
    func startPreviewVideoStream() async throws -> String {
        _ = await getValidLocalVideoStream()
        return getLocalVideoStreamIdentifier() ?? ""
    }
    
    func muteLocalMic() async throws {
        guard let call = call else {
            return
        }
        guard !call.isOutgoingAudioMuted else {
            logger.warning("muteOutgoingAudio is skipped as outgoing audio already muted")
            return
        }
        
        do {
            try await call.muteOutgoingAudio()
        } catch {
            logger.error("ERROR: It was not possible to mute. \(error)")
            throw error
        }
        logger.debug("Mute successful")
    }
    
    func unmuteLocalMic() async throws {
        guard let call = call else {
            return
        }
        guard call.isOutgoingAudioMuted else {
            logger.warning("unmuteOutgoingAudio is skipped as outgoing audio already muted")
            return
        }
        
        do {
            try await call.unmuteOutgoingAudio()
        } catch {
            logger.error("ERROR: It was not possible to unmute. \(error)")
            throw error
        }
        logger.debug("Unmute successful")
    }
    
    func holdCall() async throws {
        guard let call = call else {
            return
        }
        
        do {
            try await call.hold()
            logger.debug("Hold Call successful")
        } catch {
            logger.error("ERROR: It was not possible to hold call. \(error)")
            throw error
        }
    }
    
    func resumeCall() async throws {
        guard let call = call else {
            return
        }
        
        do {
            try await call.resume()
            logger.debug("Resume Call successful")
        } catch {
            logger.error( "ERROR: It was not possible to resume call. \(error)")
            throw error
        }
    }
    
    func getLogFiles() -> [URL] {
        // First lets check if any blog files exist
        // Edge case this is called before any CallClient can cause crash
        let fileManager = FileManager.default
        let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let blogFiles = try? fileManager.contentsOfDirectory(at: cacheDir, includingPropertiesForKeys: nil, options: [])
            .filter { $0.pathExtension == "blog" }
        
        // If we have Blog Files, this is safe to call
        if let blogFiles = blogFiles, !blogFiles.isEmpty {
            return callingSDKInitializer.setupCallClient().debugInfo.supportFiles
        } else {
            return []
        }
    }
    
    /* <CALL_START_TIME>
     func callStartTime() -> Date? {
     guard let call = call else {
     return nil
     }
     
     if call.state == .connecting {
     return nil
     }
     
     return call.startTime
     }
     </CALL_START_TIME> */
    
    func admitAllLobbyParticipants() async throws {
        guard let call = call else {
            return
        }
        
        do {
            try await call.callLobby.admitAll()
            logger.debug("Admit All participants successful")
        } catch {
            logger.error("ERROR: It was not possible to admit all lobby participants. \(error)")
            throw error
        }
    }
    
    func admitLobbyParticipant(_ participantId: String) async throws {
        guard let call = call else {
            return
        }
        
        let identifier = createCommunicationIdentifier(fromRawId: participantId)
        
        do {
            try await call.callLobby.admit(identifiers: [identifier])
            logger.debug("Admit participants successful")
        } catch {
            logger.error("ERROR: It was not possible to admit lobby participants. \(error)")
            throw error
        }
    }
    
    func declineLobbyParticipant(_ participantId: String) async throws {
        guard let call = call else {
            return
        }
        
        let identifier = createCommunicationIdentifier(fromRawId: participantId)
        
        do {
            try await call.callLobby.reject(identifier: identifier)
            logger.debug("Reject lobby participants successful")
        } catch {
            logger.error("ERROR: It was not possible to reject lobby participants. \(error)")
            throw error
        }
    }
    
    func startCaptions(_ language: String) async throws {
        guard let call = call else {
            return
        }
        
        let captionsFeature = call.feature(Features.captions)
        let options = StartCaptionsOptions()
        if !language.isEmpty {
            options.spokenLanguage = language
        }
        do {
            let captions = try await captionsFeature.getCaptions()
            try await captions.startCaptions(options: options)
            logger.debug("Start captions successfully")
        } catch {
            logger.error("ERROR: It was not possible to start captions \(error)")
            throw error
        }
    }
    
    func removeParticipant(_ participantId: String) async throws {
        guard let participantToRemove = call?.remoteParticipants
            .first(where: {$0.identifier.rawId == participantId}) else {
            return
        }
        
        do {
            try await call?.remove(participant: participantToRemove)
            logger.debug("Participant remove successful")
        } catch {
            logger.error("Error: Participant remove operation unsuccessful. Please check capabilities.")
            throw error
        }
    }
    
    func stopCaptions() async throws {
        guard let call = call else {
            return
        }
        
        let captionsFeature = call.feature(Features.captions)
        do {
            
            let captions = try await captionsFeature.getCaptions()
            try await captions.stopCaptions()
            logger.debug("Stop captions successfully")
        } catch {
            logger.error("ERROR: It was not possible to stop captions \(error)")
            throw error
        }
    }
    
    func setCaptionsSpokenLanguage(_ language: String) async throws {
        guard let call = call else {
            return
        }
        
        let captionsFeature = call.feature(Features.captions)
        do {
            
            let captions = try await captionsFeature.getCaptions()
            try await captions.set(spokenLanguage: language)
            logger.debug("Set captions spoken language successfully")
        } catch {
            logger.error("ERROR: It was not possible to set captions spoken language \(error)")
            throw error
        }
    }
    
    func setCaptionsCaptionLanguage(_ language: String) async throws {
        guard let call = call else {
            return
        }
        
        let captionsFeature = call.feature(Features.captions)
        do {
            
            let captions = try await captionsFeature.getCaptions()
            if let teamsCaptions = captions as? TeamsCaptions {
                try await teamsCaptions.set(captionLanguage: language)
            }
            
            logger.debug("Set captions caption language successfully")
        } catch {
            logger.error("ERROR: It was not possible to set captions caption language \(error)")
            throw error
        }
        
    }
    
    func getCapabilities() async throws -> Set<ParticipantCapabilityType> {
        guard let capabilitiesFeature = call?.feature(Features.capabilities) else {
            return []
        }
        
        let capabilities = capabilitiesFeature.capabilities
        for capability in capabilities {
            print(capability)
        }
        let filtered = capabilities.compactMap { $0.toParticipantCapability() }
            .filter { $0.allowed }
            .map { $0.type }
        
        for capability in filtered {
            print(capability)
        }
        
        return Set(filtered)
    }
    
    func raiseHand() async throws {
        guard let call = call else {
            return
        }
        
        let raisehandFeature =  call.feature(Features.raisedHands)
        
        do {
            try await raisehandFeature.raiseHand()
            logger.debug("Set raise hand successfully")
        } catch {
            logger.error("ERROR: It was not possible to raise hand \(error)")
            throw error
        }
    }
    
    func lowerHand() async throws {
        guard let call = call else {
            return
        }
        
        let raisehandFeature = call.feature(Features.raisedHands)
        
        do {
            try await raisehandFeature.lowerHand()
            logger.debug("Set lower hand successfully")
        } catch {
            logger.error("ERROR: It was not possible to lower hand \(error)")
            throw error
        }
    }
    
    func getRaiseHands() -> [RaisedHand] {
        guard let call = call else {
            return []
        }
        
        let raisehandFeature =  call.feature(Features.raisedHands)
        return raisehandFeature.raisedHands
    }
    
    func setBackgroundEffect(_ effect: LocalUserState.BackgroundEffectType) {
        guard let videoEffectsFeature = localVideoStream?.feature(Features.localVideoEffects) else {
            return
        }
        
        switch effect {
        case .none:
            // Disable both known effect types just to be sure
            videoEffectsFeature.disable(effect: BackgroundBlurEffect())
            videoEffectsFeature.disable(effect: BackgroundReplacementEffect())
            
        case .blur:
            let blurEffect = BackgroundBlurEffect()
            
            if videoEffectsFeature.isSupported(effect: blurEffect) {
                videoEffectsFeature.enable(effect: blurEffect)
            }
            
        case .backgroundOne, .backgroundTwo, .backgroundThree, .backgroundFour, .backgroundFive, .backgroundSix:
            // Assuming your `ImageProvider().getImage(...)` provides access to a `UIImage`
            guard let image = effect.effectImage,
                  let imageData = image.jpegData(compressionQuality: 1.0) else {
                return
            }
            
            let replacementEffect = BackgroundReplacementEffect()
            replacementEffect.buffer = imageData
            
            if videoEffectsFeature.isSupported(effect: replacementEffect) {
                videoEffectsFeature.enable(effect: replacementEffect)
            }
        }
    }
    
    func sendReaction(_ reaction: ReactionType) async throws {
        guard let call = call else {
            return
        }
        
        let options = DataChannelSenderOptions()
        options.channelId = 1000
        options.bitrateInKbps = 32
        options.priority = DataChannelPriority.normal
        options.reliability = DataChannelReliability.lossy
        
        let dataChannelCallFeature = call.feature(Features.dataChannel)
        let sender = dataChannelCallFeature.getDataChannelSender(options: options)
        
        let localUser = GlobalCompositeManager.callComposite?.localUserId
        
        let payload = ReactionPayload(reaction: reaction)
        let message: ReactionMessage = [localUser ?? "": payload]
        
        do {
            let jsonData = try JSONEncoder().encode(message)
            sender.sendMessage(data: jsonData)
        } catch {
            print("❌ Failed to encode reaction: \(error)")
            throw error
        }
    }
    
    func muteCall() async throws {
        guard let call = call else {
            return
        }
        
        do {
            try await call.muteIncomingAudio()
        } catch {
            print("❌ Failed to mute call")
            throw error
        }
    }
    
    func unMuteCall() async throws {
        guard let call = call else {
            return
        }
        
        do {
            try await call.unmuteIncomingAudio()
        } catch {
            print("❌ Failed to unMute call")
            throw error
        }
    }
    
    func enableNoiseSuppression() {
        guard let call = call else {
            return
        }
        
        call.liveOutgoingAudioFilters.musicModeEnabled = true
        call.liveOutgoingAudioFilters.acousticEchoCancellationEnabled = true
        call.liveOutgoingAudioFilters.noiseSuppressionMode = .high
    }
    
    func disableNoiseSuppression() {
        guard let call = call else {
            return
        }
        
        call.liveOutgoingAudioFilters.acousticEchoCancellationEnabled = false
        call.liveOutgoingAudioFilters.noiseSuppressionMode = .off
    }
    
    func showChat(azureCorrelationId: String?) {
        callingSDKInitializer.showChat(azureCorrelationId: azureCorrelationId)
    }
}

extension CallingSDKWrapper {
    private func setupCallClientAndDeviceManager() async throws {
        do {
            let deviceManager = try await callingSDKInitializer.setupCallClient().getDeviceManager()
            deviceManager.delegate = self
            self.deviceManager = deviceManager
        } catch {
            throw CallCompositeInternalError.deviceManagerFailed(error)
        }
    }
    
    private func startCallVideoStream(
        _ videoStream: AzureCommunicationCalling.LocalVideoStream
    ) async throws -> String {
        guard let call = self.call else {
            let error = CallCompositeInternalError.cameraOnFailed
            self.logger.error( "Start call video stream failed")
            throw error
        }
        do {
            let localVideoStreamId = getLocalVideoStreamIdentifier() ?? ""
            try await call.startVideo(stream: videoStream)
            logger.debug("Local video started successfully")
            return localVideoStreamId
        } catch {
            logger.error( "Local video failed to start. \(error)")
            throw error
        }
    }
    
    private func change(
        _ videoStream: AzureCommunicationCalling.LocalVideoStream, source: VideoDeviceInfo
    ) async throws {
        do {
            try await videoStream.switchSource(camera: source)
            logger.debug("Local video switched camera successfully")
        } catch {
            logger.error( "Local video failed to switch camera. \(error)")
            throw error
        }
    }
    
    private func setupFeatures() {
        guard let call = call else {
            return
        }
        let recordingCallFeature = call.feature(Features.recording)
        let transcriptionCallFeature = call.feature(Features.transcription)
        let dominantSpeakersFeature = call.feature(Features.dominantSpeakers)
        let localUserDiagnosticsFeature = call.feature(Features.localUserDiagnostics)
        let captionsFeature = call.feature(Features.captions)
        let capabilitiesFeature = call.feature(Features.capabilities)
        let raiseHandFeature = call.feature(Features.raisedHands)
        let localVideoEffectsFeature = localVideoStream?.feature(Features.localVideoEffects)
        let dataChannelCallFeature = call.feature(Features.dataChannel)
        
        if let callingEventsHandler = self.callingEventsHandler as? CallingSDKEventsHandler {
            callingEventsHandler.assign(recordingCallFeature)
            callingEventsHandler.assign(transcriptionCallFeature)
            callingEventsHandler.assign(dominantSpeakersFeature)
            callingEventsHandler.assign(localUserDiagnosticsFeature)
            callingEventsHandler.assign(captionsFeature)
            callingEventsHandler.assign(capabilitiesFeature)
            callingEventsHandler.assign(raiseHandFeature)
            callingEventsHandler.assign(localVideoEffectsFeature)
            callingEventsHandler.assign(dataChannelCallFeature)
            
            if callConfiguration.compositeCallType == .oneToOneIncoming && call.state == .connected {
                // If call is accepted from CallKit
                // call state can already be accepted, thus call state change will be missed
                callingEventsHandler.onStateChanged(call: call)
            }
        }
    }
    
    private func getLocalVideoStreamIdentifier() -> String? {
        guard localVideoStream != nil else {
            return nil
        }
        return "builtinCameraVideoStream"
    }
    
    private func getValidLocalVideoStream() async -> AzureCommunicationCalling.LocalVideoStream {
        if let existingVideoStream = localVideoStream {
            return existingVideoStream
        }
        
        let videoDevice = await getVideoDeviceInfo(.front)
        let videoStream = AzureCommunicationCalling.LocalVideoStream(camera: videoDevice)
        localVideoStream = videoStream
        return videoStream
    }
    
    private func getValidScreenShareStream() -> AzureCommunicationCalling.ScreenShareOutgoingVideoStream {
        if let existingScreenShareStream = localScreenShareOutgoingVideoStream {
            return existingScreenShareStream
        }
        
        let videoStream =  ScreenShareOutgoingVideoStream(
            videoStreamOptions: createRawOutgoingVideoStreamOptions())
        localScreenShareOutgoingVideoStream = videoStream
        localScreenShareOutgoingVideoStream?.delegate = self
        return videoStream
    }
    
    private func createRawOutgoingVideoStreamOptions() -> RawOutgoingVideoStreamOptions {
        let format = createVideoStreamFormat()
        
        let options = RawOutgoingVideoStreamOptions()
        options.formats = [format]
        
        return options
    }
    
    private func createVideoStreamFormat() -> VideoStreamFormat {
        let format = VideoStreamFormat()
        format.pixelFormat = VideoStreamPixelFormat.nv12
        format.framesPerSecond = 30.0
        
        let maxWidth: Double = 1920.0
        let maxHeight: Double = 1080.0
        
        let screenSize = UIScreen.main.bounds
        var w = screenSize.width
        var h = screenSize.height
        
        if h > maxHeight {
            let percentage = abs((maxHeight / h) - 1);
            w = ceil((w * percentage));
            h = maxHeight;
        }
        
        if w > maxWidth {
            let percentage = abs((maxWidth / w) - 1);
            h = ceil((h * percentage));
            w = maxWidth;
        }
        
        format.width = Int32(w)
        format.height = Int32(h)
        format.stride1 = Int32(w)
        format.stride2 = Int32(w)
        
        return format
    }
    
    private func resetVideoEffects() {
        localVideoStream?.feature(Features.localVideoEffects).disable(effect: BackgroundBlurEffect())
    }
}
// swiftlint:enable type_body_length

extension CallingSDKWrapper: DeviceManagerDelegate {
    func deviceManager(_ deviceManager: DeviceManager, didUpdateCameras args: VideoDevicesUpdatedEventArgs) {
        for newDevice in args.addedVideoDevices {
            newVideoDeviceAddedHandler?(newDevice)
        }
    }
    
    private func getVideoDeviceInfo(_ cameraFacing: CameraFacing) async -> VideoDeviceInfo {
        // If we have a camera, return the value right away
        await withCheckedContinuation({ continuation in
            if let camera = deviceManager?.cameras
                .first(where: { $0.cameraFacing == cameraFacing }
                ) {
                newVideoDeviceAddedHandler = nil
                return continuation.resume(returning: camera)
            }
            newVideoDeviceAddedHandler = { deviceInfo in
                if deviceInfo.cameraFacing == cameraFacing {
                    continuation.resume(returning: deviceInfo)
                }
            }
        })
    }
}

extension CallingSDKWrapper: ScreenShareOutgoingVideoStreamDelegate {
    func screenShareOutgoingVideoStream(_ screenShareOutgoingVideoStream: ScreenShareOutgoingVideoStream,
                                        didChangeState args: VideoStreamStateChangedEventArgs) {
        let stream = args.stream
        switch (stream.direction) {
        case .outgoing:
            outgoingVideoStreamStateChanged(stream: stream as! OutgoingVideoStream)
            
        default:
            break
        }
    }
    
    private func outgoingVideoStreamStateChanged(stream: OutgoingVideoStream) {
        switch stream.state {
        case .stopped:
            switch stream.type {
            case .screenShareOutgoing:
                Task {
                    try? await stopScreenSharingStream()
                }
                
            default:
                break
            }
            
        default:
            break
        }
    }
}
