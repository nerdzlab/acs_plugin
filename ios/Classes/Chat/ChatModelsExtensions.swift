//
//  ChatModelsExtensions.swift
//  Pods
//
//  Created by Yriy Malyts on 14.05.2025.
//

import AzureCommunicationCommon
import AzureCommunicationChat

extension ChatMessageReceivedEvent {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "threadId": threadId,
            "id": id,
            "message": message,
            "version": version
        ]
        
        if let sender = sender {
            json["sender"] = sender.toJson()
        }
        
        if let recipient = recipient {
            json["recipient"] = recipient.toJson()
        }
        
        if let senderDisplayName = senderDisplayName {
            json["senderDisplayName"] = senderDisplayName
        }
        
        if let createdOn = createdOn {
            json["createdOn"] = createdOn.requestString
        }
        
        json["type"] = type.requestString
        
        if let metadata = metadata {
            json["metadata"] = metadata
        }
        
        return json
    }
}

extension IdentifierKind {
    func toJson() -> [String: Any] {
        let identifierType: String
        
        switch self {
        case IdentifierKind.communicationUser:
            identifierType = "communicationUser"
        case IdentifierKind.phoneNumber:
            identifierType = "phoneNumber"
        case IdentifierKind.microsoftTeamsUser:
            identifierType = "microsoftTeamsUser"
        case IdentifierKind.microsoftTeamsApp:
            identifierType = "microsoftTeamsApp"
        case IdentifierKind.unknown:
            identifierType = "unknown"
        default:
            identifierType = "unknown"
        }
        
        return ["rawValue": identifierType]
    }
}

extension CommunicationIdentifier {
    func toJson() -> [String: Any] {
        return [
            "rawId": rawId,
            "kind": kind.toJson()
        ]
    }
}

extension TypingIndicatorReceivedEvent {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "threadId": threadId,
            "sender": sender?.toJson() ?? [:],
            "recipient": recipient?.toJson() ?? [:],
            "version": version
        ]

        if let receivedOn = receivedOn {
            json["receivedOn"] = receivedOn.requestString
        }

        if let senderDisplayName = senderDisplayName {
            json["senderDisplayName"] = senderDisplayName
        }

        return json
    }
}

extension ReadReceiptReceivedEvent {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "threadId": threadId,
            "sender": sender?.toJson() ?? [:],
            "recipient": recipient?.toJson() ?? [:],
            "chatMessageId": chatMessageId
        ]

        if let readOn = readOn {
            json["readOn"] = readOn.requestString
        }

        return json
    }
}

extension ChatMessageEditedEvent {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "threadId": threadId,
            "sender": sender?.toJson() ?? [:],
            "recipient": recipient?.toJson() ?? [:],
            "id": id,
            "senderDisplayName": senderDisplayName ?? "",
            "createdOn": createdOn?.requestString ?? "",
            "version": version,
            "type": type.requestString,
            "message": message
        ]

        if let editedOn = editedOn {
            json["editedOn"] = editedOn.requestString
        }

        if let metadata = metadata {
            json["metadata"] = metadata
        }

        return json
    }
}

extension ChatMessageDeletedEvent {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "threadId": threadId,
            "sender": sender?.toJson() ?? [:],
            "recipient": recipient?.toJson() ?? [:],
            "id": id,
            "senderDisplayName": senderDisplayName ?? "",
            "createdOn": createdOn?.requestString ?? "",
            "version": version,
            "type": type.requestString
        ]
        
        if let deletedOn = deletedOn {
            json["deletedOn"] = deletedOn.requestString
        }
        
        return json
    }
}

extension SignalingChatThreadProperties {
    func toJson() -> [String: Any] {
        return [
            "topic": topic
        ]
    }
}

extension SignalingChatParticipant {
    func toJson() -> [String: Any] {
        return [
            "id": id?.rawId ?? "",
            "displayName": displayName ?? "",
            "shareHistoryTime": shareHistoryTime?.requestString ?? ""
        ]
    }
}

extension ChatThreadCreatedEvent {
    func toJson() -> [String: Any] {
        let json: [String: Any] = [
            "threadId": threadId,
            "version": version,
            "createdOn": createdOn?.requestString ?? "",
            "properties": properties?.toJson() ?? [:],
            "participants": participants?.map { $0.toJson() } ?? [],
            "createdBy": createdBy?.toJson() ?? [:]
        ]
        
        return json
    }
}

extension ChatThreadPropertiesUpdatedEvent {
    func toJson() -> [String: Any] {
        let json: [String: Any] = [
            "threadId": threadId,
            "version": version,
            "updatedOn": updatedOn?.requestString ?? "",
            "properties": properties?.toJson() ?? [:],
            "updatedBy": updatedBy?.toJson() ?? [:]
        ]
        
        return json
    }
}

extension ChatThreadDeletedEvent {
    func toJson() -> [String: Any] {
        let json: [String: Any] = [
            "threadId": threadId,
            "version": version,
            "deletedOn": deletedOn?.requestString ?? "",
            "deletedBy": deletedBy?.toJson() ?? [:]
        ]
        
        return json
    }
}

extension ParticipantsAddedEvent {
    func toJson() -> [String: Any] {
        let json: [String: Any] = [
            "threadId": threadId,
            "version": version,
            "addedOn": addedOn?.requestString ?? "",
            "participantsAdded": participantsAdded?.map { $0.toJson() } ?? [],
            "addedBy": addedBy?.toJson() ?? [:]
        ]
        
        return json
    }
}

extension ParticipantsRemovedEvent {
    func toJson() -> [String: Any] {
        let json: [String: Any] = [
            "threadId": threadId,
            "version": version,
            "removedOn": removedOn?.requestString ?? "",
            "participantsRemoved": participantsRemoved?.map { $0.toJson() } ?? [],
            "removedBy": removedBy?.toJson() ?? [:]
        ]
        
        return json
    }
}

extension ChatMessage {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "id": id,
            "type": type.requestString,
            "sequenceId": sequenceId,
            "version": version,
            "createdOn": createdOn.requestString
        ]

        if let content = content {
            json["content"] = content.toJson()
        }

        if let senderDisplayName = senderDisplayName {
            json["senderDisplayName"] = senderDisplayName
        }

        if let sender = sender {
            json["sender"] = sender.toJson()
        }

        if let deletedOn = deletedOn {
            json["deletedOn"] = deletedOn.requestString
        }

        if let editedOn = editedOn {
            json["editedOn"] = editedOn.requestString
        }

        if let metadata = metadata {
            json["metadata"] = metadata
        }

        return json
    }
}

extension ChatMessageContent {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [:]

        if let message = message {
            json["message"] = message
        }

        if let topic = topic {
            json["topic"] = topic
        }

        if let participants = participants {
            json["participants"] = participants.map { $0.toJson() }
        }

        if let initiator = initiator {
            json["initiator"] = initiator.toJson()
        }

        return json
    }
}

extension ChatParticipant {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "id": id.toJson()
        ]

        if let displayName = displayName {
            json["displayName"] = displayName
        }

        if let shareHistoryTime = shareHistoryTime {
            json["shareHistoryTime"] = shareHistoryTime.requestString
        }

        return json
    }
}

extension ChatThreadProperties {
    func toJson() -> [String: Any] {
        var json: [String: Any] = [
            "id": id,
            "topic": topic,
            "createdOn": createdOn.requestString,
            "createdBy": createdBy.toJson()
        ]

        if let deletedOn = deletedOn {
            json["deletedOn"] = deletedOn.requestString
        }

        return json
    }
}
