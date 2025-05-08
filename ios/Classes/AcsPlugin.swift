import Flutter
import ReplayKit
import UIKit
import AzureCommunicationCalling
import AzureCommunicationCommon

import UIKit
import SwiftUI
import FluentUI
import AVKit
import Combine
import PushKit

class GlobalCompositeManager {
    static var callComposite: CallComposite?
}

public struct UserData {
    let token: String
    let name: String
    let userId: String
}

private enum Constants {
    enum Broadcast {
        static let appGroupIdentifier = "group.acsPluginExample"
        static let socketName = "socet.rtc_SSFD"
        static let extensionBubdleId = "com.example.acsPluginExample.ScreenBroadcast"
    }
    
    enum FlutterEvents {
        static let onStopScreenShare = "onStopScreenShare"
        static let onStartScreenShare = "onStartScreenShare"
        static let onShowChat = "onShowChat"
        static let onCallUIClosed = "onCallUIClosed"
    }
    
    enum CustomFonts {
        static let circularStdBold = "CircularStd-Bold"
        static let circularStdBook = "CircularStd-Book"
        static let circularStdMedium = "CircularStd-Medium"
    }
    
    enum MethodChannels {
        static let getPlatformVersion = "getPlatformVersion"
        static let requestMicrophonePermissions = "requestMicrophonePermissions"
        static let requestCameraPermissions = "requestCameraPermissions"
        static let returnToCall = "returnToCall"
        static let initializeRoomCall = "initializeRoomCall"
        static let startOneOnOneCall = "startOneOnOneCall"
        static let setUserData = "setUserData"
    }
}

public class AcsPlugin: NSObject, FlutterPlugin, PKPushRegistryDelegate {
    
    private var callService: CallService {
        return CallService.getOrCreateInstance()
    }
    
    private var client: Client!
    private var pushRegistry: PKPushRegistry?
    private var voipToken: Data?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    
    public static var shared: AcsPlugin = AcsPlugin()
    
    private var isRealDevice: Bool {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }
    
    public var userData: UserData? {
        didSet {
            guard let userData else { return }
            
            AcsPlugin.shared.getCallComposite(token: userData.token, userId: userData.userId)?.registerPushNotifications(deviceRegistrationToken: voipToken ?? Data()) { result in
                switch result {
                case .success:
                    print("Successfully registered for VoIP push notifications.")
                case .failure(let error):
                    print("Failed to register for VoIP push notifications: \(error)")
                }
            }
        }
    }
    
    public var previewView: RendererView? {
        return callService.previewView
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "acs_plugin", binaryMessenger: registrar.messenger())
        let instance = AcsPlugin.shared
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        registerCustomFont(withName: Constants.CustomFonts.circularStdBold)
        registerCustomFont(withName: Constants.CustomFonts.circularStdBook)
        registerCustomFont(withName: Constants.CustomFonts.circularStdMedium)
        
        // Add event channel setup
        let eventChannel = FlutterEventChannel(name: "acs_plugin_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        instance.eventChannel = eventChannel
        
        let factory = AcsVideoViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "acs_video_view")
        
        shared.setupPushKit()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case Constants.MethodChannels.getPlatformVersion:
            result("iOS " + UIDevice.current.systemVersion)
            
        case Constants.MethodChannels.requestMicrophonePermissions:
            requestMicrophonePermissions(result: result)
            
        case Constants.MethodChannels.requestCameraPermissions:
            requestCameraPermissions(result: result)
            
        case Constants.MethodChannels.returnToCall:
            returnToCall()
            
