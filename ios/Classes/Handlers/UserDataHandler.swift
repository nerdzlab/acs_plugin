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
        
        static let yarko = UserData(
            token: "eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNV8wMDAwMDAyNy1mNDgzLWNjNWItODc0YS1hZDNhMGQwMDNiMTciLCJzY3AiOjE3OTIsImNzaSI6IjE3NDk5OTE4NjIiLCJleHAiOjE3NTAwNzgyNjIsInJnbiI6ImRlIiwiYWNzU2NvcGUiOiJjaGF0LHZvaXAiLCJyZXNvdXJjZUlkIjoiNmQxNDEzY2YtMmQyNC00MTkxLWE1NzAtMTFkYTkxNmU4NDI1IiwicmVzb3VyY2VMb2NhdGlvbiI6Imdlcm1hbnkiLCJpYXQiOjE3NDk5OTE4NjJ9.TrnGVgiMKZuoUfJHTv2rAudcXNMRWnUMNWRbiU2vwnRKromnfm7WO0QipZzgQwot6YnsUJJWCEHMTMIL9pvU73S4gmdw3RtvxjdNhIt1Sp6pk5ZfxG95rAgv7ittHNuuGUcMRynwV7jkzwxhhZKdsxDAmofLa1fmGrBUk6MAr4i5PAKG2fG1dNcL98Xfo9qB9jceDxXugymLtK7N52dfIPTFNfC3deD3aPAKSbiwpAYQKYLaNiM4l42_5wSPeLatLJYJMBrB8JwAqPBiNkVHMP7ZQLQtq3wgPZM9u0QI-_XjwrvBSY0Ao5MhrPzu5FdTQ_3d66JXLpaHR42WRYvpFw",
            name: "Yarko Patient",
            userId: "8:acs:6d1413cf-2d24-4191-a570-11da916e8425_00000027-f483-cc5b-874a-ad3a0d003b17",
            languageCode: "nl",
            appToken: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6ImU3YjcwYzNhLTA4MmQtNGMzYi04ZjM5LWI2YjZiMzY5OGExMCIsIm9yZ2FuaXphdGlvbl9pZCI6IjY1NzU2ZTgzLTAwYjUtNDc1NS04M2EzLTAwZGQyYzFhYTY5MSIsImlzX29uYm9hcmRlZCI6dHJ1ZSwic3luY19wYXRpZW50X2RhdGEiOmZhbHNlLCJ2aWRlb19jYWxsX3Byb3ZpZGVyIjoiaG1zIiwiaHR0cHM6Ly9oYXN1cmEuaW8vand0L2NsYWltcyI6eyJ4LWhhc3VyYS1hbGxvd2VkLXJvbGVzIjpbInVzZXIiXSwieC1oYXN1cmEtZGVmYXVsdC1yb2xlIjoidXNlciIsIngtaGFzdXJhLXVzZXItaWQiOiJlN2I3MGMzYS0wODJkLTRjM2ItOGYzOS1iNmI2YjM2OThhMTAifSwicm9sZSI6InVzZXIiLCJhY2NvdW50X3R5cGUiOm51bGwsImlhdCI6MTc0OTk5MDY0OSwiZXhwIjoxNzUyNTgyNjQ5LCJzdWIiOiJlN2I3MGMzYS0wODJkLTRjM2ItOGYzOS1iNmI2YjM2OThhMTAifQ.hdFwqoDNCHVEM9_hmsTtDvYaAOauOhlH7uA3_tBtLwU", 
            baseUrl: "https://api-msteam.superbrains.nl/v1/graphql"
        )
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
    private let unregisterPushNotifications: () -> Void
    
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
        unregisterPushNotifications: @escaping () -> Void
    ) {
        self.onSubscribeToCallCompositeEvents = onSubscribeToCallCompositeEvents
        self.onUserDataReceived = onUserDataReceived
        self.unregisterPushNotifications = unregisterPushNotifications
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
//                self.reconfigureCallComposite()
            }
            else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, name and userId are required", details: nil))
            }
            
            return true
            
        case Constants.MethodChannels.unregisterPushNotifications:
            unregisterPushNotifications()
            
            return true
            
        case Constants.MethodChannels.clearUserData:
            userData = nil
            
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
    
    private func reconfigureCallComposite() {
        guard let userData else {
            return
        }
        
        guard let tokenRefresher else {
            return
        }
        
        let refreshOptions = CommunicationTokenRefreshOptions(
            initialToken: userData.token,
            refreshProactively: true,
            tokenRefresher: tokenRefresher
        )
        
        guard let credential = try? CommunicationTokenCredential(withOptions: refreshOptions) else {
            return
        }
        
        let callCompositeOptions = CallCompositeOptions(
            localization: LocalizationOptions(locale: Locale.resolveLocale(from: userData.languageCode)),
            enableMultitasking: true,
            enableSystemPictureInPictureWhenMultitasking: true,
            callKitOptions: isRealDevice ? CallKitOptions() : nil,
            displayName: userData.name,
            userId: CommunicationUserIdentifier(userData.userId)
        )
        let composite = CallComposite(credential: credential, withOptions: callCompositeOptions)
        GlobalCompositeManager.callComposite = composite
        onSubscribeToCallCompositeEvents(composite)
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
