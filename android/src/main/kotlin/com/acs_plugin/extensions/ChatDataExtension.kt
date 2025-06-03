package com.acs_plugin.extensions

import android.R.attr.type
import com.acs_plugin.Constants
import com.acs_plugin.calling.service.sdk.ext.id
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationIdentifier

fun ChatThreadProperties.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.TOPIC] = topic
    map[Constants.JsonKeys.CREATED_ON] = createdOn.toString()
    map[Constants.JsonKeys.CREATED_BY] = createdByCommunicationIdentifier.toMap()
    return map
}

fun CommunicationIdentifier.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.RAW_ID] = rawId
    map[Constants.JsonKeys.KIND] = mapOf("rawValue" to "communicationUser")
    return map
}

fun TypingIndicatorReceivedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.toMap()
    map[Constants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[Constants.JsonKeys.VERSION] = version
    receivedOn?.let { map[Constants.JsonKeys.RECEIVED_ON] = it.toString() }
    senderDisplayName?.let { map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    return map
}

fun ReadReceiptReceivedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.toMap()
    map[Constants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[Constants.JsonKeys.CHAT_MESSAGE_ID] = chatMessageId
    readOn?.let { map[Constants.JsonKeys.READ_ON] = it.toString() }
    return map
}

fun ChatMessageEditedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.toMap()
    map[Constants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = senderDisplayName ?: ""
    map[Constants.JsonKeys.CREATED_ON] = createdOn?.toString() ?: ""
    map[Constants.JsonKeys.VERSION] = version
    map[Constants.JsonKeys.TYPE] = type.toString()
    map[Constants.JsonKeys.MESSAGE] = content
    editedOn?.let { map[Constants.JsonKeys.EDITED_ON] = it.toString() }
    metadata?.let { map[Constants.JsonKeys.METADATA] = it }
    return map
}

fun ChatMessageReceivedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.MESSAGE] = content
    map[Constants.JsonKeys.VERSION] = version
    sender?.let { map[Constants.JsonKeys.SENDER] = it.toMap() }
    recipient?.let { map[Constants.JsonKeys.RECIPIENT] = it.toMap() }
    senderDisplayName?.let { map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    createdOn?.let { map[Constants.JsonKeys.CREATED_ON] = it.toString() }
    map[Constants.JsonKeys.TYPE] = type.toString()
    metadata?.let { map[Constants.JsonKeys.METADATA] = it }
    return map
}

fun ChatMessageDeletedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.SENDER] = sender?.toMap()
    map[Constants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = senderDisplayName ?: ""
    map[Constants.JsonKeys.CREATED_ON] = createdOn?.toString() ?: ""
    map[Constants.JsonKeys.VERSION] = version
    map[Constants.JsonKeys.TYPE] = type.toString()
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    return map
}

fun ChatThreadCreatedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    createdOn?.let { map[Constants.JsonKeys.CREATED_ON] = it.toString() }
    properties?.let { map[Constants.JsonKeys.PROPERTIES] = it.toMap() }
    participants?.let {
        map[Constants.JsonKeys.PARTICIPANTS] =
            it.map { participant -> participant.toMap() }
    }
    createdBy?.let { map[Constants.JsonKeys.CREATED_BY] = it.toMap() }
    return map
}

fun ChatThreadPropertiesUpdatedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    updatedOn?.let { map[Constants.JsonKeys.UPDATED_ON] = it.toString() }
    properties?.let { map[Constants.JsonKeys.PROPERTIES] = it.toMap() }
    updatedBy?.let { map[Constants.JsonKeys.UPDATED_BY] = it.toMap() }
    return map
}

fun ChatThreadDeletedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    deletedBy?.let { map[Constants.JsonKeys.DELETED_BY] = it.toMap() }
    return map
}

fun ParticipantsRemovedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    removedOn?.let { map[Constants.JsonKeys.REMOVED_ON] = it.toString() }
    map[Constants.JsonKeys.PARTICIPANTS_REMOVED] =
        participantsRemoved?.map { it.toMap() }
    removedBy?.let { map[Constants.JsonKeys.REMOVED_BY] = it.toMap() }
    return map
}

fun ParticipantsAddedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.THREAD_ID] = chatThreadId
    map[Constants.JsonKeys.VERSION] = version
    addedOn?.let { map[Constants.JsonKeys.ADDED_ON] = it.toString() }
    map[Constants.JsonKeys.PARTICIPANTS_ADDED] = participantsAdded?.map { it.toMap() }
    addedBy?.let { map[Constants.JsonKeys.ADDED_BY] = it.toMap() }
    return map
}

fun ChatMessageReadReceipt.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.SENDER] = senderCommunicationIdentifier.toMap()
    map[Constants.JsonKeys.CHAT_MESSAGE_ID] = chatMessageId
    map[Constants.JsonKeys.READ_ON] = readOn.toString()
    return map
}

fun ChatParticipant.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = communicationIdentifier.id()
    displayName?.let { map[Constants.JsonKeys.DISPLAY_NAME] = it }
    shareHistoryTime?.let { map[Constants.JsonKeys.SHARE_HISTORY_TIME] = it.toString() }
    return map
}

fun ChatMessage.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.TYPE] = type.toString()
    map[Constants.JsonKeys.VERSION] = version
    map[Constants.JsonKeys.CREATED_ON] = createdOn.toString()
    content?.let { map[Constants.JsonKeys.CONTENT] = it.toMap() }
    senderDisplayName?.let { map[Constants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    senderCommunicationIdentifier?.let { map[Constants.JsonKeys.SENDER] = it.toMap() }
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    editedOn?.let { map[Constants.JsonKeys.EDITED_ON] = it.toString() }
    metadata?.let { map[Constants.JsonKeys.METADATA] = it.toMap() }
    return map
}

fun ChatMessageContent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    message?.let { map[Constants.JsonKeys.MESSAGE] = it }
    topic?.let { map[Constants.JsonKeys.TOPIC] = it }
    participants?.let {
        map[Constants.JsonKeys.PARTICIPANTS] =
            it.map { participant -> participant.toMap() }
    }
    initiatorCommunicationIdentifier?.let {
        map[Constants.JsonKeys.INITIATOR] = it.toMap()
    }
    return map
}

fun ChatThreadItem.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[Constants.JsonKeys.ID] = id
    map[Constants.JsonKeys.TOPIC] = topic
    deletedOn?.let { map[Constants.JsonKeys.DELETED_ON] = it.toString() }
    lastMessageReceivedOn?.let { map[Constants.JsonKeys.RECEIVED_ON] = it.toString() }
    return map
}