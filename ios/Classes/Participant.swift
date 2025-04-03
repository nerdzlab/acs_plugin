//
//  Participant.swift
//  Pods
//
//  Created by Yriy Malyts on 28.03.2025.
//
import AzureCommunicationCalling
import AVFoundation
import Foundation
import Flutter

public class Participant: NSObject, RemoteParticipantDelegate {
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
        AcsPlugin.shared.updateParticipant(self)
    }
    
    func toggleVideo(result: @escaping FlutterResult) {
        if videoOn {
            rendererView = nil
            renderer?.dispose()
            videoOn = false
            AcsPlugin.shared.updateParticipant(self)
            result("Participant video is turned off")
        }
        else {
            renderer = try! VideoStreamRenderer(remoteVideoStream: innerParticipant.videoStreams[0])
            rendererView = try! renderer!.createView()
            videoOn = true
            AcsPlugin.shared.updateParticipant(self)
            result("Participant video is turned on")
        }
    }
    
    public func remoteParticipant(_ remoteParticipant: RemoteParticipant, didUpdateVideoStreams args: RemoteVideoStreamsEventArgs) {
        let hadVideo = hasVideo
        hasVideo = innerParticipant.videoStreams.count > 0
        if videoOn {
            if hadVideo && !hasVideo {
                // Remote user stopped sharing
                rendererView = nil
                renderer?.dispose()
                AcsPlugin.shared.updateParticipant(self)
                
            } else if hasVideo && !hadVideo {
                // remote user started sharing
                renderedRemoteVideoStream = innerParticipant.videoStreams[0]
                renderer = try! VideoStreamRenderer(remoteVideoStream: renderedRemoteVideoStream!)
                rendererView = try! renderer!.createView()
                AcsPlugin.shared.updateParticipant(self)
                
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
                    AcsPlugin.shared.updateParticipant(self)
                    
                } else if args.removedRemoteVideoStreams.count > 0 {
                    if args.removedRemoteVideoStreams[0].id == renderedRemoteVideoStream!.id {
                        // remote user stopped sharing video that we were rendering but is sharing
                        // another video that we can render
                        renderer!.dispose()
                        
                        renderedRemoteVideoStream = innerParticipant.videoStreams[0]
                        renderer = try! VideoStreamRenderer(remoteVideoStream: renderedRemoteVideoStream!)
                        rendererView = try! renderer!.createView()
                        AcsPlugin.shared.updateParticipant(self)
                    }
                }
            }
        }
    }
    
    // Handle mute state changes
    public func remoteParticipant(_ remoteParticipant: RemoteParticipant, didChangeMuteState args: PropertyChangedEventArgs) {
        isMuted = remoteParticipant.isMuted
        AcsPlugin.shared.updateParticipant(self)
    }
    
    // Handle speaking state changes
    public func remoteParticipant(_ remoteParticipant: RemoteParticipant, didChangeSpeakingState args: PropertyChangedEventArgs) {
        isSpeaking = remoteParticipant.isSpeaking
        AcsPlugin.shared.updateParticipant(self)
    }
    
    // Handle display name changes
    public func remoteParticipant(_ remoteParticipant: RemoteParticipant, didChangeDisplayName args: PropertyChangedEventArgs) {
        displayName = innerParticipant.displayName
        AcsPlugin.shared.updateParticipant(self)
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

extension Participant {
    func toMap() -> [String: Any] {
        return [
            "displayName": self.displayName,
            "mri": self.getMri(),
            "isMuted": self.isMuted,
            "isSpeaking": self.isSpeaking,
            "hasVideo": self.hasVideo,
            "videoOn": self.videoOn,
            "state": self.state.rawValue, // Assuming ParticipantState is an enum with raw values
            "scalingMode": self.scalingMode.rawValue, // Similarly for ScalingMode
            "rendererViewId": self.getMri(),
        ]
    }
}
