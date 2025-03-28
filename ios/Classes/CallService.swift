//
//  CallService.swift
//  Pods
//
//  Created by Yriy Malyts on 27.03.2025.
//

import AzureCommunicationCalling
import AVFoundation
import Foundation
import Flutter

//class CallService {
//    private var callAgent: CallAgent?
//    private var call: Call?
//    private var callObserver: CallObserver?
//    private var deviceManager: DeviceManager?
//    
//    var participants: [[Participant]] = [[]]
//    
//    var callState: String = "Unknown"
//    
//    // Method to join the call
//    func joinRoomCall(roomId: String, result: @escaping FlutterResult) {
//        if self.callAgent == nil {
//            debugPrint("Error____ CallAgent not initialized")
//            result("CallAgent not initialized")
//            return
//        }
//        
//        if roomId.isEmpty {
//            debugPrint("Error____ Room ID not set")
//            result("Room ID not set")
//            return
//        }
//        
//        let options = JoinCallOptions()
//        let audioOptionsOutgoing = OutgoingAudioOptions()
//        audioOptionsOutgoing.muted = false
//        options.outgoingAudioOptions = audioOptionsOutgoing
//        
//        let roomCallLocator = RoomCallLocator(roomId: roomId)
//        
//        self.callAgent?.join(with: roomCallLocator, joinCallOptions: options) { [weak self] (call, error) in
//            DispatchQueue.main.async {
//                if let error = error {
//                    debugPrint("Error____ Failed to join the call: \(error.localizedDescription)")
//                    result("Failed to join the call: \(error.localizedDescription)")
//                    return
//                }
//                
//                self?.setCallAndObserver(call: call, error: error)
//                debugPrint("Success___ Joined call successfully")
//                result("Joined call successfully")
//            }
//        }
//    }
//    
//    // Method to leave the call
//    func leaveRoomCall(result: @escaping FlutterResult) {
//        if let currentCall = self.call {
//            currentCall.hangUp(options: nil) { [weak self] error in
//                
//                if let error = error {
//                    debugPrint("Error____ Failed to leave the call: \(error.localizedDescription)")
//                    result("Failed to leave the call: \(error.localizedDescription)")
//                    return
//                }
//                
//                self?.call = nil
//                debugPrint("Success___ Left the call successfully")
//                result("Left the call successfully")
//            }
//        } else {
//            debugPrint("Error____ No active call to leave")
//            result("No active call to leave")
//        }
//    }
//    
//    // Private method to set the call and observer
//    private func setCallAndObserver(call: Call?, error: Error?) {
//        debugPrint("Success___ CallAgent set call observer")
//        
//        if error == nil, let call = call {
//            self.call = call
//            self.callObserver = CallObserver(callService: self)
//            self.call?.delegate = self.callObserver
//            
//            if (self.call!.state == CallState.connected) {
//                self.callObserver!.handleInitialCallState(call: call)
//            }
//        } else {
//            self.callState = "Failed to set CallObserver"
//        }
//    }
//    
//    public func setCallAgent(callAgent: CallAgent, callHandler: CallHandler) {
//        self.callAgent = callAgent
//        self.callAgent?.delegate = callHandler
//    }
//    
//    public func setDeviceManager(deviceManager: DeviceManager) {
//        self.deviceManager = deviceManager
//    }
//    
//    public func callRemoved(_ call: Call) {
//        self.call = nil
//    }
//    
//    func toggleMute(result: @escaping FlutterResult) {
//        guard let call = call else {
//            debugPrint("Error___ No active call to toggle mute")
//            result(FlutterError(code: "NO_ACTIVE_CALL", message: "No active call to toggle mute", details: nil))
//            return
//        }
//
//        let isMuted = call.isOutgoingAudioMuted
//        
//        if isMuted {
//            call.unmuteOutgoingAudio { error in
//                if let error = error {
//                    debugPrint("Error___ MUTE_ERROR Failed to unmute: \(error.localizedDescription)")
//                    result(FlutterError(code: "MUTE_ERROR", message: "Failed to unmute: \(error.localizedDescription)", details: nil))
//                } else {
//                    debugPrint("Success___ Muted = false (unmuted)")
//                    result(false) // Muted = false (unmuted)
//                }
//            }
//        } else {
//            call.muteOutgoingAudio { error in
//                if let error = error {
//                    debugPrint("Error___ MUTE_ERROR Failed to mute: \(error.localizedDescription)")
//                    result(FlutterError(code: "MUTE_ERROR", message: "Failed to mute: \(error.localizedDescription)", details: nil))
//                } else {
//                    debugPrint("Success___ Muted = true")
//                    result(true) // Muted = true
//                }
//            }
//        }
//    }
//    
//    func toggleSpeaker(result: @escaping FlutterResult) {
//        let audioSession = AVAudioSession.sharedInstance()
//        
//        do {
//            let isSpeakerOn = audioSession.currentRoute.outputs.contains { $0.portType == .builtInSpeaker }
//            
//            if isSpeakerOn {
//                try audioSession.overrideOutputAudioPort(.none)
//                debugPrint("Success___ Speaker disabled")
//                result(false) // Speaker disabled
//            } else {
//                try audioSession.overrideOutputAudioPort(.speaker)
//                debugPrint("Success___ Speaker enabled")
//                result(true) // Speaker enabled
//            }
//        } catch {
//            debugPrint("Error____ SPEAKER_ERROR Failed to toggle speaker: \(error.localizedDescription)")
//            result(FlutterError(code: "SPEAKER_ERROR", message: "Failed to toggle speaker: \(error.localizedDescription)", details: nil))
//        }
//    }
//}


