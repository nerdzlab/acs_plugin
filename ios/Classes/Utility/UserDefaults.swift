//
//  Keys.swift
//  Pods
//
//  Created by Yriy Malyts on 23.05.2025.
//


extension UserDefaults {
    private enum Keys {
        static let userData = "userDataKey"
        static let chatEndpoint = "chatEndpoint"
        static let apnsToken = "APNSToken"
    }

    // MARK: - UserData

    func saveUserData(_ userData: UserDataHandler.UserData) {
        if let encoded = try? JSONEncoder().encode(userData) {
            set(encoded, forKey: Keys.userData)
        }
    }

    func loadUserData() -> UserDataHandler.UserData? {
        guard let data = data(forKey: Keys.userData),
              let decoded = try? JSONDecoder().decode(UserDataHandler.UserData.self, from: data) else {
            return nil
        }
        return decoded
    }

    func clearUserData() {
        removeObject(forKey: Keys.userData)
    }

    // MARK: - Chat Endpoint

    public func setChatEndpoint(_ endpoint: String?) {
        set(endpoint, forKey: Keys.chatEndpoint)
    }

    public func getChatEndpoint() -> String? {
        string(forKey: Keys.chatEndpoint)
    }

    // MARK: - APNS Token

    public func setAPNSToken(_ token: String?) {
        set(token, forKey: Keys.apnsToken)
    }

    public func getAPNSToken() -> String? {
        string(forKey: Keys.apnsToken)
    }
}

