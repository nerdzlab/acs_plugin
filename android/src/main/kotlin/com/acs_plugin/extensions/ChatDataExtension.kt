package com.acs_plugin.extensions

import android.R.attr.type
import com.acs_plugin.Constants
import com.acs_plugin.calling.service.sdk.ext.id
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationIdentifier

fun ChatThreadProperties.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.TOPIC] = topic
    map[Constants.JsonKeys.CREATED_ON] = createdOn.toString()
    map[Constants.JsonKeys.CREATED_BY] = gson.fromJson(createdByCommunicationIdentifier.toJson(), Map::class.java)
    return gson.toJson(map)
}

fun CommunicationIdentifier.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.RAW_ID] = rawId
    map[Constants.JsonKeys.KIND] = "communicationUser"
    return gson.toJson(map)
}

fun TypingIndicatorReceivedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.RECIPIENT] = recipient?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.VERSION] = version
    receivedOn?.let { map[Constants.JsonKeys.RECEIVED_ON] = it.toString() }
    senderDisplayName?.let { map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    return gson.toJson(map)
}

fun ReadReceiptReceivedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.RECIPIENT] = recipient?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.CHAT_MESSAGE_ID] = chatMessageId
    readOn?.let { map[Constants.JsonKeys.READ_ON] = it.toString() }
    return gson.toJson(map)
}

fun ChatMessageEditedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.RECIPIENT] = recipient?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = senderDisplayName ?: ""
    map[Constants.JsonKeys.CREATED_ON] = createdOn?.toString() ?: ""
    map[Constants.JsonKeys.VERSION] = version
    map[Constants.JsonKeys.TYPE] = type.toString()
    map[Constants.JsonKeys.MESSAGE] = content
    editedOn?.let { map[Constants.JsonKeys.EDITED_ON] = it.toString() }
    metadata?.let { map[Constants.JsonKeys.METADATA] = it }
    return gson.toJson(map)
}

fun ChatMessageReceivedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.MESSAGE] = content
    map[Constants.JsonKeys.VERSION] = version
    sender?.let { map[Constants.JsonKeys.SENDER] = gson.fromJson(it.toJson(), Map::class.java) }
    recipient?.let { map[Constants.JsonKeys.RECIPIENT] = gson.fromJson(it.toJson(), Map::class.java) }
    senderDisplayName?.let { map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    createdOn?.let { map[Constants.JsonKeys.CREATED_ON] = it.toString() }
    map[Constants.JsonKeys.TYPE] = type.toString()
    metadata?.let { map[Constants.JsonKeys.METADATA] = it }
    return gson.toJson(map)
}

fun ChatMessageDeletedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.RECIPIENT] = recipient?.let { gson.fromJson(it.toJson(), Map::class.java) }
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = senderDisplayName ?: ""
    map[Constants.JsonKeys.CREATED_ON] = createdOn?.toString() ?: ""
    map[Constants.JsonKeys.VERSION] = version
    map[Constants.JsonKeys.TYPE] = type.toString()
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    return gson.toJson(map)
}

fun ChatThreadCreatedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    createdOn?.let { map[Constants.JsonKeys.CREATED_ON] = it.toString() }
    properties?.let { map[Constants.JsonKeys.PROPERTIES] = gson.fromJson(it.toJson(), Map::class.java) }
    participants?.let {
        map[Constants.JsonKeys.PARTICIPANTS] =
            it.map { participant -> gson.fromJson(participant.toJson(), Map::class.java) }
    }
    createdBy?.let { map[Constants.JsonKeys.CREATED_BY] = gson.fromJson(it.toJson(), Map::class.java) }
    return gson.toJson(map)
}

fun ChatThreadPropertiesUpdatedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    updatedOn?.let { map[Constants.JsonKeys.UPDATED_ON] = it.toString() }
    properties?.let { map[Constants.JsonKeys.PROPERTIES] = gson.fromJson(it.toJson(), Map::class.java) }
    updatedBy?.let { map[Constants.JsonKeys.UPDATED_BY] = gson.fromJson(it.toJson(), Map::class.java) }
    return gson.toJson(map)
}

fun ChatThreadDeletedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    deletedBy?.let { map[Constants.JsonKeys.DELETED_BY] = gson.fromJson(it.toJson(), Map::class.java) }
    return gson.toJson(map)
}

fun ParticipantsRemovedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    removedOn?.let { map[Constants.JsonKeys.REMOVED_ON] = it.toString() }
    map[Constants.JsonKeys.PARTICIPANTS_REMOVED] =
        participantsRemoved?.map { gson.fromJson(it.toJson(), Map::class.java) }
    removedBy?.let { map[Constants.JsonKeys.REMOVED_BY] = gson.fromJson(it.toJson(), Map::class.java) }
    return gson.toJson(map)
}

fun ParticipantsAddedEvent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    addedOn?.let { map[Constants.JsonKeys.ADDED_ON] = it.toString() }
    map[Constants.JsonKeys.PARTICIPANTS_ADDED] = participantsAdded?.map { gson.fromJson(it.toJson(), Map::class.java) }
    addedBy?.let { map[Constants.JsonKeys.ADDED_BY] = gson.fromJson(it.toJson(), Map::class.java) }
    return gson.toJson(map)
}

fun ChatMessageReadReceipt.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.SENDER] = gson.fromJson(senderCommunicationIdentifier.toJson(), Map::class.java)
    map[Constants.JsonKeys.CHAT_MESSAGE_ID] = chatMessageId
    map[Constants.JsonKeys.READ_ON] = readOn.toString()
    return gson.toJson(map)
}

fun ChatParticipant.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = communicationIdentifier.id()
    displayName?.let { map[Constants.JsonKeys.DISPLAY_NAME] = it }
    shareHistoryTime?.let { map[Constants.JsonKeys.SHARE_HISTORY_TIME] = it.toString() }
    return gson.toJson(map)
}

fun ChatMessage.toJson(): MutableMap<String, Any?> {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.TYPE] = type.toString()
    map[Constants.JsonKeys.VERSION] = version
    map[Constants.JsonKeys.CREATED_ON] = createdOn.toString()
    content?.let { map[Constants.JsonKeys.CONTENT] = gson.fromJson(it.toJson(), Map::class.java) }
    senderDisplayName?.let { map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    senderCommunicationIdentifier?.let { map[Constants.JsonKeys.SENDER] = gson.fromJson(it.toJson(), Map::class.java) }
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    editedOn?.let { map[Constants.JsonKeys.EDITED_ON] = it.toString() }
    metadata?.let { map[Constants.JsonKeys.METADATA] = gson.fromJson(gson.toJson(it), Map::class.java) }
    return map
}

fun ChatMessageContent.toJson(): String {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    message?.let { map[Constants.JsonKeys.MESSAGE] = it }
    topic?.let { map[Constants.JsonKeys.TOPIC] = it }
    participants?.let {
        map[Constants.JsonKeys.PARTICIPANTS] =
            it.map { participant -> gson.fromJson(participant.toJson(), Map::class.java) }
    }
    initiatorCommunicationIdentifier?.let {
        map[Constants.JsonKeys.INITIATOR] = gson.fromJson(it.toJson(), Map::class.java)
    }
    return gson.toJson(map)
}

fun ChatThreadItem.toJson(): MutableMap<String, Any?> {
    val gson = com.google.gson.Gson()
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.TOPIC] = topic
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    lastMessageReceivedOn?.let { map[Constants.JsonKeys.RECEIVED_ON] = it.toString() }
    return map
}

