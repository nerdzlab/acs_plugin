package com.acs_plugin.chat.service

import com.acs_plugin.chat.models.MessageInfoModel
import com.acs_plugin.chat.service.sdk.ChatSDK
import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier
import org.threeten.bp.OffsetDateTime

internal class ChatService(private val chatSDK: ChatSDK) {
    fun initialize() = chatSDK.initialization()
    fun destroy() = chatSDK.destroy()
    fun getAdminUserId(): String? = chatSDK.getAdminUserId()
    fun requestPreviousPage() = chatSDK.requestPreviousPage()
    fun requestChatParticipants() = chatSDK.requestChatParticipants()

    fun startEventNotifications() = chatSDK.startEventNotifications()
    fun stopEventNotifications() = chatSDK.stopEventNotifications()

    fun getChatStatusStateFlow() = chatSDK.getChatStatusStateFlow()
    fun getMessagesPageSharedFlow() = chatSDK.getMessagesPageSharedFlow()
    fun getChatEventSharedFlow() = chatSDK.getChatEventSharedFlow()

    fun sendMessage(
        messageInfoModel: MessageInfoModel,
    ) = chatSDK.sendMessage(messageInfoModel = messageInfoModel)

    fun deleteMessage(id: String) = chatSDK.deleteMessage(id = id)
    fun editMessage(id: String, content: String) = chatSDK.editMessage(id = id, content = content)
    fun sendTypingIndicator() = chatSDK.sendTypingIndicator()
    fun sendReadReceipt(id: String) = chatSDK.sendReadReceipt(id = id)
    fun removeParticipant(communicationIdentifier: CommunicationIdentifier) =
        chatSDK.removeParticipant(communicationIdentifier = communicationIdentifier)

    fun fetchMessages(from: OffsetDateTime?) = chatSDK.fetchMessages(from = from)
}
