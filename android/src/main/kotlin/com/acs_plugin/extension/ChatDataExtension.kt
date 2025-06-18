package com.acs_plugin.extension

import com.acs_plugin.consts.PluginConstants
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationIdentifier

fun ChatThreadProperties.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.ID] = id
    map[PluginConstants.JsonKeys.TOPIC] = topic
    map[PluginConstants.JsonKeys.CREATED_ON] = createdOn.toString()
    map[PluginConstants.JsonKeys.CREATED_BY] = createdByCommunicationIdentifier.toMap()
    return map
}

fun CommunicationIdentifier.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.RAW_ID] = rawId
    map[PluginConstants.JsonKeys.KIND] = mapOf("rawValue" to "communicationUser")
    return map
}

fun TypingIndicatorReceivedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.SENDER] = sender?.toMap()
    map[PluginConstants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[PluginConstants.JsonKeys.VERSION] = version
    receivedOn?.let { map[PluginConstants.JsonKeys.RECEIVED_ON] = it.toString() }
    senderDisplayName?.let { map[PluginConstants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    return map
}

fun ReadReceiptReceivedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.SENDER] = sender?.toMap()
    map[PluginConstants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[PluginConstants.JsonKeys.CHAT_MESSAGE_ID] = chatMessageId
    readOn?.let { map[PluginConstants.JsonKeys.READ_ON] = it.toString() }
    return map
}

fun ChatMessageEditedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.SENDER] = sender?.toMap()
    map[PluginConstants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[PluginConstants.JsonKeys.ID] = id
    map[PluginConstants.JsonKeys.SENDER_DISPLAY_NAME] = senderDisplayName ?: ""
    map[PluginConstants.JsonKeys.CREATED_ON] = createdOn?.toString() ?: ""
    map[PluginConstants.JsonKeys.VERSION] = version
    map[PluginConstants.JsonKeys.MESSAGE] = content
    editedOn?.let { map[PluginConstants.JsonKeys.EDITED_ON] = it.toString() }
    metadata?.let { map[PluginConstants.JsonKeys.METADATA] = it }
    return map
}

fun ChatMessageReceivedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.ID] = id
    map[PluginConstants.JsonKeys.MESSAGE] = content
    map[PluginConstants.JsonKeys.VERSION] = version
    sender?.let { map[PluginConstants.JsonKeys.SENDER] = it.toMap() }
    recipient?.let { map[PluginConstants.JsonKeys.RECIPIENT] = it.toMap() }
    senderDisplayName?.let { map[PluginConstants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    createdOn?.let { map[PluginConstants.JsonKeys.CREATED_ON] = it.toString() }
    map[PluginConstants.JsonKeys.TYPE] = type.toString()
    metadata?.let { map[PluginConstants.JsonKeys.METADATA] = it }
    return map
}

fun ChatMessageDeletedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.SENDER] = sender?.toMap()
    map[PluginConstants.JsonKeys.RECIPIENT] = recipient?.toMap()
    map[PluginConstants.JsonKeys.ID] = id
    map[PluginConstants.JsonKeys.SENDER_DISPLAY_NAME] = senderDisplayName ?: ""
    map[PluginConstants.JsonKeys.CREATED_ON] = createdOn?.toString() ?: ""
    map[PluginConstants.JsonKeys.VERSION] = version
    deletedOn?.let { map[PluginConstants.JsonKeys.DELETED_ON] = it.toString() }
    return map
}

fun ChatThreadCreatedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.VERSION] = version
    createdOn?.let { map[PluginConstants.JsonKeys.CREATED_ON] = it.toString() }
    properties?.let { map[PluginConstants.JsonKeys.PROPERTIES] = it.toMap() }
    participants?.let {
        map[PluginConstants.JsonKeys.PARTICIPANTS] =
            it.map { participant -> participant.toMap() }
    }
    createdBy?.let { map[PluginConstants.JsonKeys.CREATED_BY] = it.toMap() }
    return map
}

fun ChatThreadPropertiesUpdatedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.VERSION] = version
    updatedOn?.let { map[PluginConstants.JsonKeys.UPDATED_ON] = it.toString() }
    properties?.let { map[PluginConstants.JsonKeys.PROPERTIES] = it.toMap() }
    updatedBy?.let { map[PluginConstants.JsonKeys.UPDATED_BY] = it.toMap() }
    return map
}

fun ChatThreadDeletedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.VERSION] = version
    deletedOn?.let { map[PluginConstants.JsonKeys.DELETED_ON] = it.toString() }
    deletedBy?.let { map[PluginConstants.JsonKeys.DELETED_BY] = it.toMap() }
    return map
}

fun ParticipantsRemovedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.VERSION] = version
    removedOn?.let { map[PluginConstants.JsonKeys.REMOVED_ON] = it.toString() }
    map[PluginConstants.JsonKeys.PARTICIPANTS_REMOVED] =
        participantsRemoved?.map { it.toMap() }
    removedBy?.let { map[PluginConstants.JsonKeys.REMOVED_BY] = it.toMap() }
    return map
}

fun ParticipantsAddedEvent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.THREAD_ID] = chatThreadId
    map[PluginConstants.JsonKeys.VERSION] = version
    addedOn?.let { map[PluginConstants.JsonKeys.ADDED_ON] = it.toString() }
    map[PluginConstants.JsonKeys.PARTICIPANTS_ADDED] = participantsAdded?.map { it.toMap() }
    addedBy?.let { map[PluginConstants.JsonKeys.ADDED_BY] = it.toMap() }
    return map
}

fun ChatMessageReadReceipt.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.SENDER] = senderCommunicationIdentifier.toMap()
    map[PluginConstants.JsonKeys.CHAT_MESSAGE_ID] = chatMessageId
    map[PluginConstants.JsonKeys.READ_ON] = readOn.toString()
    return map
}

fun ChatParticipant.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.ID] = communicationIdentifier.toMap()
    displayName?.let { map[PluginConstants.JsonKeys.DISPLAY_NAME] = it }
    shareHistoryTime?.let { map[PluginConstants.JsonKeys.SHARE_HISTORY_TIME] = it.toString() }
    return map
}

fun ChatMessage.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.ID] = id
    map[PluginConstants.JsonKeys.TYPE] = type.toString()
    map[PluginConstants.JsonKeys.VERSION] = version
    map[PluginConstants.JsonKeys.CREATED_ON] = createdOn.toString()
    content?.let { map[PluginConstants.JsonKeys.CONTENT] = it.toMap() }
    senderDisplayName?.let { map[PluginConstants.JsonKeys.SENDER_DISPLAY_NAME] = it }
    senderCommunicationIdentifier?.let { map[PluginConstants.JsonKeys.SENDER] = it.toMap() }
    deletedOn?.let { map[PluginConstants.JsonKeys.DELETED_ON] = it.toString() }
    editedOn?.let { map[PluginConstants.JsonKeys.EDITED_ON] = it.toString() }
    metadata?.let { map[PluginConstants.JsonKeys.METADATA] = it.toMap() }
    return map
}

fun ChatMessageContent.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    message?.let { map[PluginConstants.JsonKeys.MESSAGE] = it }
    topic?.let { map[PluginConstants.JsonKeys.TOPIC] = it }
    participants?.let {
        map[PluginConstants.JsonKeys.PARTICIPANTS] =
            it.map { participant -> participant.toMap() }
    }
    initiatorCommunicationIdentifier?.let {
        map[PluginConstants.JsonKeys.INITIATOR] = it.toMap()
    }
    return map
}

fun ChatThreadItem.toMap(): MutableMap<String, Any?> {
    val map = mutableMapOf<String, Any?>()
    map[PluginConstants.JsonKeys.ID] = id
    map[PluginConstants.JsonKeys.TOPIC] = topic
    deletedOn?.let { map[PluginConstants.JsonKeys.DELETED_ON] = it.toString() }
    lastMessageReceivedOn?.let { map[PluginConstants.JsonKeys.RECEIVED_ON] = it.toString() }
    return map
}