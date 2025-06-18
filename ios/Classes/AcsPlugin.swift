import Flutter
import AzureCommunicationChat
import ReplayKit
import UIKit
import AzureCommunicationCalling
import AzureCommunicationCommon
import SwiftUI
import FluentUI
import AVKit
import Combine
import PushKit
import AzureCore
import os

class GlobalCompositeManager {
    static var callComposite: CallComposite?
}

public struct Event {
    let name: String
    let payload: Any?
    
    init(name: String, payload: Any? = nil) {
        self.name = name
        self.payload = payload
    }
    
    func toMap() -> [String: Any] {
        var map: [String: Any] = ["event": name]
        if let payload = payload {
            map["payload"] = payload
        }
        return map
    }
}

public class AcsPlugin: NSObject, FlutterPlugin, PKPushRegistryDelegate {
    
    private enum Constants {
        enum MethodChannels {
            static let getPreloadedAction = "getPreloadedAction"
        }
    }
    
    public static var shared: AcsPlugin = AcsPlugin()
    private var voipRegistry: PKPushRegistry = PKPushRegistry(
        queue: DispatchQueue.main
    )
    
    private lazy var userDataHandler: UserDataHandler = UserDataHandler(
        onSubscribeToCallCompositeEvents: { [weak self] callComposite in
            self?.callHandler?.subscribeToEvents(callComposite: callComposite)
            self?.broadcastExtensionHandler?.subscribeToEvents(callComposite: callComposite)
        },
        onUserDataReceived: { [weak self] userData in
            self?.userDataHandler.getCallComposite()?.registerPushNotifications(deviceRegistrationToken: self?.voipToken ?? Data()) { result in
                switch result {
                case .success:
                    self?.logger.debug { "Successfully registered for VoIP push notifications." }
                    
                case .failure(let error):
                    self?.logger.debug { "Failed to register for VoIP push notifications: \(error)" }
                }
            }
        }
    )
    