final class CallService: NSObject, CallAgentDelegate {
    
    // Public Properties
    public var callAgent: CallAgent?  // Holds the reference to the current call agent
    public var callClient: CallClient?
    public var call: Call?  // Holds the reference to the current active call
    public var callObserver: CallObserver?  // Observer for the current call events
    public var deviceManager: DeviceManager?  // Device manager for accessing devices
    public var initialized = false  // Indicates if the CallService is initialized
    public var participants: [[Participant]] = [[]]  // List of participants in the call
    public var callState: String = "Unknown"  // Tracks the current state of the call
    
    // This method will be used to send errors back to Flutter
    private var result: FlutterResult?
    
    // Singleton instance of CallService
    private static var instance: CallService?  // Singleton instance
    
    // Public Methods
    
    /// Get or create the singleton instance of `CallService`
    static func getOrCreateInstance() -> CallService {
        if let service = instance {
            return service
        }
        instance = CallService()
        return instance!
    }
    
    /// Initializes the call service with the provided token.
    /// - Parameter token: Communication token for authentication.
    /// - Parameter result: Callback to return success or error result.
    public func initializeCall(token: String, result: @escaping FlutterResult) {
        // Check if already initialized
        if initialized {
            debugPrint("Success___ Already initialized")
            result("Already initialized")
            return
        }
        
        self.result = result
        
        // Attempt to create the token credential
        var userCredential: CommunicationTokenCredential
        do {
            userCredential = try CommunicationTokenCredential(token: token)
        } catch {
            debugPrint("Error____ Failed to create CommunicationTokenCredential")
            result(FlutterError(code: "CREDENTIAL_ERROR", message: "Failed to create CommunicationTokenCredential", details: nil))
            return
        }
        
        // Initialize the call client and fetch device manager
        self.callClient = CallClient()
        
        self.callClient!.getDeviceManager { [weak self] (deviceManager, error) in
            if let error = error {
                debugPrint("Error____ Failed to get DeviceManager \(error.localizedDescription)")
                self?.result?(FlutterError(code: "DEVICE_MANAGER_ERROR", message: "Failed to get DeviceManager", details: error.localizedDescription))
                return
            }
            
            debugPrint("Success___ Got device manager instance")
            self?.deviceManager = deviceManager
        }
        
        // Creating the call agent
        let options = CallAgentOptions()
        
        self.callClient!.createCallAgent(userCredential: userCredential, options: options) { [weak self] (callAgent, error) in
            if let error = error {
                debugPrint("Error____ Failed to create CallAgent \(error.localizedDescription)")
                self?.result?(FlutterError(code: "CALL_AGENT_ERROR", message: "Failed to create CallAgent", details: error.localizedDescription))
                return
            }
            
            guard let self = self else {
                debugPrint("Error____ Self is null")
                self?.result?(FlutterError(code: "Error", message: "Self is null", details: ""))
                return
            }
            
            // Successfully created the call agent, set it and notify the result
            self.callAgent = callAgent
            self.callAgent?.delegate = self
            self.initialized = true
            debugPrint("Success___ Call Agent Initialized Successfully")
            self.result?("Call Agent Initialized Successfully")
        }
    }
    
