import Flutter
import ReplayKit
import UIKit
import AzureCommunicationCalling
import AzureCommunicationCommon
import SwiftUI
import FluentUI
import AVKit
import Combine
import PushKit

class GlobalCompositeManager {
    static var callComposite: CallComposite?
}

public class AcsPlugin: NSObject, FlutterPlugin, PKPushRegistryDelegate {
    
    public static var shared: AcsPlugin = AcsPlugin()
    
    private var pushRegistry: PKPushRegistry?
    private var voipToken: Data?
    private var eventChannel: FlutterEventChannel?
    private var eventSink: FlutterEventSink?
    private var callHandler: CallHandler!
    private var broadcastExtensionHandler: BroadcastExtensionHandler!
    private var userDataHandler: UserDataHandler!
    private var handlers: [MethodHandler] = []
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "acs_plugin", binaryMessenger: registrar.messenger())
        let instance = AcsPlugin.shared
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        Utility.registerAllCustomFonts()
        
        // Add event channel setup
        let eventChannel = FlutterEventChannel(name: "acs_plugin_events", binaryMessenger: registrar.messenger())
        eventChannel.setStreamHandler(instance)
        instance.eventChannel = eventChannel
        
        instance.setupHandlers(channel: channel)
        
        shared.setupPushKit()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        for handler in handlers {
            if handler.handle(call: call, result: result) {
                return
            }
        }
        
        result(FlutterMethodNotImplemented)
    }
    
    private func setupHandlers(channel: FlutterMethodChannel) {
        callHandler = CallHandler(
            channel: channel,
            onGetllComposite: { [weak self] in
                self?.userDataHandler.getCallComposite()
            },
            onSendEvent: { [weak self] event in
                self?.sendEvent(event)
            }
        )
        
        broadcastExtensionHandler = BroadcastExtensionHandler(
            channel: channel,
            onGetllComposite: { [weak self] in
                self?.userDataHandler.getCallComposite()
            },
            onSendEvent: { [weak self] event in
                self?.sendEvent(event)
            }
        )
        
        userDataHandler = UserDataHandler(
            channel: channel,
            onSubscribeToCallCompositeEvents: { [weak self] callComposite in
                self?.callHandler.subscribeToEvents(callComposite: callComposite)
                self?.broadcastExtensionHandler.subscribeToEvents(callComposite: callComposite)
            },
            onUserDataReceived: { [weak self] userData in
                self?.userDataHandler?.getCallComposite()?.registerPushNotifications(deviceRegistrationToken: self?.voipToken ?? Data()) { result in
                    switch result {
                    case .success:
                        print("Successfully registered for VoIP push notifications.")
                    case .failure(let error):
                        print("Failed to register for VoIP push notifications: \(error)")
                    }
                }
            }
        )
        
        handlers = [callHandler, userDataHandler, broadcastExtensionHandler]
    }
    
    private func setupPushKit() {
        let registry = PKPushRegistry(queue: .main)
        registry.delegate = self
        registry.desiredPushTypes = [.voIP]
        self.pushRegistry = registry
    }
    
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
    
    public func sendEvent(_ event: String) {
        guard let eventSink = eventSink else { return }
        
        let eventData: [String: Any?] = [
            "event": event,
        ]
        eventSink(eventData)
    }
}
