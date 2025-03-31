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
    
    private func requestMicrophonePermissions(result: @escaping FlutterResult) {
        self.callService = CallService.getOrCreateInstance()
        self.callService?.requestMicrophonePermissions(result: result)
    }
    
    private func requestCameraPermissions(result: @escaping FlutterResult) {
        self.callService = CallService.getOrCreateInstance()
        self.callService?.requestCameraPermissions(result: result)
    }
    
    private func initializeCall(token: String, result: @escaping FlutterResult) {
        // Check microphone permission
        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] (micGranted) in
            guard let self = self else {
                result(FlutterError(code: "SELF_NULL", message: "Self reference lost", details: nil))
                return
            }
            
            if !micGranted {
                debugPrint("Error____ Microphone permission denied")
                result(FlutterError(code: "MICROPHONE_PERMISSION_DENIED", message: "Microphone access is required", details: nil))
                return
            }
            
            // Check camera permission
            AVCaptureDevice.requestAccess(for: .video) { (cameraGranted) in
                if !cameraGranted {
                    debugPrint("Error____ Camera permission denied")
                    result(FlutterError(code: "CAMERA_PERMISSION_DENIED", message: "Camera access is required", details: nil))
                    return
                }
                
                // Proceed with call initialization if permissions are granted
                self.callService = CallService.getOrCreateInstance()
                
                if !self.callService!.initialized {
                    self.callService?.initializeCall(token: token, result: result)
                } else {
                    result("Call Already Initialized")
                }
            }
        }
    }
    
    private func startCall(roomId: String, result: @escaping FlutterResult) {
        if self.callService == nil {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        self.callService?.joinRoomCall(roomId: roomId, result: result)
    }
    
    private func leaveRoomCall(result: @escaping FlutterResult) {
        if self.callService == nil {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        self.callService?.leaveRoomCall(result: result)
    }
    
    private func toggleMute(result: @escaping FlutterResult) {
        if self.callService == nil {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        self.callService?.toggleMute(result: result)
    }
    
    private func toggleSpeaker(result: @escaping FlutterResult) {
        if self.callService == nil {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        self.callService?.toggleSpeaker(result: result)
    }
    
    private func toggleLocalVideo(result: @escaping FlutterResult) {
        if self.callService == nil {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        self.callService?.toggleLocalVideo(result: result)
    }
}