    /// Handles updates from the CallAgent, e.g., when a call is removed.
    /// - Parameters:
    ///   - callAgent: The call agent that triggered the update.
    ///   - args: Arguments containing updated call information.
    public func callAgent(_ callAgent: CallAgent, didUpdateCalls args: CallsUpdatedEventArgs) {
        if let removedCall = args.removedCalls.first {
            self.callRemoved(removedCall)
            debugPrint("Error____ Call removed")
            result?(FlutterError(code: "Error", message: "Call removed", details: nil))
        }
    }
    
    /// Joins a room call using the provided room ID.
    /// - Parameter roomId: The ID of the room to join.
    /// - Parameter result: Callback to return the success or failure result.
    public func joinRoomCall(roomId: String, result: @escaping FlutterResult) {
        if self.callAgent == nil {
            debugPrint("Error____ CallAgent not initialized")
            result("CallAgent not initialized")
            return
        }
        
        if roomId.isEmpty {
            debugPrint("Error____ Room ID not set")
            result("Room ID not set")
            return
        }
        
        // Join options
        let options = JoinCallOptions()
        let audioOptionsOutgoing = OutgoingAudioOptions()
        audioOptionsOutgoing.muted = false
        options.outgoingAudioOptions = audioOptionsOutgoing
        
        let roomCallLocator = RoomCallLocator(roomId: roomId)
        
        self.callAgent?.join(with: roomCallLocator, joinCallOptions: options) { [weak self] (call, error) in
            DispatchQueue.main.async {
                if let error = error {
                    debugPrint("Error____ Failed to join the call: \(error.localizedDescription)")
                    result("Failed to join the call: \(error.localizedDescription)")
                    return
                }
                
                self?.setCallAndObserver(call: call, error: error)
                debugPrint("Success___ Joined call successfully")
                result("Joined call successfully")
            }
        }
    }
    
    /// Leaves the current room call if active.
    /// - Parameter result: Callback to return the success or failure result.
    public func leaveRoomCall(result: @escaping FlutterResult) {
        if let currentCall = self.call {
            currentCall.hangUp(options: nil) { [weak self] error in
                if let error = error {
                    debugPrint("Error____ Failed to leave the call: \(error.localizedDescription)")
                    result("Failed to leave the call: \(error.localizedDescription)")
                    return
                }
                
                self?.call = nil
                debugPrint("Success___ Left the call successfully")
                result("Left the call successfully")
            }
        } else {
            debugPrint("Error____ No active call to leave")
            result("No active call to leave")
        }
    }
    
    /// Toggles the mute state of the outgoing audio for the current call.
    /// - Parameter result: Callback to return the new mute state.
    public func toggleMute(result: @escaping FlutterResult) {
        guard let call = call else {
            debugPrint("Error___ No active call to toggle mute")
            result(FlutterError(code: "NO_ACTIVE_CALL", message: "No active call to toggle mute", details: nil))
            return
        }

        let isMuted = call.isOutgoingAudioMuted
        
        if isMuted {
            call.unmuteOutgoingAudio { error in
                if let error = error {
                    debugPrint("Error___ MUTE_ERROR Failed to unmute: \(error.localizedDescription)")
                    result(FlutterError(code: "MUTE_ERROR", message: "Failed to unmute: \(error.localizedDescription)", details: nil))
                } else {
                    debugPrint("Success___ Muted = false (unmuted)")
                    result(false) // Muted = false (unmuted)
                }
            }
        } else {
            call.muteOutgoingAudio { error in
                if let error = error {
                    debugPrint("Error___ MUTE_ERROR Failed to mute: \(error.localizedDescription)")
                    result(FlutterError(code: "MUTE_ERROR", message: "Failed to mute: \(error.localizedDescription)", details: nil))
                } else {
                    debugPrint("Success___ Muted = true")
                    result(true) // Muted = true
                }
            }
        }
    }
    
