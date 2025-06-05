//
//  UserDataHandler.swift
//  Pods
//
//  Created by Yriy Malyts on 12.05.2025.
//

import Flutter
import AzureCommunicationCalling
import AzureCommunicationCommon
import AzureCommunicationChat

final class UserDataHandler: MethodHandler {
    
    struct UserData: Codable {
        let token: String
        let name: String
        let userId: String
        let languageCode: String
    }
    
    private enum Constants {
        enum MethodChannels {
            static let setUserData = "setUserData"
            static let getToken = "getToken"
        }
    }
    
    var tokenRefresher: ((@escaping (String?, Error?) -> Void) -> Void)?
    
    private var userData: UserData? {
        didSet {
            guard let userData else { return }
            UserDefaults.standard.saveUserData(userData)
            onUserDataReceived(userData)
            
            guard let appGroup = UserDefaults.standard.getAppGroupIdentifier() else { return }
            UserDefaults(suiteName: appGroup)?.setLanguageCode(userData.languageCode)
        }
    }
    
    private let onSubscribeToCallCompositeEvents: (CallComposite) -> Void
    private let onUserDataReceived: (UserData) -> Void
    
    private var isRealDevice: Bool {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }
    
    init(
        onSubscribeToCallCompositeEvents: @escaping (CallComposite) -> Void,
        onUserDataReceived: @escaping (UserData) -> Void
    ) {
        self.onSubscribeToCallCompositeEvents = onSubscribeToCallCompositeEvents
        self.onUserDataReceived = onUserDataReceived
        self.setupTokenRefresh()
    }
    
    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case Constants.MethodChannels.setUserData:
            if let arguments = call.arguments as? [String: Any],
               let token = arguments["token"] as? String,
               let name = arguments["name"] as? String,
               let userId = arguments["userId"] as? String,
               let languageCode = arguments["languageCode"] as? String
            {
                self.userData = UserData(token: token, name: name, userId: userId, languageCode: languageCode)
                
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, name and userId are required", details: nil))
            }
            
            return true
            
        default:
            return false
        }
    }
    
    func getCallComposite() ->  CallComposite? {
        guard let userData = userData else { return nil }
        
        guard let tokenRefresher = self.tokenRefresher else { return nil }
        
        let refreshOptions = CommunicationTokenRefreshOptions(
            initialToken: userData.token,
            refreshProactively: true,
            tokenRefresher: tokenRefresher
        )
        
        guard let credential = try? CommunicationTokenCredential(withOptions: refreshOptions) else { return nil }
        
        let callCompositeOptions = CallCompositeOptions(
            localization: LocalizationOptions(locale: Locale.resolveLocale(from: userData.languageCode)),
            enableMultitasking: true,
            enableSystemPictureInPictureWhenMultitasking: true,
            callKitOptions: isRealDevice ? CallKitOptions() : nil,
            displayName: userData.name,
            userId: CommunicationUserIdentifier(userData.userId)
        )
        
        let callComposite = GlobalCompositeManager.callComposite != nil ?  GlobalCompositeManager.callComposite! : CallComposite(credential: credential, withOptions: callCompositeOptions)
        
        if (GlobalCompositeManager.callComposite == nil) {
            onSubscribeToCallCompositeEvents(callComposite)
        }
        
        GlobalCompositeManager.callComposite = callComposite
        
        return callComposite
    }
    
    func getUserData() -> UserData? {
        return userData
    }
    
    private func getCallKitOptions() -> CallKitOptions {
        let cxHandle = CXHandle(type: .generic, value: "Outgoing call")
        let providerConfig = CXProviderConfiguration()
        providerConfig.supportsVideo = true
        providerConfig.maximumCallGroups = 2
        providerConfig.includesCallsInRecents = false
        providerConfig.supportedHandleTypes = [.phoneNumber, .generic]
        let isCallHoldSupported = true
        let callKitOptions = CallKitOptions(providerConfig: providerConfig,
                                            isCallHoldSupported: isCallHoldSupported,
                                            provideRemoteInfo: incomingCallRemoteInfo,
                                            configureAudioSession: configureAudioSession)
        return callKitOptions
    }
    
    public func incomingCallRemoteInfo(info: Caller) -> CallKitRemoteInfo {
        let cxHandle = CXHandle(type: .generic, value: "Incoming call")
        var remoteInfoDisplayName = info.displayName
        
        if remoteInfoDisplayName.isEmpty {
            remoteInfoDisplayName = info.identifier.rawId
        }
        
        let callKitRemoteInfo = CallKitRemoteInfo(displayName: remoteInfoDisplayName,
                                                  handle: cxHandle)
        return callKitRemoteInfo
    }
    
    private func configureAudioSession() -> Error? {
        let audioSession = AVAudioSession.sharedInstance()
        var configError: Error?
        
        do {
            // Keeping default .playAndRecord without forcing speaker
            try audioSession.setCategory(.playAndRecord)
        } catch {
            configError = error
        }
        
        return configError
    }
    
    private func setupTokenRefresh() {
        tokenRefresher = { [weak self] tokenCompletionHandler in
            //            self?.channel.invokeMethod("getToken", arguments: nil, result: { result in
            //                if let token = result as? String {
            tokenCompletionHandler("token", nil)
            //                } else {
            //                    let error = NSError(domain: "TokenError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch token"])
            //                    tokenCompletionHandler(nil, error)
            //                }
            //            }
            //            )
        }
    }
}
