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
    
    /// Requests permission to access the microphone.
    /// - Parameter result: Callback to return success or error result.
    public func requestMicrophonePermissions(result: @escaping FlutterResult) {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                debugPrint("Success___ Microphone permission granted")
                result(true)
            } else {
                debugPrint("Error____ Microphone permission denied")
                result(false)
            }
        }
    }
    
    /// Requests permission to access the camera.
    /// - Parameter result: Callback to return success or error result.
    public func requestCameraPermissions(result: @escaping FlutterResult) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                debugPrint("Success___ Camera permission granted")
                result(true)
            } else {
                debugPrint("Error____ Camera permission denied")
                result(false)
            }
        }
    }
    
    /// Initializes the call service with the provided token.
    /// - Parameter token: Communication token for authentication.
    /// - Parameter result: Callback to return success or error result.
    public func initializeCall(token: String, result: @escaping FlutterResult) {
        // Check if already initialized
        if initialized {
            debugPrint("Success___ Already initialized")
            result(FlutterError(code: "CREDENTIAL_ERROR", message: "Already initialized", details: nil))
            
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
        if (call != nil) {
            debugPrint("Error____ You already have active call")
            result(FlutterError(code: "Error", message: "You already have active call", details: nil))
            return
        }
        
        if self.callAgent == nil {
            debugPrint("Error____ CallAgent not initialized")
            result(FlutterError(code: "Error", message: "CallAgent not initialized", details: nil))
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
                    result(FlutterError(code: "Error", message: "Failed to join the call: \(error.localizedDescription)", details: nil))
                    return
                }
                
                self?.setCallAndObserver(call: call, error: error)
                
                if (self?.sendingLocalVideo == true) {
                    self?.startLocalVideo(call: call)
                }
                
                debugPrint("Success___ Joined call successfully")
                result("Joined call successfully")
            }
        }
    }
    
    /// Leaves the current room call if active.
    /// - Parameter result: Callback to return the success or failure result.
    public func leaveRoomCall(result: @escaping FlutterResult) {
        if self.call != nil {
            // If video is currently being sent, stop it
            if (self.sendingLocalVideo) {
                self.call?.stopVideo(stream: self.localVideoStreams!.first!) { (error) in
                    if let error = error {
                        // Return an error message to Flutter if stopping video fails
                        debugPrint("Error___ Could not stop preview renderer: \(error.localizedDescription)")
                        AcsPlugin.shared.sendError(FlutterError(code: "PREVIEW_ERROR", message: "Could not stop video: \(error.localizedDescription)", details: nil))
                        
                    } else {
                        // Successfully stopped video
                        self.disposePreview()
                        debugPrint("Success___ video successfully stopped")
                    }
                }
            }
            
            self.call?.hangUp(options: nil) { (error) in }
            self.participants.removeAll()
            self.call?.delegate = nil
            self.call = nil
            debugPrint("Success___ Left the call successfully")
            result("Left the call successfully")
        } else {
            debugPrint("Error____ No active call to leave")
            result(FlutterError(code: "Error", message: "No active call to leave", details: nil))
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
    public func toggleLocalVideo() {
        if sendingLocalVideo {
            stopLocalVideo()
        } else {
            startLocalVideo(call: call)
        }
    }
    
    // MARK: - Private Methods
    
    /// Stops the local video stream
    private func stopLocalVideo() {
        guard let call = call else {
            disposePreview()
            debugPrint("Success___ Video successfully stopped")
            return
        }
        
        guard let stream = localVideoStreams?.first else {
            debugPrint("Error___ No local video stream found")
            AcsPlugin.shared.sendError(FlutterError(code: "PREVIEW_ERROR", message: "No local video stream found", details: nil))
            return
        }
        
        call.stopVideo(stream: stream) { error in
            if let error = error {
                debugPrint("Error___ Could not stop video: \(error.localizedDescription)")
                AcsPlugin.shared.sendError(FlutterError(code: "PREVIEW_ERROR", message: "Could not stop video: \(error.localizedDescription)", details: nil))
            } else {
                self.disposePreview()
                debugPrint("Success___ Video successfully stopped")
            }
        }
    }
    
    /// Starts the local video stream
    private func startLocalVideo(call: Call?) {
        guard let availableCameras = deviceManager?.cameras, let camera = availableCameras.first else {
            debugPrint("Error___ No available cameras found")
            AcsPlugin.shared.sendError(FlutterError(code: "PREVIEW_ERROR", message: "No available cameras found", details: nil))
            return
        }
        
        do {
            if (previewView == nil) {
                let localStream = LocalVideoStream(camera: camera)
                let renderer = try VideoStreamRenderer(localVideoStream: localStream)
                let view = try renderer.createView(withOptions: CreateViewOptions(scalingMode: .crop))
                
                self.localVideoStreams = [localStream]
                self.previewRenderer = renderer
                self.previewView = view
            }
            
            if let call = call {
                call.startVideo(stream: self.localVideoStreams!.first!) { error in
                    debugPrint("Success___ start video")
                    if let error = error {
                        debugPrint("Error___ Could not start video: \(error.localizedDescription)")
                        AcsPlugin.shared.sendError(FlutterError(code: "PREVIEW_ERROR", message: "Could not start video: \(error.localizedDescription)", details: nil))
                    } else {
                        self.sendingLocalVideo = true
                        self.returnPreviewView()
                    }
                }
            } else {
                self.sendingLocalVideo = true
                self.returnPreviewView()
            }
        } catch {
            debugPrint("Error___ Error initializing video renderer: \(error.localizedDescription)")
            AcsPlugin.shared.sendError(FlutterError(code: "PREVIEW_ERROR", message: "Error initializing video renderer: \(error.localizedDescription)", details: nil))
        }
    }
    
    /// Disposes of the preview renderer and resets the video state
    private func disposePreview() {
        sendingLocalVideo = false
        previewView = nil
        previewRenderer?.dispose()
        previewRenderer = nil
        
        AcsPlugin.shared.sendViewId(nil)
    }
    
    /// Returns the preview view ID to Flutter
    private func returnPreviewView() {
        if let previewView = previewView {
            let viewId = String(previewView.hash) // Generate a reference ID
            debugPrint("Success___ Preview view generated: \(viewId)")
            AcsPlugin.shared.sendViewId(viewId)
        } else {
            debugPrint("Error___ Preview view is nil")
            AcsPlugin.shared.sendViewId(nil)
        }
    }
    
    public func toggleLocalsVideo(result: @escaping FlutterResult) {
        if self.sendingLocalVideo && call == nil {
            // Successfully stopped video
            self.sendingLocalVideo = false
            self.previewView = nil
            self.previewRenderer?.dispose()
            self.previewRenderer = nil
            debugPrint("Success___ video successfully stopped")
            result(nil)
            
        } else if self.sendingLocalVideo && call != nil {
            // If video is currently being sent, stop it
            self.call!.stopVideo(stream: self.localVideoStreams!.first!) { (error) in
                if let error = error {
                    // Return an error message to Flutter if stopping video fails
                    debugPrint("Error___ Could not stop preview renderer: \(error.localizedDescription)")
                    result(FlutterError(code: "Error", message: "Could not stop preview renderer: \(error.localizedDescription)", details: nil))
                } else {
                    // Successfully stopped video
                    self.sendingLocalVideo = false
                    self.previewView = nil
                    self.previewRenderer?.dispose()
                    self.previewRenderer = nil
                    debugPrint("Success___ video successfully stopped")
                    result(nil)
                }
            }
        } else {
            // Attempt to start sending video
            guard let availableCameras = self.deviceManager?.cameras, !availableCameras.isEmpty else {
                debugPrint("Error___ No available cameras found")
                result(FlutterError(code: "Error", message: "No available cameras found", details: nil))
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
                
                if call != nil {
                    // Start streaming the local video
                    self.call?.startVideo(stream: self.localVideoStreams!.first!) { error in
                        if let error = error {
                            // Return an error message if video streaming fails
                            debugPrint("Error____ Could not share video: \(error.localizedDescription)")
                            result(FlutterError(code: "Error", message: "Could not share video: \(error.localizedDescription)", details: nil))
                        } else {
                            self.sendingLocalVideo = true
                            
                            // Convert previewView to a format Flutter can use
                            if let previewView = self.previewView {
                                debugPrint("Success____ Preview view generated")
                                let viewId = String(previewView.hash) // Generate a reference ID
                                result(viewId)
                            } else {
                                debugPrint("Error____ Preview view is nil")
                                result(FlutterError(code: "Error", message: "Preview view is nil", details: nil))
                            }
                        }
                    }
                } else {
                    self.sendingLocalVideo = true
                    // Convert previewView to a format Flutter can use
                    if let previewView = self.previewView {
                        debugPrint("Success____ Preview view generated")
                        let viewId = String(previewView.hash) // Generate a reference ID
                        result(viewId)
                    } else {
                        debugPrint("Error____ Preview view is nil")
                        result(FlutterError(code: "Error", message: "Preview view is nil", details: nil))
                    }
                }
            } catch {
                // Return an error message if video renderer initialization fails
                debugPrint("Error____ Error initializing video renderer: \(error.localizedDescription)")
                result(FlutterError(code: "Error", message: "Error initializing video renderer: \(error.localizedDescription)", details: nil))
            }
        }
    }
}
