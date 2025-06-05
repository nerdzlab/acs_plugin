//
//  CallManager.swift
//  Pods
//
//  Created by Yriy Malyts on 05.06.2025.
//

import AzureCommunicationCommon
import CallKit
import AVKit

final class CallManager {
    
//    private enum Constants {
//        enum FlutterEvents {
//            static let onShowChat = "onShowChat"
//            static let onCallUIClosed = "onCallUIClosed"
//            static let onPluginStarted = "onPluginStarted"
//            static let onUserCallEnded = "onUserCallEnded"
//            static let onOneOnOneCallEnded = "onOneOnOneCallEnded"
//        }
//    }
    
    static let shared = CallManager()
    
//    func getCallComposite(callKitOptions: CallKitOptions, onSendEvent: @escaping((Event) -> Void)) ->  CallComposite? {
//        guard
//            let userData = UserDefaults.standard.loadUserData(),
//            let credential = try? CommunicationTokenCredential(token: userData.token)
//        else {
//            return nil
//        }
//        
//        let callCompositeOptions = CallCompositeOptions(
//            localization: LocalizationOptions(locale: Locale.resolveLocale(from: userData.languageCode)),
//            enableMultitasking: true,
//            enableSystemPictureInPictureWhenMultitasking: true,
//            callKitOptions: callKitOptions,
//            displayName: userData.name,
//            userId: CommunicationUserIdentifier(userData.userId)
//        )
//        
//        let callComposite = GlobalCompositeManager.callComposite != nil ?  GlobalCompositeManager.callComposite! : CallComposite(credential: credential, withOptions: callCompositeOptions)
//        
//        if (GlobalCompositeManager.callComposite == nil) {
//            subscribeToEvents(callComposite: callComposite, onSendEvent: onSendEvent)
//        }
//        
//        GlobalCompositeManager.callComposite = callComposite
//        
//        return callComposite
//    }
//    
//    func subscribeToEvents(callComposite: CallComposite, onSendEvent: @escaping ((Event) -> Void)) {
//        let callKitCallAccepted: (String) -> Void = { [weak callComposite, weak self] callId in
//            callComposite?.launch(callIdAcceptedFromCallKit: callId, localOptions: self?.getCallLocalOptions(azureCallId: callId))
//        }
//
//        callComposite.events.onIncomingCallAcceptedFromCallKit = callKitCallAccepted
//
//        let showChatEvent: () -> Void = {
//            onSendEvent(Event(name: Constants.FlutterEvents.onShowChat))
//        }
//
//        callComposite.events.onShowUserChat = showChatEvent
//
//        let callCompositDismissed: ((CallCompositeDismissed) -> Void)? = { _ in
//            onSendEvent(Event(name: Constants.FlutterEvents.onCallUIClosed))
//        }
//
//        callComposite.events.onDismissed = callCompositDismissed
//
//        let onPluginStarted: () -> Void = {
//            onSendEvent(Event(name: Constants.FlutterEvents.onPluginStarted))
//        }
//
//        callComposite.events.onPluginStarted = onPluginStarted
//
//        let onUserCallEnded: () -> Void = {
//            onSendEvent(Event(name: Constants.FlutterEvents.onUserCallEnded))
//        }
//
//        callComposite.events.onUserCallEnded = onUserCallEnded
//
//        let onOneOnOneCallEnded: () -> Void = {
//            onSendEvent(Event(name: Constants.FlutterEvents.onOneOnOneCallEnded))
//        }
//
//        callComposite.events.onOneOnOneCallEnded = onOneOnOneCallEnded
//    }
    
    func incomingCallRemoteInfo(info: Caller) -> CallKitRemoteInfo {
        let cxHandle = CXHandle(type: .generic, value: "Incoming call")
        var remoteInfoDisplayName = info.displayName
        
        if remoteInfoDisplayName.isEmpty {
            remoteInfoDisplayName = info.identifier.rawId
        }
        
        let callKitRemoteInfo = CallKitRemoteInfo(displayName: remoteInfoDisplayName,
                                                  handle: cxHandle)
        return callKitRemoteInfo
    }
    
    func configureAudioSession() -> Error? {
        let audioSession = AVAudioSession.sharedInstance()
        var configError: Error?
        
        // Check the current audio output route
        let currentRoute = audioSession.currentRoute
        let isUsingSpeaker = currentRoute.outputs.contains { $0.portType == .builtInSpeaker }
        let isUsingReceiver = currentRoute.outputs.contains { $0.portType == .builtInReceiver }
        
        // Only configure the session if necessary (e.g., when not on speaker/receiver)
        if !isUsingSpeaker && !isUsingReceiver {
            do {
                // Keeping default .playAndRecord without forcing speaker
                try audioSession.setCategory(.playAndRecord, options: [.allowBluetooth])
                try audioSession.setActive(true)
            } catch {
                configError = error
            }
        }
        
        return configError
    }
    
    private func getCallLocalOptions(azureCallId: String) -> LocalOptions {
        return LocalOptions(cameraOn: false, microphoneOn: true, azureCallId: azureCallId)
    }
}

final class CallCompositeManager {
    
    private var isRealDevice: Bool {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }
    
    static let shared = CallCompositeManager()
    
    init() {
        setupTokenRefresh()
    }
    
    var tokenRefresher: ((@escaping (String?, Error?) -> Void) -> Void)?
    
    private func setupTokenRefresh() {
            tokenRefresher = { [weak self] tokenCompletionHandler in
//                self?.channel.invokeMethod("getToken", arguments: nil, result: { result in
//                    if let token = result as? String {
//                        tokenCompletionHandler(token, nil)
//                    } else {
//                        let error = NSError(domain: "TokenError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch token"])
//                        tokenCompletionHandler(nil, error)
//                    }
//                }
//                )
            }
        }
    
    @discardableResult
    func getCallComposite(callKitOptions: CallKitOptions? = nil, onSubscribeToCallCompositeEvents: ((CallComposite) -> Void)? = nil) ->  CallComposite? {
        guard let userData = UserDefaults.standard.loadUserData() else { return nil }
        
        
        let refreshOptions = CommunicationTokenRefreshOptions(
            initialToken: userData.token,
            refreshProactively: true,
            tokenRefresher: tokenRefresher!
        )
        
        let callKitOption = {
            if isRealDevice && callKitOptions != nil {
                return callKitOptions
            } else if !isRealDevice {
                return nil
            } else {
                return CallKitOptions()
            }
        }()
        
        guard let credential = try? CommunicationTokenCredential(withOptions: refreshOptions) else { return nil }
        
        let callCompositeOptions = CallCompositeOptions(
            localization: LocalizationOptions(locale: Locale.resolveLocale(from: userData.languageCode)),
            enableMultitasking: true,
            enableSystemPictureInPictureWhenMultitasking: true,
            callKitOptions: callKitOption,
            displayName: userData.name,
            userId: CommunicationUserIdentifier(userData.userId)
        )
        
        let callComposite = GlobalCompositeManager.callComposite != nil ?  GlobalCompositeManager.callComposite! : CallComposite(credential: credential, withOptions: callCompositeOptions)
        
        if (GlobalCompositeManager.callComposite == nil) {
            onSubscribeToCallCompositeEvents?(callComposite)
        }
        
        GlobalCompositeManager.callComposite = callComposite
        
        return callComposite
    }
}
