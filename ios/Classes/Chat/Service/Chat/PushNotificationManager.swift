//
//  PushNotificationManager.swift
//  Pods
//
//  Created by Yriy Malyts on 23.05.2025.
//


import Foundation
import AzureCommunicationChat
import AzureCore
import AzureCommunicationCalling

final class BackgroundChatManager {

    static let shared = BackgroundChatManager()

    private var chatClient: ChatClient?

    func renewPushSubscription(appGroupId: String, apnsToken: String, completion: @escaping () -> Void) {
        createChatClient()

        let keyTag = "PNKey"

        do {
            guard let appGroupPushNotificationKeyStorage: PushNotificationKeyStorage =
                    try AppGroupPushNotificationKeyStorage(appGroupId: appGroupId, keyTag: keyTag),
                  let chatClient = self.chatClient else {
                completion()
                return
            }

            chatClient.pushNotificationKeyStorage = appGroupPushNotificationKeyStorage

            let semaphore = DispatchSemaphore(value: 0)

            DispatchQueue.global(qos: .background).async {
                chatClient.startPushNotifications(deviceToken: apnsToken) { result in
                    switch result {
                    case .success:
                        print("Succeeded to start Push Notifications")
                    case .failure(let error):
                        print("Failed to start Push Notifications: \(error.localizedDescription)")
                    }

                    completion()
                    semaphore.signal()
                }

                semaphore.wait()
            }
        } catch {
            print("Error setting up PushNotificationKeyStorage: \(error)")
            completion()
        }
    }
    
    private func createChatClient() {
        guard let appGroupIdentifier = UserDefaults.standard.getAppGroupIdentifier(),
              let endpoint = UserDefaults.standard.getChatEndpoint(),
              //App group only for shared data
              let userData = UserDefaults(suiteName: appGroupIdentifier)?.loadUserData() else {
            return
        }

        do {
            let credential = try CommunicationTokenCredential(token: userData.token)
            let appId = DiagnosticConfig().tags.joined(separator: "/")
            let telemetryOptions = TelemetryOptions(applicationId: appId)
            let clientOptions = AzureCommunicationChatClientOptions(telemetryOptions: telemetryOptions)

            chatClient = try ChatClient(
                endpoint: endpoint,
                credential: credential,
                withOptions: clientOptions
            )
        } catch {
            print("Failed to create chat client: \(error)")
        }
    }
}