    private var voipToken: Data?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var callHandler: CallHandler?
    private var broadcastExtensionHandler: BroadcastExtensionHandler?
    private var chatHandler: ChatHandler?
    private var handlers: [MethodHandler?] = []
    private var preloadedAction: PreloadedAction?
    private let logger = DefaultLogger(category: "AcsPlugin")
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "acs_plugin", binaryMessenger: registrar.messenger())
        let instance = AcsPlugin.shared
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        Utility.registerAllCustomFonts()
        
        // Add event channel setup
        let eventChannel = FlutterEventChannel(name: "acs_plugin_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        instance.eventChannel = eventChannel
        
        instance.setupHandlers()
        instance.setupPushKit()
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        if call.method == Constants.MethodChannels.getPreloadedAction {
            getPreloadedAction(result: result)
            return
        }
        
        for handler in handlers {
            if ((handler?.handle(call: call, result: result)) == true) {
                return
            }
        }
        
        result(FlutterMethodNotImplemented)
    }
    
    private func setupHandlers() {
        callHandler = CallHandler(
            onGetllComposite: { [weak self] in
                self?.userDataHandler.getCallComposite()
            },
            onSendEvent: { [weak self] event in
                self?.sendEvent(event)
            }
        )
        
        broadcastExtensionHandler = BroadcastExtensionHandler(
            onGetllComposite: { [weak self] in
                self?.userDataHandler.getCallComposite()
            },
            onSendEvent: { [weak self] event in
                self?.sendEvent(event)
            }
        )
                
        chatHandler = ChatHandler(
            onGetUserData: { [weak self] in
                self?.userDataHandler.getUserData()
            },
            onSendEvent: { [weak self] event in
                self?.sendEvent(event)
            },
            tokenRefresher: userDataHandler.tokenRefresher
        )
        
        handlers = [callHandler, userDataHandler, broadcastExtensionHandler, chatHandler]
        
        subscirbeToComposite()
    }
    
    private func subscirbeToComposite() {
        guard let composite = userDataHandler.getCallComposite() else {
            return
        }
        
        broadcastExtensionHandler?.subscribeToEvents(callComposite: composite)
        callHandler?.subscribeToEvents(callComposite: composite)
    }
    
    private func setupPushKit() {
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate pushCredentials: PKPushCredentials, for type: PKPushType) {
        if type == .voIP {
            self.voipToken = pushCredentials.token
            let tokenString = pushCredentials.token.map { String(format: "%02x", $0) }.joined()
            logger.debug { "Received VoIP token: \(tokenString)" }
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry,
                             didReceiveIncomingPushWith payload: PKPushPayload,
                             for type: PKPushType,
                             completion: @escaping () -> Void) {
        logger.debug { "pushRegistry payload: \(payload.dictionaryPayload)" }
        if isAppInForeground() {
            logger.debug { "calling demo app: app is in foreground" }
            let pushNotificationInfo = PushNotification(data: payload.dictionaryPayload)
            userDataHandler.getCallComposite()?.handlePushNotification(pushNotification: pushNotificationInfo)
            logger.debug { "callId---------------------\(pushNotificationInfo.callId)" }
        }
        else {
            logger.debug { "calling demo app: app is not in foreground" }
            
            let pushInfo = PushNotification(data: payload.dictionaryPayload)
            os_log("callId---------------------\(pushInfo.callId)")
            
            let providerConfig = CXProviderConfiguration()
            providerConfig.supportsVideo = true
            providerConfig.maximumCallGroups = 2
            providerConfig.includesCallsInRecents = false
            providerConfig.supportedHandleTypes = [.phoneNumber, .generic]
            
            let appGroup = UserDefaults.standard.getAppGroupIdentifier() ?? "group.superbrain"
            let languageCode = UserDefaults(suiteName: appGroup)?.getLanguageCode() ?? "nl"
            
            //Localization
            let provider = LocalizationProvider(logger: DefaultLogger(category: "Calling"))
            let localizationOptions = LocalizationOptions(locale: Locale.resolveLocale(from: languageCode))
            provider.apply(localeConfig: localizationOptions)
            
            let callKitOptions = CallKitOptions(
                providerConfig: providerConfig,
                isCallHoldSupported: true,
                provideRemoteInfo: incomingCallRemoteInfo,
                configureAudioSession: configureAudioSession
            )
            
            CallComposite.reportIncomingCall(pushNotification: pushInfo, callKitOptions: callKitOptions) { [weak self] result in
                guard let self else {
                    completion()
                    return
                }
                
                if case .success = result {
                    if self.handlers.isEmpty {
                        self.setupHandlers()
                    }

                    DispatchQueue.global().async {
                        guard let callCamposite = self.userDataHandler.getCallComposite() else {
                            completion()
                            return
                        }
                        
                        callCamposite.handlePushNotification(pushNotification: pushInfo) { _ in
                            completion()
                        }
                    }
                }
                else {
                    self.logger.debug { "calling demo app: failed on reportIncomingCall" }
                    completion()
                }
            }
        }
    }
    
    public func incomingCallRemoteInfo(info: Caller) -> CallKitRemoteInfo {
        let cxHandle = CXHandle(type: .generic, value: "Incoming call")
        var remoteInfoDisplayName = info.displayName
        
        if remoteInfoDisplayName.isEmpty {
            remoteInfoDisplayName = info.identifier.rawId
        }
        
        let callKitRemoteInfo = CallKitRemoteInfo(
            displayName: remoteInfoDisplayName,
            handle: cxHandle
        )
        return callKitRemoteInfo
    }
    
    public func configureAudioSession() -> Error? {
        let audioSession = AVAudioSession.sharedInstance()
        var configError: Error?

        do {
            // Keeping default .playAndRecord without forcing speaker
            try audioSession.setCategory(.playAndRecord, options: [.allowBluetooth])
            try? audioSession.setActive(true)
        }
        catch {
            configError = error
        }

        return configError
    }
        
    public func saveLaunchedChatNotification(pushNotificationReceivedEvent: PushNotificationChatMessageReceivedEvent) {
        preloadedAction = PreloadedAction(type: .chatNotification, chatPushNotificationReceivedEvent: pushNotificationReceivedEvent)
    }
    
    public func chatPushOpened(pushNotificationReceivedEvent: PushNotificationChatMessageReceivedEvent) {
        chatHandler?.chatPushNotificationOpened(pushNotificationReceivedEvent: pushNotificationReceivedEvent)
    }
    
    public func setAPNSData(apnsToken: String, appGroupId: String, completion: @escaping () -> Void) {
        //If app run from terminated state, chat handler does not create, as flutter part does not triggers
        if chatHandler != nil {
            chatHandler?.setAPNSData(apnsToken: apnsToken, appGroupId: appGroupId, completion: completion)
        }
        else {
            BackgroundChatManager.shared.renewPushSubscription(appGroupId: appGroupId, apnsToken: apnsToken, completion: completion)
        }
    }
    
    public func getPreloadedAction(result: @escaping FlutterResult) {
        result(preloadedAction?.toJson())
        // Remove preloaded actin after first return
        preloadedAction = nil
    }
    
    private func isAppInForeground() -> Bool {
        let appState = UIApplication.shared.applicationState
        
        switch appState {
        case .active:
            return true
            
        default:
            return false
        }
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
    
    public func sendEvent(_ event: Event) {
        DispatchQueue.main.async {
            guard let eventSink = self.eventSink else { return }
            eventSink(event.toMap())
        }
    }
}
