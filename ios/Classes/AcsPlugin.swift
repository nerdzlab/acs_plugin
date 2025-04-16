import Flutter
import UIKit
import AzureCommunicationCalling

import UIKit
import SwiftUI
import FluentUI
import AVKit
import Combine

class GlobalCompositeManager {
    static var callComposite: CallComposite?
}

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
        
        registerCustomFont(withName: "CircularStd-Bold")
        registerCustomFont(withName: "CircularStd-Book")
        registerCustomFont(withName: "CircularStd-Medium")
        
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
            
        case "initializeRoomCall":
            if let arguments = call.arguments as? [String: Any], let token = arguments["token"] as? String, let roomId = arguments["roomId"] as? String {
                initializeRoomCall(token: token, roomId: roomId, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token and roomId are required", details: nil))
            }
            
        case "leaveRoomCall":
            leaveRoomCall(result: result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func requestMicrophonePermissions(result: @escaping FlutterResult) {
        callService.requestMicrophonePermissions(result: result)
    }
    
    private func requestCameraPermissions(result: @escaping FlutterResult) {
        callService.requestCameraPermissions(result: result)
    }
    
    private func initializeRoomCall(token: String, roomId: String, result: @escaping FlutterResult) {
        guard let credential = try? CommunicationTokenCredential(token: token) else { return  }
        
        let callCompositeOptions = CallCompositeOptions(
            enableMultitasking: true,
            enableSystemPictureInPictureWhenMultitasking: true,
            displayName: "Yra")
        
        let callComposite = GlobalCompositeManager.callComposite != nil ?  GlobalCompositeManager.callComposite! : CallComposite(credential: credential, withOptions: callCompositeOptions)
        
        
        
        let customButton = CustomButtonViewData(id: UUID().uuidString,
                                                image: UIImage(),
                                                title: "Hide composite") {_ in
            // hide call composite and display Troubleshooting tips
            callComposite.isHidden = true
            // ...
        }
        
        let cameraButton = ButtonViewData(visible: true)
        let micButton = ButtonViewData(enabled: true)
        
        let callScreenControlBarOptions = CallScreenControlBarOptions(
            cameraButton: cameraButton,
            microphoneButton: micButton,
            customButtons: [customButton]
        )
        
        let callScreenOptions = CallScreenOptions(controlBarOptions: callScreenControlBarOptions)
        let localOptions = LocalOptions(cameraOn: true, microphoneOn: true, callScreenOptions: callScreenOptions)
        
        GlobalCompositeManager.callComposite = callComposite

        
                callComposite.launch(locator: .roomCall(roomId: roomId), localOptions: localOptions)
//        callComposite.launch(locator: .teamsMeeting(teamsLink: "https://teams.live.com/meet/933457426728?p=lVHQKf4g7JBBpW0zcH"), localOptions: localOptions)
        
        
    }
    
    private func leaveRoomCall(result: @escaping FlutterResult) {
        if !callService.initialized {
            result(FlutterError(code: "Azur error", message: "Azur is not initialized", details: nil))
            return
        }
        
        callService.leaveRoomCall(result: result)
    }
    
    private static func registerCustomFont(withName name: String, fileExtension: String = "ttf") {
        // Use the correct bundle (Flutter plugin bundle)
        
        let bundle = Bundle(for: Self.self) // Use the current class for plugin context
        
        guard let fontPath = bundle.path(forResource: name, ofType: "ttf"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: fontPath)),
              let provider = CGDataProvider(data: data as CFData),
              let font = CGFont(provider) else {
            print("❌ Could not load font '\(name)' from bundle.")
            return
        }
        
        var error: Unmanaged<CFError>?
        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        
        if !success {
            if let cfError = error?.takeUnretainedValue() {
                print("❌ Failed to register font '\(name)': \(cfError.localizedDescription)")
            } else {
                print("❌ Failed to register font '\(name)': Unknown error.")
            }
            return
        }
        
        print("✅ Successfully registered font '\(name)'")
        return
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
    
    public func sendError(_ error: FlutterError) {
        if let eventSink = eventSink {
            eventSink(error)
        }
    }
}
