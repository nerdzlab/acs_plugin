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
        let appToken: String
        let baseUrl: String
    }
    
    private enum Constants {
        enum MethodChannels {
            static let setUserData = "setUserData"
            static let clearUserData = "clearUserData"
            static let unregisterPushNotifications = "unregisterPushNotifications"
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
        onUserDataReceived: @escaping (UserData) -> Void,
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
               let languageCode = arguments["languageCode"] as? String,
               let appToken = arguments["appToken"] as? String,
               let baseUrl = arguments["baseUrl"] as? String
            {
                self.userData = UserData(
                    token: token,
                    name: name,
                    userId: userId,
                    languageCode: languageCode,
                    appToken: appToken,
                    baseUrl: baseUrl
                )
                self.reconfigureCallComposite()
            }
            else {
                result(
                    FlutterError(
                        code: "INVALID_ARGUMENTS",
                        message: "Token, name and userId are required",
                        details: nil
                    )
                )
            }
            
            return true
            
        case Constants.MethodChannels.unregisterPushNotifications:
            getCallComposite()
            
            return true
            
        case Constants.MethodChannels.clearUserData:
            userData = nil
            
            return true
            
        default:
            return false
        }
    }
    
    func getCallComposite(with options: CallKitOptions? = nil) ->  CallComposite? {
        if let options {
            return reconfigureCallComposite(with: options)
        }
        else {
            return GlobalCompositeManager.callComposite ?? reconfigureCallComposite()
        }
    }
    
    func getUserData() -> UserData? {
        userData
    }
    
    @discardableResult
    private func reconfigureCallComposite(with options: CallKitOptions? = nil) -> CallComposite? {
        let callOptions = options ?? (isRealDevice ? CallKitOptions() : nil)
        
        guard let userData else {
            return nil
        }
        
        guard let tokenRefresher else {
            return nil
        }
        
        let refreshOptions = CommunicationTokenRefreshOptions(
            initialToken: userData.token,
            refreshProactively: true,
            tokenRefresher: tokenRefresher
        )
        
        guard let credential = try? CommunicationTokenCredential(withOptions: refreshOptions) else {
            return nil
        }
        
        let callCompositeOptions = CallCompositeOptions(
            localization: LocalizationOptions(locale: Locale.resolveLocale(from: userData.languageCode)),
            enableMultitasking: true,
            enableSystemPictureInPictureWhenMultitasking: true,
            callKitOptions: callOptions,
            displayName: userData.name,
            userId: CommunicationUserIdentifier(userData.userId)
        )
        let composite = CallComposite(
            credential: credential,
            withOptions: callCompositeOptions
        )
        
        onSubscribeToCallCompositeEvents(composite)
        
        GlobalCompositeManager.callComposite = composite
        
        return composite
    }
    
    private func setupTokenRefresh() {
        tokenRefresher = { [weak self] tokenCompletionHandler in
            NetworkHandler.fetchAzureToken { result in
                switch result {
                case .success(let token):
                    debugPrint("✅ Token: \(token)")
                    tokenCompletionHandler(token, nil)
                    
                    guard let userData = self?.userData else { return }
                            
                    self?.userData = UserData(
                        token: token,
                        name: userData.name,
                        userId: userData.userId,
                        languageCode: userData.languageCode,
                        appToken: userData.token,
                        baseUrl: userData.baseUrl
                    )
                    
                case .failure(let error):
                    debugPrint("❌ Error: \(error)")
                    tokenCompletionHandler(nil, error)
                }
            }
        }
    }
}
