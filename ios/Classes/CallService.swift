//
//  CallService.swift
//  Pods
//
//  Created by Yriy Malyts on 27.03.2025.
//

import AzureCommunicationCalling
import AzureCommunicationCalling
import AVFoundation
import Foundation
import Flutter

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
    
    private var sendingLocalVideo: Bool = false  // Define sendingLocalVideo property to track if video is being sent
    private var localVideoStreams: [LocalVideoStream]? // Define localVideoStreams to store the local video streams
    private var previewRenderer: VideoStreamRenderer? // For rendering the local video
    public var previewView: RendererView? // The view to display local video
    
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
    
    /// Toggles the local video stream on or off.
    /// - Parameter result: The FlutterResult callback used to return success, error messages, or the view reference.
    public func toggleLocalVideo(result: @escaping FlutterResult) {
        if self.sendingLocalVideo {
            // If video is currently being sent, stop it
            self.call!.stopVideo(stream: self.localVideoStreams!.first!) { (error) in
                if let error = error {
                    // Return an error message to Flutter if stopping video fails
                    result("Error____ Could not stop preview renderer: \(error.localizedDescription)")
                } else {
                    // Successfully stopped video
                    self.sendingLocalVideo = false
                    self.previewView = nil
                    self.previewRenderer?.dispose()
                    self.previewRenderer = nil
                    result(nil)
                }
            }
        } else {
            // Attempt to start sending video
            guard let availableCameras = self.deviceManager?.cameras, !availableCameras.isEmpty else {
                result("Error____ No available cameras found")
                return
            }

            let scalingMode: ScalingMode = .crop

            // Initialize local video streams if not already set
            if self.localVideoStreams == nil {
                self.localVideoStreams = [LocalVideoStream]()
            }

            // Create a new local video stream using the first available camera
            self.localVideoStreams?.append(LocalVideoStream(camera: availableCameras.first!))

            do {
                // Initialize the video renderer for displaying local preview
                self.previewRenderer = try VideoStreamRenderer(localVideoStream: self.localVideoStreams!.first!)
                self.previewView = try previewRenderer!.createView(withOptions: CreateViewOptions(scalingMode: scalingMode))

                // Start streaming the local video
                self.call?.startVideo(stream: self.localVideoStreams!.first!) { error in
                    if let error = error {
                        // Return an error message if video streaming fails
                        result("Error____ Could not share video: \(error.localizedDescription)")
                    } else {
                        self.sendingLocalVideo = true

                        // Convert `previewView` to a format Flutter can use
                        if let previewView = self.previewView {
                            let viewId = String(previewView.hash) // Generate a reference ID
                            result(viewId)
                        } else {
                            result("Error____ Preview view is nil")
                        }
                    }
                }
            } catch {
                // Return an error message if video renderer initialization fails
                result("Error____ Error initializing video renderer: \(error.localizedDescription)")
            }
        }
    }

}