        case Constants.MethodChannels.initializeRoomCall:
            if let arguments = call.arguments as? [String: Any],
               let token = arguments["token"] as? String,
               let roomId = arguments["roomId"] as? String,
               let userId = arguments["userId"] as? String,
               let isChatEnable = arguments["isChatEnable"] as? Bool
            {
                initializeRoomCall(token: token, roomId: roomId, userId: userId, isChatEnable: isChatEnable, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token and roomId are required", details: nil))
            }
            
        case Constants.MethodChannels.startOneOnOneCall:
            if let arguments = call.arguments as? [String: Any],
               let token = arguments["token"] as? String,
               let participantId = arguments["participantId"] as? String,
               let userId = arguments["userId"] as? String
            {
                startOneOnOneCall(token: token, participantId: participantId, userId: userId, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, participantId and userId are required", details: nil))
            }
            
        case Constants.MethodChannels.setUserData:
            if let arguments = call.arguments as? [String: Any],
               let token = arguments["token"] as? String,
               let name = arguments["name"] as? String,
               let userId = arguments["userId"] as? String
            {
                self.userData = UserData(token: token, name: name, userId: userId)
                
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, name and userId are required", details: nil))
            }
            
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
    
    private func initializeRoomCall(token: String, roomId: String, userId: String, isChatEnable: Bool, result: @escaping FlutterResult) {
        let localOptions = LocalOptions(cameraOn: true, isChatEnable: isChatEnable, microphoneOn: true)
        
        getCallComposite(token: token, userId: userId)?.launch(locator: .roomCall(roomId: roomId), localOptions: localOptions)
        
        //        callComposite.launch(locator: .teamsMeeting(teamsLink: "https://teams.microsoft.com/l/meetup-join/19:meeting_NWM5YjYyYWUtNWNjYy00YjRhLWIwYWItYjg3YzkxOTMyZmEw@thread.v2/0?context=%7B%22Tid%22:%2241d68bdf-c355-4709-9c3f-40e323196d74%22,%22Oid%22:%2285555719-0dd7-410b-8f00-fa039800f874%22%7D"), localOptions: localOptions)
        
        //                callComposite.launch(locator: .teamsMeeting(teamsLink: "https://teams.microsoft.com/l/meetup-join/19%3ameeting_YWE4NzBkZTEtOGYzZC00ZWYyLWIzMTItYTc0ODgwODQ1ODk3%40thread.v2/0?context=%7b%22Tid%22%3a%22e16f27b3-237b-4547-9aa2-7f2dc7fc9aaf%22%2c%22Oid%22%3a%22843c6f37-5ffc-48e0-9d01-e8e5126b4f6f%22%7d"), localOptions: localOptions)
        
        
    }
    
    private func startOneOnOneCall(token: String, participantId: String, userId: String, result: @escaping FlutterResult) {
        let localOptions = LocalOptions(cameraOn: true, microphoneOn: true)
        
        getCallComposite(token: token, userId: userId)?.launch(
            participants: [CommunicationUserIdentifier(participantId)],
            localOptions: localOptions
        )
    }
    
    private func getCallComposite(token: String, userId: String) ->  CallComposite? {
        guard let credential = try? CommunicationTokenCredential(token: token) else { return nil }
        
        let callCompositeOptions = CallCompositeOptions(
            enableMultitasking: true,
            enableSystemPictureInPictureWhenMultitasking: true,
            callKitOptions: isRealDevice ? CallKitOptions() : nil,
            displayName: userData?.name,
            userId: CommunicationUserIdentifier(userId)
        )
        
        let callComposite = GlobalCompositeManager.callComposite != nil ?  GlobalCompositeManager.callComposite! : CallComposite(credential: credential, withOptions: callCompositeOptions)
        
        if (GlobalCompositeManager.callComposite == nil) {
            subscribeToEvents(callComposite: callComposite)
        }
        
        GlobalCompositeManager.callComposite = callComposite
        
        return callComposite
    }
    
    private func returnToCall() {
        guard let userData else { return }
        
        let callComposit = getCallComposite(token: userData.token, userId: userData.userId)
        callComposit?.isHidden = false
    }
    
    private func setupPushKit() {
        let registry = PKPushRegistry(queue: .main)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        self.pushRegistry = registry
    }
    
    private func subscribeToEvents(callComposite: CallComposite) {
        let localOptions = LocalOptions(cameraOn: true, microphoneOn: true)
        
        let callKitCallAccepted: (String) -> Void = { [weak callComposite] callId in
            callComposite?.launch(callIdAcceptedFromCallKit: callId, localOptions: localOptions)
        }
        
        callComposite.events.onIncomingCallAcceptedFromCallKit = callKitCallAccepted
        
        let showChatEvent: () -> Void = { [weak self] in
            self?.sendEvent(Constants.FlutterEvents.onShowChat)
        }
        
        callComposite.events.onShowUserChat = showChatEvent
        
        let callCompositDismissed: ((CallCompositeDismissed) -> Void)? = { [weak self] _ in
            self?.sendEvent(Constants.FlutterEvents.onCallUIClosed)
        }
        
        callComposite.events.onDismissed = callCompositDismissed
                
        let onStartScreenSharing: () -> Void = { [weak self] in
            self?.startBroadcastSession()
        }
        
        callComposite.events.onStartScreenSharing = onStartScreenSharing
        
        let onStopScreenSharing: () -> Void = { [weak self] in
            self?.stopBroadcastSession()
        }
        
        callComposite.events.onStopScreenSharing = onStopScreenSharing
        
    }
    
    //    private func getCallKitOptions() -> CallKitOptions {
    //        let cxHandle = CXHandle(type: .generic, value: "Outgoing call")
    //        let providerConfig = CXProviderConfiguration()
    //        providerConfig.supportsVideo = true
    //        providerConfig.maximumCallGroups = 1
    //        providerConfig.maximumCallsPerCallGroup = 1
    //        providerConfig.includesCallsInRecents = true
    //        providerConfig.supportedHandleTypes = [.phoneNumber, .generic]
    //        let isCallHoldSupported = true
    //        let callKitOptions = CallKitOptions(providerConfig: providerConfig,
    //                                           isCallHoldSupported: isCallHoldSupported,
    //                                           provideRemoteInfo: incomingCallRemoteInfo,
    //                                           configureAudioSession: configureAudioSession)
    //        return callKitOptions
    //    }
    //
    //    public func incomingCallRemoteInfo(info: Caller) -> CallKitRemoteInfo {
    //        let cxHandle = CXHandle(type: .generic, value: "Incoming call")
    //        var remoteInfoDisplayName = "Test display name"
    //        if remoteInfoDisplayName.isEmpty {
    //            remoteInfoDisplayName = info.displayName
    //        }
    //        let callKitRemoteInfo = CallKitRemoteInfo(displayName: remoteInfoDisplayName,
    //                                                               handle: cxHandle)
    //        return callKitRemoteInfo
    //    }
    //
    //    public func configureAudioSession() -> Error? {
    //        let audioSession = AVAudioSession.sharedInstance()
    //        var configError: Error?
    //
    //        // Check the current audio output route
    //        let currentRoute = audioSession.currentRoute
    //        let isUsingSpeaker = currentRoute.outputs.contains { $0.portType == .builtInSpeaker }
    //        let isUsingReceiver = currentRoute.outputs.contains { $0.portType == .builtInReceiver }
    //
    //        // Only configure the session if necessary (e.g., when not on speaker/receiver)
    //        if !isUsingSpeaker && !isUsingReceiver {
    //            do {
    //                // Keeping default .playAndRecord without forcing speaker
    //                try audioSession.setCategory(.playAndRecord, options: [.allowBluetooth])
    //                try audioSession.setActive(true)
    //            } catch {
    //                configError = error
    //            }
    //        }
    //
    //        return configError
    //    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if type == .voIP {
            self.voipToken = pushCredentials.token
            let tokenString = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
            print("Received VoIP token: \(tokenString)")
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry,
                             didReceiveIncomingPushWith payload: PKPushPayload,
                             for type: PKPushType,
                             completion: @escaping () -> Void) {
        print("pushRegistry payload: \(payload.dictionaryPayload)")
        //        os_log("pushRegistry payload: \(payload.dictionaryPayload)")
        //        if isAppInForeground() {
        //            os_log("calling demo app: app is in foreground")
        //            if let entryViewController = findEntryViewController() {
        //                os_log("calling demo app: onPushNotificationReceived")
        //                entryViewController.onPushNotificationReceived(dictionaryPayload: payload.dictionaryPayload)
        //            }
        //        } else {
        //            os_log("calling demo app: app is not in foreground")
        //            let pushInfo = PushNotification(data: payload.dictionaryPayload)
        //            let providerConfig = CXProviderConfiguration()
        //            providerConfig.supportsVideo = true
        //            providerConfig.maximumCallGroups = 1
        //            providerConfig.maximumCallsPerCallGroup = 1
        //            providerConfig.includesCallsInRecents = true
        //            providerConfig.supportedHandleTypes = [.phoneNumber, .generic]
        //            let callKitOptions = CallKitOptions(providerConfig: providerConfig,
        //                                                isCallHoldSupported: true,
        //                                                provideRemoteInfo: incomingCallRemoteInfo,
        //                                                configureAudioSession: configureAudioSession)
        //            CallComposite.reportIncomingCall(pushNotification: pushInfo,
        //                                             callKitOptions: callKitOptions) { result in
        //                if case .success = result {
        //                    DispatchQueue.global().async {
        //                        if let entryViewController = self.findEntryViewController() {
        //                            os_log("calling demo app: onPushNotificationReceivedBackgroundMode")
        //                            entryViewController.onPushNotificationReceivedBackgroundMode(
        //                                dictionaryPayload: payload.dictionaryPayload)
        //                        }
        //                    }
        //                } else {
        //                    os_log("calling demo app: failed on reportIncomingCall")
        //                }
        //            }
        //        }
    }
    
    // MARK: - Broadcasting
    
    private func startBroadcastSession() {
        DispatchQueue.main.async {
            let pickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            let extensionId = Bundle.main.object(forInfoDictionaryKey: Constants.Broadcast.extensionBubdleId) as? String
            pickerView.showsMicrophoneButton = false
            pickerView.preferredExtension = extensionId
            (pickerView.subviews.first as? UIButton)?.sendActions(for: .touchUpInside)
        }
    }
    
    private func stopBroadcastSession() {
        DarwinNotificationCenter.shared.postNotification(.stopBroadcast)
    }
    
    private func startListenBroadcastEvents() {
        DarwinNotificationCenter.shared.subscribe(.startBroadcast, observer: self) { [weak self] in
            guard let self = self else { return }
            
            self.sendEvent(Constants.FlutterEvents.onStartScreenShare)
            
            self.client = Client(appGroup: Constants.Broadcast.appGroupIdentifier, socketName: Constants.Broadcast.socketName)
            self.client.connect()
            self.listenBufferData()
            
            guard let userData = self.userData else { return }
            Task {
                await self.getCallComposite(token: userData.token, userId: userData.userId)?.startScreenSharing()
            }
        }
        
        DarwinNotificationCenter.shared.subscribe(.stopBroadcast, observer: self) { [weak self] in
            guard let self = self else { return }
            
            self.client.stop()
            self.sendEvent(Constants.FlutterEvents.onStopScreenShare)
            
            guard let userData = self.userData else { return }
            Task {
                await self.getCallComposite(token: userData.token, userId: userData.userId)?.stopScreenSharing()
            }
        }
    }
}

extension AcsPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        
        startListenBroadcastEvents()
        
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
    
    public func sendEvent(_ event: String) {
        guard let eventSink = eventSink else { return }
        
        let eventData: [String: Any?] = [
            "event": event,
        ]
        eventSink(eventData)
    }
    
    public func listenBufferData() {
        client.onBufferReceived = { [weak self] data in
            print("Received buffer data")
            
            guard let userData = self?.userData, let buffer = data  else {
                return
            }
            
            self?.getCallComposite(token: userData.token, userId: userData.userId)?.sendVideoBuffer(sampleBuffer: buffer)
        }
    }
}


extension AcsPlugin {
    private static func registerCustomFont(withName name: String, fileExtension: String = "ttf") {
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
