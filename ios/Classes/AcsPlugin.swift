import Flutter
import UIKit
import AzureCommunicationCalling

public class AcsPlugin: NSObject, FlutterPlugin {
    private var callService: CallService?
    
    public static var shared: AcsPlugin = AcsPlugin()
    
    public var previewView: RendererView? {
        return callService?.previewView
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "acs_plugin", binaryMessenger: registrar.messenger())
        let instance = AcsPlugin.shared
        registrar.addMethodCallDelegate(instance, channel: channel)

        let factory = AcsVideoViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "acs_video_view")
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            
        case "initializeCall":
            if let arguments = call.arguments as? [String: Any], let token = arguments["token"] as? String {
                initializeCall(token: token, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token is required", details: nil))
            }
            
        case "joinRoom":
            if let arguments = call.arguments as? [String: Any], let roomId = arguments["roomId"] as? String {
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
            toggleLocalVideo(result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func initializeCall(token: String, result: @escaping FlutterResult) {
        AVAudioSession.sharedInstance().requestRecordPermission { (granted) in
            if granted {
                AVCaptureDevice.requestAccess(for: .video) { (videoGranted) in /* NOOP */ }
            }
        }
        
        self.callService = CallService.getOrCreateInstance()
        
        if !self.callService!.initialized {
            self.callService?.initializeCall(token: token, result: result)
        }
        
        result("Call Initialized")
    }
    
    private func startCall(roomId: String, result: @escaping FlutterResult) {
        self.callService?.joinRoomCall(roomId: roomId, result: result)
    }
    
    private func leaveRoomCall(result: @escaping FlutterResult) {
        self.callService?.leaveRoomCall(result: result)
    }
    
    private func toggleMute(result: @escaping FlutterResult) {
        self.callService?.toggleMute(result: result)
    }
    
    private func toggleSpeaker(result: @escaping FlutterResult) {
        self.callService?.toggleSpeaker(result: result)
    }
    
    private func toggleLocalVideo(result: @escaping FlutterResult) {
        self.callService?.toggleLocalVideo(result: result)
    }
}
