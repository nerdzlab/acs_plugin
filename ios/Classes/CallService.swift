//
//  CallService.swift
//  Pods
//
//  Created by Yriy Malyts on 27.03.2025.
//

import AzureCommunicationCalling
import AVFoundation

class CallService {
    
    private var callAgent: CallAgent?
    private var call: Call?
    private var callObserver: CallObserver?
    private var deviceManager: DeviceManager?
    private var muted: Bool = false
    private var speakerEnabled: Bool = false
    
    var participants: [[Participant]] = [[]]
    
    var callState: String = "Unknown"
    
    // Method to join the call
    func joinRoomCall(roomId: String, completion: @escaping (String) -> Void) {
        if self.callAgent == nil {
            completion("CallAgent not initialized")
            return
        }
        
        if roomId.isEmpty {
            completion("Room ID not set")
            return
        }
        
        let options = JoinCallOptions()
        let audioOptionsOutgoing = OutgoingAudioOptions()
        audioOptionsOutgoing.muted = false
        options.outgoingAudioOptions = audioOptionsOutgoing
        
        let roomCallLocator = RoomCallLocator(roomId: roomId)
        
        self.callAgent?.join(with: roomCallLocator, joinCallOptions: options) { (call, error) in
            if let error = error {
                completion("Failed to join the call: \(error.localizedDescription)")
                return
            }
            
            self.setCallAndObserver(call: call, error: error)
            completion("Joined call successfully")
        }
    }
    
    // Method to leave the call
    func leaveRoomCall(completion: @escaping (String) -> Void) {
        if let currentCall = self.call {
            currentCall.hangUp(options: nil) { error in
                if let error = error {
                    completion("Failed to leave the call: \(error.localizedDescription)")
                    return
                }
                self.call = nil
                completion("Left the call successfully")
            }
        } else {
            completion("No active call to leave")
        }
    }
    
    // Private method to set the call and observer
    private func setCallAndObserver(call: Call?, error: Error?) {
        if error == nil, let call = call {
            self.call = call
            self.callObserver = CallObserver(callService: self)
            self.call?.delegate = self.callObserver
        
            if (self.call!.state == CallState.connected) {
                self.callObserver!.handleInitialCallState(call: call)
            }
        } else {
            self.callState = "Failed to set CallObserver"
        }
    }
    
    public func setCallAgent(callAgent: CallAgent, callHandler: CallHandler)
    {
        self.callAgent = callAgent
        self.callAgent?.delegate = callHandler
    }
    
    public func setDeviceManager(deviceManager: DeviceManager)
    {
        self.deviceManager = deviceManager
    }
    
    public func callRemoved(_ call: Call) {
        self.call = nil
    }
}

public class CallObserver : NSObject, CallDelegate {
    private var firstTimeCallConnected: Bool = true
    private var callService: CallService
    
    init(callService: CallService) {
        self.callService = callService
        super.init()
    }

    public func call(_ call: Call, didChangeState args: PropertyChangedEventArgs) {
        let state = CallObserver.callStateToString(state:call.state)
        callService.callState = state
        
        if (call.state == CallState.disconnected) {
            callService.leaveRoomCall()
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

        callService.callState = CallObserver.callStateToString(state: call.state)
        var participants = [Participant]()

        // Add older/existing participants
        callService.participants.forEach { (existingParticipants: [Participant]) in
            participants.append(contentsOf: existingParticipants)
        }
        callService.participants.removeAll()

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
            callService.participants.append(newParticipants)
        }
    }

    public func call(_ call: Call, didUpdateRemoteParticipant args: ParticipantsUpdatedEventArgs) {
        var participants = [Participant]()
        // Add older/existing participants
        callService.participants.forEach { (existingParticipants: [Participant]) in
            participants.append(contentsOf: existingParticipants)
        }
        callService.participants.removeAll()

        // Remove deleted participants from the collection
        args.removedParticipants.forEach { p in
            let mri = Utilities.toMri(p.identifier)
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
            callService.participants.append(array)
        }
    }
    
    func toggleMute() {
        if (self.muted) {
            call!.unmuteOutgoingAudio(completionHandler: { (error) in
                if error == nil {
                    self.muted = false
                }
            })
        } else {
            call!.muteOutgoingAudio(completionHandler: { (error) in
                if error == nil {
                    self.muted = true
                }
            })
        }
    }
    
    func toggleSpeaker() {
        let audioSession = AVAudioSession.sharedInstance()
        if self.speakerEnabled {
            try! audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        } else {
            try! audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        }
        
        self.speakerEnabled = !self.speakerEnabled
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

class Participant: NSObject, RemoteParticipantDelegate, ObservableObject {
    private var videoStreamCount = 0
    private let innerParticipant:RemoteParticipant
    private let call:Call
    private var renderedRemoteVideoStream:RemoteVideoStream?
    
    @Published var state:ParticipantState = ParticipantState.disconnected
    @Published var isMuted:Bool = false
    @Published var isSpeaking:Bool = false
    @Published var hasVideo:Bool = false
    @Published var displayName:String = ""
    @Published var videoOn:Bool = true
    @Published var renderer:VideoStreamRenderer? = nil
    @Published var rendererView:RendererView? = nil
    @Published var scalingMode: ScalingMode = .fit

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