    /// Toggles the speaker output of the audio session.
    /// - Parameter result: Callback to return the new speaker state.
    public func toggleSpeaker(result: @escaping FlutterResult) {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            let isSpeakerOn = audioSession.currentRoute.outputs.contains { $0.portType == .builtInSpeaker }
            
            if isSpeakerOn {
                try audioSession.overrideOutputAudioPort(.none)
                debugPrint("Success___ Speaker disabled")
                result(false) // Speaker disabled
            } else {
                try audioSession.overrideOutputAudioPort(.speaker)
                debugPrint("Success___ Speaker enabled")
                result(true) // Speaker enabled
            }
        } catch {
            debugPrint("Error____ SPEAKER_ERROR Failed to toggle speaker: \(error.localizedDescription)")
            result(FlutterError(code: "SPEAKER_ERROR", message: "Failed to toggle speaker: \(error.localizedDescription)", details: nil))
        }
    }
    
    // Private Methods
    
    /// Sets the call and attaches a call observer to it.
    /// - Parameter call: The call object to set.
    /// - Parameter error: The error encountered while joining the call.
    private func setCallAndObserver(call: Call?, error: Error?) {
        debugPrint("Success___ CallAgent set call observer")
        
        if error == nil, let call = call {
            self.call = call
            self.callObserver = CallObserver(callService: self)
            self.call?.delegate = self.callObserver
            
            if self.call?.state == CallState.connected {
                self.callObserver?.handleInitialCallState(call: call)
            }
        } else {
            self.callState = "Failed to set CallObserver"
        }
    }
    
    /// Handles the removal of a call.
    /// - Parameter call: The call that has been removed.
    private func callRemoved(_ call: Call) {
        self.call = nil
    }
}



public class CallObserver : NSObject, CallDelegate {
    private var firstTimeCallConnected: Bool = true
    private weak var callService: CallService?
    
    init(callService: CallService) {
        self.callService = callService
        super.init()
    }
    
    public func call(_ call: Call, didChangeState args: PropertyChangedEventArgs) {
        let state = CallObserver.callStateToString(state:call.state)
        callService?.callState = state
        
        if (call.state == CallState.disconnected) {
            callService?.leaveRoomCall(result: { _ in
                
            })
        }
        else if (call.state == CallState.connected) {
            if(self.firstTimeCallConnected) {
                self.handleInitialCallState(call: call);
            }
            self.firstTimeCallConnected = false;
        }
    }
    
    public func handleInitialCallState(call: Call) {
        // We want to build a matrix with max 2 columns
        
        callService?.callState = CallObserver.callStateToString(state: call.state)
        var participants = [Participant]()
        
        // Add older/existing participants
        callService?.participants.forEach { (existingParticipants: [Participant]) in
            participants.append(contentsOf: existingParticipants)
        }
        callService?.participants.removeAll()
        
        // Add new participants to the collection
        for remoteParticipant in call.remoteParticipants {
            let mri = Utilities.toMri(remoteParticipant.identifier)
            let found = participants.contains { (participant) -> Bool in
                participant.getMri() == mri
            }
            
            if !found {
                let participant = Participant(call, remoteParticipant)
                participants.append(participant)
            }
        }
        
        // Convert 1-D array into a 2-D array with 2 columns
        var indexOfParticipant = 0
        
        while indexOfParticipant < participants.count {
            var newParticipants = [Participant]()
            newParticipants.append(participants[indexOfParticipant])
            indexOfParticipant += 1
            if (indexOfParticipant < participants.count) {
                newParticipants.append(participants[indexOfParticipant])
                indexOfParticipant += 1
            }
            callService?.participants.append(newParticipants)
        }
    }
    
    public func call(_ call: Call, didUpdateRemoteParticipant args: ParticipantsUpdatedEventArgs) {
        var participants = [Participant]()
        // Add older/existing participants
        callService?.participants.forEach { (existingParticipants: [Participant]) in
            participants.append(contentsOf: existingParticipants)
        }
        callService?.participants.removeAll()
        
        // Remove deleted participants from the collection
        args.removedParticipants.forEach { member in
            let mri = Utilities.toMri(member.identifier)
            
            participants.removeAll { (participant) -> Bool in
                participant.getMri() == mri
            }
        }
        
        // Add new participants to the collection
        for remoteParticipant in args.addedParticipants {
            let mri = Utilities.toMri(remoteParticipant.identifier)
            let found = participants.contains { (view) -> Bool in
                view.getMri() == mri
            }
            
            if !found {
                let participant = Participant(call, remoteParticipant)
                participants.append(participant)
            }
        }
        
        // Convert 1-D array into a 2-D array with 2 columns
        var indexOfParticipant = 0
        
        while indexOfParticipant < participants.count {
            var array = [Participant]()
            array.append(participants[indexOfParticipant])
            indexOfParticipant += 1
            if (indexOfParticipant < participants.count) {
                array.append(participants[indexOfParticipant])
                indexOfParticipant += 1
            }
            callService?.participants.append(array)
        }
    }
    
    private static func callStateToString(state:CallState) -> String {
        switch state {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .disconnected: return "Disconnected"
        case .disconnecting: return "Disconnecting"
        case .none: return "None"
        default: return "Unknown"
        }
    }
}

