//
//  PreloadedAction.swift
//  Pods
//
//  Created by Yriy Malyts on 22.05.2025.
//

import AzureCommunicationChat

enum PreloadedActionType: String {
    case chatNotification
}

struct PreloadedAction {
    let type: PreloadedActionType
    let chatPushNotificationReceivedEvent: PushNotificationChatMessageReceivedEvent?

    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "type": type.rawValue
        ]
        
        if let chatPushNotificationReceivedEvent = chatPushNotificationReceivedEvent {
            json["chatPushNotificationReceivedEvent"] = chatPushNotificationReceivedEvent.toJson()
        }
        
        return json
    }
}
