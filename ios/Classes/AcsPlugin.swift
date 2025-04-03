import Flutter
import UIKit
import AzureCommunicationCalling

public class AcsPlugin: NSObject, FlutterPlugin {
    
    private var callService: CallService {
        return CallService.getOrCreateInstance()
    }
    
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    public static var shared: AcsPlugin = AcsPlugin()
    
    public var previewView: RendererView? {
        return callService.previewView
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "acs_plugin", binaryMessenger: registrar.messenger())
        let instance = AcsPlugin.shared
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Add event channel setup
        let eventChannel = FlutterEventChannel(name: "acs_plugin_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        instance.eventChannel = eventChannel
        
        let factory = AcsVideoViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "acs_video_view")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            
        case "requestMicrophonePermissions":
            requestMicrophonePermissions(result: result)
            
        case "requestCameraPermissions":
            requestCameraPermissions(result: result)
            
        case "initializeCall":
            if let arguments = call.arguments as? [String: Any], let token = arguments["token"] as? String {
                initializeCall(token: token, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token is required", details: nil))
            }
            
        case "joinRoom":
            if let arguments = call.arguments as? [String: Any], let roomId = arguments["room_id"] as? String {
                startCall(roomId: roomId, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "RoomId is required", details: nil))
            }
        case "leaveRoomCall":
            leaveRoomCall(result: result)
        case "toggleMute":
            toggleMute(result: result)
        case "toggleSpeaker":
            toggleSpeaker(result: result)
        case "toggleLocalVideo":
            toggleLocalVideo()
        case "toggleParticipantVideo":
            if let arguments = call.arguments as? [String: Any], let participantId = arguments["participant_id"] as? String {
                toggleParticipantVideo(participantId: participantId, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "RoomId is required", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func getParticipantView(for participantId: String) -> UIView? {
        return callService.participants.first(where: {$0.getMri() == participantId})?.rendererView
    }
    
    public func updateParticipant(_ newParticipant: Participant) {
        if let index = callService.participants.firstIndex(where: { $0.getMri() == newParticipant.getMri() }) {
            callService.participants[index] = newParticipant
            sendParticipantList()
        } else {
            print("Participant not found in the list.")
        }
    }
    
    private func toggleParticipantVideo(participantId: String, result: @escaping FlutterResult) {
        if let index = callService.participants.firstIndex(where: { $0.getMri() == participantId }) {
            callService.participants[index].toggleVideo(result: result)
        } else {
            result(FlutterError(code: "PARTICIPANT_ERROR", message: "Participant not found in the list", details: nil))
        }
    }
    
    private func requestMicrophonePermissions(result: @escaping FlutterResult) {
        callService.requestMicrophonePermissions(result: result)
    }
    
    private func requestCameraPermissions(result: @escaping FlutterResult) {
        callService.requestCameraPermissions(result: result)
    }
    
    private func initializeCall(token: String, result: @escaping FlutterResult) {
        if !callService.initialized {
            callService.initializeCall(token: token, result: result)
        } else {
            result("Call Already Initialized")
        }
    }
    
    private func startCall(roomId: String, result: @escaping FlutterResult) {
        if !callService.initialized {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        callService.joinRoomCall(roomId: roomId, result: result)
    }
    
    private func leaveRoomCall(result: @escaping FlutterResult) {
        if !callService.initialized {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        callService.leaveRoomCall(result: result)
    }
    
    private func toggleMute(result: @escaping FlutterResult) {
        callService.toggleMute(result: result)
    }
    
    private func toggleSpeaker(result: @escaping FlutterResult) {
        callService.toggleSpeaker(result: result)
    }
    
    private func toggleLocalVideo() {
        callService.toggleLocalVideo()
    }
}

extension AcsPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    // Method to send viewId to Flutter
    public func sendViewId(_ viewId: String?) {
        guard let eventSink = eventSink else { return }
        
        let eventData: [String: Any?] = [
            "event": "preview",
            "viewId": viewId
        ]
        
        eventSink(eventData)
    }
    
    // Send the participant list to Flutter
    public func sendParticipantList() {
        guard let eventSink = eventSink else { return }
        
        let participantsData = callService.participants.map { $0.toMap() }
        
        let eventData: [String: Any?] = [
            "event": "participant_list",
            "participants": participantsData
        ]
        eventSink(eventData)
    }
    
    public func sendError(_ error: FlutterError) {
        if let eventSink = eventSink {
            eventSink(error)
        }
    }
}