class Participant: NSObject, RemoteParticipantDelegate {
    private var videoStreamCount = 0
    private let innerParticipant:RemoteParticipant
    private let call:Call
    private var renderedRemoteVideoStream:RemoteVideoStream?
    
    var state:ParticipantState = ParticipantState.disconnected
    var isMuted:Bool = false
    var isSpeaking:Bool = false
    var hasVideo:Bool = false
    var displayName:String = ""
    var videoOn:Bool = true
    var renderer:VideoStreamRenderer? = nil
    var rendererView:RendererView? = nil
    var scalingMode: ScalingMode = .fit
    
    init(_ call: Call, _ innerParticipant: RemoteParticipant) {
        self.call = call
        self.innerParticipant = innerParticipant
        self.displayName = innerParticipant.displayName
        
        super.init()
        
        self.innerParticipant.delegate = self
        
        self.state = innerParticipant.state
        self.isMuted = innerParticipant.isMuted
        self.isSpeaking = innerParticipant.isSpeaking
        self.hasVideo = innerParticipant.incomingVideoStreams.count > 0
        if(self.hasVideo) {
            handleInitialRemoteVideo()
        }
    }
    
    deinit {
        self.innerParticipant.delegate = nil
    }
    
    func getMri() -> String {
        Utilities.toMri(innerParticipant.identifier)
    }
    
    func set(scalingMode: ScalingMode) {
        if self.rendererView != nil {
            self.rendererView!.update(scalingMode: scalingMode)
        }
        self.scalingMode = scalingMode
    }
    
    func handleInitialRemoteVideo() {
        renderedRemoteVideoStream = innerParticipant.videoStreams[0]
        renderer = try! VideoStreamRenderer(remoteVideoStream: renderedRemoteVideoStream!)
        rendererView = try! renderer!.createView()
    }
    
    func toggleVideo() {
        if videoOn {
            rendererView = nil
            renderer?.dispose()
            videoOn = false
        }
        else {
            renderer = try! VideoStreamRenderer(remoteVideoStream: innerParticipant.videoStreams[0])
            rendererView = try! renderer!.createView()
            videoOn = true
        }
    }
    
    func remoteParticipant(_ remoteParticipant: RemoteParticipant, didUpdateVideoStreams args: RemoteVideoStreamsEventArgs) {
        let hadVideo = hasVideo
        hasVideo = innerParticipant.videoStreams.count > 0
        if videoOn {
            if hadVideo && !hasVideo {
                // Remote user stopped sharing
                rendererView = nil
                renderer?.dispose()
            } else if hasVideo && !hadVideo {
                // remote user started sharing
                renderedRemoteVideoStream = innerParticipant.videoStreams[0]
                renderer = try! VideoStreamRenderer(remoteVideoStream: renderedRemoteVideoStream!)
                rendererView = try! renderer!.createView()
            } else if hadVideo && hasVideo {
                if args.addedRemoteVideoStreams.count > 0 {
                    if renderedRemoteVideoStream?.id == args.addedRemoteVideoStreams[0].id {
                        return
                    }
                    
                    // remote user added a second video, so switch to the latest one
                    guard let rendererTemp = renderer else {
                        return
                    }
                    rendererTemp.dispose()
                    renderedRemoteVideoStream = args.addedRemoteVideoStreams[0]
                    renderer = try! VideoStreamRenderer(remoteVideoStream: renderedRemoteVideoStream!)
                    rendererView = try! renderer!.createView()
                } else if args.removedRemoteVideoStreams.count > 0 {
                    if args.removedRemoteVideoStreams[0].id == renderedRemoteVideoStream!.id {
                        // remote user stopped sharing video that we were rendering but is sharing
                        // another video that we can render
                        renderer!.dispose()
                        
                        renderedRemoteVideoStream = innerParticipant.videoStreams[0]
                        renderer = try! VideoStreamRenderer(remoteVideoStream: renderedRemoteVideoStream!)
                        rendererView = try! renderer!.createView()
                    }
                }
            }
        }
    }
    
    func remoteParticipant(_ remoteParticipant: RemoteParticipant, didChangeDisplayName args: PropertyChangedEventArgs) {
        self.displayName = innerParticipant.displayName
    }
}

class Utilities {
    @available(*, unavailable) private init() {}
    
    public static func toMri(_ id: CommunicationIdentifier?) -> String {
        
        if id is CommunicationUserIdentifier {
            let communicationUserIdentifier = id as! CommunicationUserIdentifier
            return communicationUserIdentifier.identifier
        } else {
            return "<nil>"
        }
    }
}
