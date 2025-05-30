package com.acs_plugin.extensions

import android.R.attr.type
import com.acs_plugin.Constants
import com.acs_plugin.calling.service.sdk.ext.id
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationIdentifier
import kotlinx.serialization.json.Json

fun ChatThreadProperties.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.ID, id)
        put(Constants.JsonKeys.TOPIC, topic)
        put(Constants.JsonKeys.CREATED_ON, createdOn.toString())
        put(Constants.JsonKeys.CREATED_BY, createdByCommunicationIdentifier.toJson())
    }
    return Json.encodeToString(map)
}

fun CommunicationIdentifier.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.RAW_ID, rawId)
        put(Constants.JsonKeys.KIND, "communicationUser")
    }
    return Json.encodeToString(map)
}

fun TypingIndicatorReceivedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.SENDER, sender?.toJson())
        put(Constants.JsonKeys.RECIPIENT, recipient?.toJson())
        put(Constants.JsonKeys.VERSION, version)
        receivedOn?.let { put(Constants.JsonKeys.RECEIVED_ON, it.toString()) }
        senderDisplayName?.let { put(Constants.JsonKeys.SENDER_DISPLAY_NAME, it) }
    }
    return Json.encodeToString(map)
}

fun ReadReceiptReceivedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.SENDER, sender?.toJson())
        put(Constants.JsonKeys.RECIPIENT, recipient?.toJson())
        put(Constants.JsonKeys.CHAT_MESSAGE_ID, chatMessageId)
        readOn?.let { put(Constants.JsonKeys.READ_ON, it.toString()) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageEditedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.SENDER, sender?.toJson())
        put(Constants.JsonKeys.RECIPIENT, recipient?.toJson())
        put(Constants.JsonKeys.ID, id)
        put(Constants.JsonKeys.SENDER_DISPLAY_NAME, senderDisplayName ?: "")
        put(Constants.JsonKeys.CREATED_ON, createdOn?.toString() ?: "")
        put(Constants.JsonKeys.VERSION, version)
        put(Constants.JsonKeys.TYPE, type.toString())
        put(Constants.JsonKeys.MESSAGE, content)
        editedOn?.let { put(Constants.JsonKeys.EDITED_ON, it.toString()) }
        metadata?.let { put(Constants.JsonKeys.METADATA, it) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageReceivedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.ID, id)
        put(Constants.JsonKeys.MESSAGE, content)
        put(Constants.JsonKeys.VERSION, version)
        sender?.let { put(Constants.JsonKeys.SENDER, it.toJson()) }
        recipient?.let { put(Constants.JsonKeys.RECIPIENT, it.toJson()) }
        senderDisplayName?.let { put(Constants.JsonKeys.SENDER_DISPLAY_NAME, it) }
        createdOn?.let { put(Constants.JsonKeys.CREATED_ON, it.toString()) }
        put(Constants.JsonKeys.TYPE, type.toString())
        metadata?.let { put(Constants.JsonKeys.METADATA, it) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageDeletedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.SENDER, sender?.toJson())
        put(Constants.JsonKeys.RECIPIENT, recipient?.toJson())
        put(Constants.JsonKeys.ID, id)
        put(Constants.JsonKeys.SENDER_DISPLAY_NAME, senderDisplayName ?: "")
        put(Constants.JsonKeys.CREATED_ON, createdOn?.toString() ?: "")
        put(Constants.JsonKeys.VERSION, version)
        put(Constants.JsonKeys.TYPE, type.toString())
        deletedOn?.let { put(Constants.JsonKeys.DELETED_ON, it.toString()) }
    }
    return Json.encodeToString(map)
}

fun ChatThreadCreatedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.VERSION, version)
        createdOn?.let { put(Constants.JsonKeys.CREATED_ON, it.toString()) }
        properties?.let { put(Constants.JsonKeys.PROPERTIES, it.toJson()) }
        participants?.let { put(Constants.JsonKeys.PARTICIPANTS, it.map { participant -> participant.toJson() }) }
        createdBy?.let { put(Constants.JsonKeys.CREATED_BY, it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ChatThreadPropertiesUpdatedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.VERSION, version)
        updatedOn?.let { put(Constants.JsonKeys.UPDATED_ON, it.toString()) }
        properties?.let { put(Constants.JsonKeys.PROPERTIES, it.toJson()) }
        updatedBy?.let { put(Constants.JsonKeys.UPDATED_BY, it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ChatThreadDeletedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.VERSION, version)
        deletedOn?.let { put(Constants.JsonKeys.DELETED_ON, it.toString()) }
        deletedBy?.let { put(Constants.JsonKeys.DELETED_BY, it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ParticipantsRemovedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.VERSION, version)
        removedOn?.let { put(Constants.JsonKeys.REMOVED_ON, it.toString()) }
        put(Constants.JsonKeys.PARTICIPANTS_REMOVED, participantsRemoved?.map { it.toJson() })
        removedBy?.let { put(Constants.JsonKeys.REMOVED_BY, it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ParticipantsAddedEvent.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.THREAD_ID, chatThreadId)
        put(Constants.JsonKeys.VERSION, version)
        addedOn?.let { put(Constants.JsonKeys.ADDED_ON, it.toString()) }
        put(Constants.JsonKeys.PARTICIPANTS_ADDED, participantsAdded?.map { it.toJson() })
        addedBy?.let { put(Constants.JsonKeys.ADDED_BY, it.toJson()) }
    }
    return Json.encodeToString(map)
}

fun ChatMessageReadReceipt.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.SENDER, senderCommunicationIdentifier.toJson())
        put(Constants.JsonKeys.CHAT_MESSAGE_ID, chatMessageId)
        put(Constants.JsonKeys.READ_ON, readOn.toString())
    }
    return Json.encodeToString(map)
}

fun ChatParticipant.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.ID, communicationIdentifier.id())
        displayName?.let { put(Constants.JsonKeys.DISPLAY_NAME, it) }
        shareHistoryTime?.let { put(Constants.JsonKeys.SHARE_HISTORY_TIME, it.toString()) }
    }
    return Json.encodeToString(map)
}

fun ChatMessage.toJson(): String {
    val map = buildMap {
        put(Constants.JsonKeys.ID, id)
        put(Constants.JsonKeys.TYPE, type.toString())
        put(Constants.JsonKeys.VERSION, version)
        put(Constants.JsonKeys.CREATED_ON, createdOn.toString())
        content?.let { put(Constants.JsonKeys.CONTENT, it) }
        senderDisplayName?.let { put(Constants.JsonKeys.SENDER_DISPLAY_NAME, it) }
        senderCommunicationIdentifier?.let { put(Constants.JsonKeys.SENDER, it.toJson()) }
        deletedOn?.let { put(Constants.JsonKeys.DELETED_ON, it.toString()) }
        editedOn?.let { put(Constants.JsonKeys.EDITED_ON, it.toString()) }
        metadata?.let { put(Constants.JsonKeys.METADATA, it) }
    }
    return Json.encodeToString(map)
}