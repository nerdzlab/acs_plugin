package com.acs_plugin.extensions

import android.R.attr.type
import com.acs_plugin.calling.service.sdk.ext.id
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationIdentifier
import kotlinx.serialization.json.Json

fun ChatThreadProperties.toJson(): String {
    val map = buildMap {
        put("id", id)
        put("topic", topic)
        put("createdOn", createdOn.toString())
        put("createdBy", createdByCommunicationIdentifier.toJson())
    }
    return Json.encodeToString(map)
}

fun CommunicationIdentifier.toJson(): String {
    val map = buildMap {
        put("rawId", rawId)
    }
    return Json.encodeToString(map)
}

fun TypingIndicatorReceivedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("sender", sender?.toJson())
        put("recipient", recipient?.toJson())
        put("version", version)
        receivedOn?.let { put("receivedOn", it.toString()) }
        senderDisplayName?.let { put("senderDisplayName", it) }
    }
    return Json.encodeToString(map)
}

fun ReadReceiptReceivedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("sender", sender?.toJson())
        put("recipient", recipient?.toJson())
        put("chatMessageId", chatMessageId)
        readOn?.let { put("readOn", it.toString()) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageEditedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("sender", sender?.toJson())
        put("recipient", recipient?.toJson())
        put("id", id)
        put("senderDisplayName", senderDisplayName ?: "")
        put("createdOn", createdOn?.toString() ?: "")
        put("version", version)
        put("type", type.toString())
        put("message", content)
        editedOn?.let { put("editedOn", it.toString()) }
        metadata?.let { put("metadata", it) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageReceivedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("id", id)
        put("message", content)
        put("version", version)
        sender?.let { put("sender", it.toJson()) }
        recipient?.let { put("recipient", it.toJson()) }
        senderDisplayName?.let { put("senderDisplayName", it) }
        createdOn?.let { put("createdOn", it.toString()) }
        put("type", type.toString())
        metadata?.let { put("metadata", it) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageDeletedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("sender", sender?.toJson())
        put("recipient", recipient?.toJson())
        put("id", id)
        put("senderDisplayName", senderDisplayName ?: "")
        put("createdOn", createdOn?.toString() ?: "")
        put("version", version)
        put("type", type.toString())
        deletedOn?.let { put("deletedOn", it.toString()) }
    }
    return Json.encodeToString(map)
}

fun ChatThreadCreatedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("version", version)
        createdOn?.let { put("createdOn", it.toString()) }
        properties?.let { put("properties", it.toJson()) }
        participants?.let { put("participants", it.map { participant -> participant.toJson() }) }
        createdBy?.let { put("createdBy", it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ChatThreadPropertiesUpdatedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("version", version)
        updatedOn?.let { put("updatedOn", it.toString()) }
        properties?.let { put("properties", it.toJson()) }
        updatedBy?.let { put("updatedBy", it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ChatThreadDeletedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("version", version)
        deletedOn?.let { put("deletedOn", it.toString()) }
        deletedBy?.let { put("deletedBy", it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ParticipantsRemovedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("version", version)
        removedOn?.let { put("removedOn", it.toString()) }
        put("participantsRemoved", participantsRemoved?.map { it.toJson() })
        removedBy?.let { put("removedBy", it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ParticipantsAddedEvent.toJson(): String {
    val map = buildMap {
        put("threadId", chatThreadId)
        put("version", version)
        addedOn?.let { put("addedOn", it.toString()) }
        put("participantsAdded", participantsAdded?.map { it.toJson() })
        addedBy?.let { put("addedBy", it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageReadReceipt.toJson(): String {
    val map = buildMap {
        put("sender", senderCommunicationIdentifier.toJson())
        put("chatMessageId", chatMessageId)
        put("readOn", readOn.toString())
    }
    return Json.encodeToString(map)
}

fun ChatParticipant.toJson(): String {
    val map = buildMap {
        put("id", communicationIdentifier.id())
        displayName?.let { put("displayName", it) }
        shareHistoryTime?.let { put("shareHistoryTime", it.toString()) }
    }
    return Json.encodeToString(map)
}

fun ChatMessage.toJson(): String {
    val map = buildMap {
        put("id", id)
        put("type", type.toString())
        put("version", version)
        put("createdOn", createdOn.toString())
        content?.let { put("content", it) }
        senderDisplayName?.let { put("senderDisplayName", it) }
        senderCommunicationIdentifier?.let { put("sender", it.toJson()) }
        deletedOn?.let { put("deletedOn", it.toString()) }
        editedOn?.let { put("editedOn", it.toString()) }
        metadata?.let { put("metadata", it) }
    }
    return Json.encodeToString(map)
}

