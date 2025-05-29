package com.acs_plugin.handler

import android.content.Context
import android.content.SharedPreferences
import androidx.core.content.edit
import com.acs_plugin.Constants
import com.acs_plugin.chat.ChatAdapter
import com.acs_plugin.chat.ChatAdapterBuilder
import com.acs_plugin.chat.service.sdk.wrapper.ChatEventType
import com.acs_plugin.chat.service.sdk.wrapper.ChatMessageType
import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier
import com.acs_plugin.chat.service.sdk.wrapper.into
import com.acs_plugin.data.Event
import com.acs_plugin.data.UserData
import com.acs_plugin.extensions.toJson
import com.azure.android.communication.chat.ChatClient
import com.azure.android.communication.chat.ChatClientBuilder
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationTokenCredential
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json

class ChatHandler(
    private val context: Context,
    private val tokenRefresher: (((String?, Throwable?) -> Unit) -> Unit)?,
    private val onSendEvent: (Event) -> Unit
) : MethodHandler {

    private var chatClient: ChatClient? = null
    private var chatAdapter: ChatAdapter? = null

    private val sharedPreferences: SharedPreferences by lazy {
        context.getSharedPreferences(Constants.Prefs.PREFS_NAME, Context.MODE_PRIVATE)
    }

    private val userData: UserData?
        get() {
            val json = sharedPreferences.getString(Constants.Prefs.USER_DATA_KEY, null)
            return json?.let {
                try {
                    Json.decodeFromString<UserData>(it)
                } catch (_: Exception) {
                    null
                }
            }
        }

    private var chatEndpoint: String?
        get() = sharedPreferences.getString(Constants.Prefs.CHAT_ENDPOINT, null)
        set(value) = sharedPreferences.edit { putString(Constants.Prefs.CHAT_ENDPOINT, value) }

    override fun handle(
        call: MethodCall, result: MethodChannel.Result
    ): Boolean {
        val args = call.arguments as? Map<*, *>
        return when (call.method) {
            Constants.MethodChannels.SETUP_CHAT_SERVICE -> {
                val endpoint = args?.get(Constants.Arguments.ENDPOINT) as? String
                if (endpoint != null) {
                    this.chatEndpoint = endpoint
                    setupChatAdapter(endpoint, result)
                } else {
                    result.error(
                        "INVALID_ARGUMENTS", "Missing 'endpoint'", null
                    )
                }
                true
            }

            Constants.MethodChannels.INIT_CHAT_THREAD -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId != null) {
                    initializeChatThread(threadId, result)
                } else {
                    result.error(
                        "MISSING_ARGUMENTS", "Missing 'threadId'", null
                    )
                }
                true
            }

            Constants.MethodChannels.SEND_MESSAGE -> {
                val content = args?.get(Constants.Arguments.CONTENT) as? String
                val senderDisplayName = args?.get(Constants.Arguments.SENDER_DISPLAY_NAME) as? String
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String

                if (content == null || senderDisplayName == null || threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'content', 'senderDisplayName' or 'threadId'",
                        null
                    )
                    return true
                }

                val type = (args[Constants.Arguments.TYPE] as? String)?.let { ChatMessageType.valueOf(it) }
                val metadata = args[Constants.Arguments.METADATA] as? Map<String, String>

                sendMessage(
                    threadId = threadId,
                    content = content,
                    senderDisplayName = senderDisplayName,
                    type = type,
                    metadata = metadata,
                    result = result
                )
                true
            }

            Constants.MethodChannels.EDIT_MESSAGE -> {
                val messageId = args?.get(Constants.Arguments.MESSAGE_ID) as? String
                val content = args?.get(Constants.Arguments.CONTENT) as? String
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String

                if (messageId == null || content == null || threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'messageId', 'content' or 'threadId'",
                        null
                    )
                    return true
                }

                val metadata = args[Constants.Arguments.METADATA] as? Map<String, String>

                editMessage(
                    threadId = threadId,
                    messageId = messageId,
                    content = content,
                    metadata = metadata,
                    result = result
                )
                true
            }

            Constants.MethodChannels.DELETE_MESSAGE -> {
                val messageId = args?.get(Constants.Arguments.MESSAGE_ID) as? String
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String

                if (messageId == null || threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'messageId' or 'threadId'",
                        null
                    )
                    return true
                }

                deleteMessage(
                    threadId = threadId,
                    messageId = messageId,
                    result = result
                )
                true
            }

            Constants.MethodChannels.SEND_READ_RECEIPT -> {
                val messageId = args?.get(Constants.Arguments.MESSAGE_ID) as? String
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String

                if (messageId == null || threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'messageId' or 'threadId'",
                        null
                    )
                    return true
                }

                sendReadReceipt(
                    threadId = threadId,
                    messageId = messageId,
                    result = result
                )
                true
            }

            Constants.MethodChannels.SEND_TYPING_INDICATOR -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String

                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                sendTypingIndicator(
                    threadId = threadId,
                    result = result
                )
                true
            }

            Constants.MethodChannels.DISCONNECT_CHAT_SERVICE -> {
                disconnectChatService(result)
                true
            }

            Constants.MethodChannels.GET_INITIAL_MESSAGES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                getInitialMessages(threadId, result)
                true
            }

            Constants.MethodChannels.RETRIEVE_CHAT_THREAD_PROPERTIES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                retrieveChatThreadProperties(threadId, result)
                true
            }

            Constants.MethodChannels.GET_LIST_OF_PARTICIPANTS -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                getListOfParticipants(threadId, result)
                true
            }

            Constants.MethodChannels.GET_PREVIOUS_MESSAGES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                getPreviousMessages(threadId, result)
                true
            }

            Constants.MethodChannels.IS_CHAT_HAS_MORE_MESSAGES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                isChatHasMoreMessages(threadId, result)
                true
            }

            Constants.MethodChannels.GET_LIST_READ_RECEIPTS -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                getListReadReceipts(threadId, result)
                true
            }

            Constants.MethodChannels.GET_LAST_MESSAGE -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    result.error(
                        "MISSING_ARGUMENTS",
                        "Missing 'threadId'",
                        null
                    )
                    return true
                }

                getLastMessage(threadId, result)
                true
            }

            else -> false
        }
    }

    private fun setupChatAdapter(endpoint: String, result: MethodChannel.Result) {
        val userData = userData
        if (userData == null) {
            result.error(
                "INVALID_ARGUMENTS", "User data not set", null
            )
            return
        }

        tokenRefresher?.invoke { token, error ->
            if (error != null) {
                result.error(
                    "TOKEN_REFRESH_ERROR", error.message, null
                )
                return@invoke
            }

            if (token == null) {
                result.error(
                    "TOKEN_REFRESH_ERROR", "Token is null", null
                )
                return@invoke
            }

            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val credential = CommunicationTokenCredential(token)

                    chatClient = ChatClientBuilder().endpoint(endpoint).credential(credential).buildClient()

                    val identifier: CommunicationIdentifier =
                        CommunicationIdentifier.CommunicationUserIdentifier(userData.userId)
                    chatClient?.startRealtimeNotifications(context) {}

                    chatAdapter = ChatAdapterBuilder().endpoint(endpoint).identity(identifier).credential(credential)
                        .displayName(userData.name).build()

                    chatAdapter?.connect(context)
                    subscribeToChatEvents()
                    withContext(Dispatchers.Main) {
                        result.success(null)
                    }
                } catch (e: Exception) {
                    withContext(Dispatchers.Main) {
                        result.error(
                            "CHAT_SETUP_ERROR", e.message, null
                        )
                    }
                }
            }
        }
    }

    private fun initializeChatThread(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                chatClient?.getChatThreadClient(threadId)
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "CHAT_THREAD_INIT_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun deleteMessage(
        threadId: String,
        messageId: String,
        result: MethodChannel.Result
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                chatThreadClient?.deleteMessage(messageId)
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "DELETE_MESSAGE_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun editMessage(
        threadId: String,
        messageId: String,
        content: String,
        metadata: Map<String, String>?,
        result: MethodChannel.Result
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                chatThreadClient?.updateMessage(
                    messageId,
                    UpdateChatMessageOptions().apply {
                        setContent(content)
                        setMetadata(metadata)
                    }
                )
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "EDIT_MESSAGE_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun sendMessage(
        threadId: String,
        content: String,
        senderDisplayName: String,
        type: ChatMessageType?,
        metadata: Map<String, String>?,
        result: MethodChannel.Result
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                chatThreadClient?.sendMessage(SendChatMessageOptions().apply {
                    setContent(content)
                    setSenderDisplayName(senderDisplayName)
                    setType(type?.into())
                    setMetadata(metadata)
                })
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "SEND_MESSAGE_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun sendReadReceipt(
        threadId: String,
        messageId: String,
        result: MethodChannel.Result
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                chatThreadClient?.sendReadReceipt(messageId)
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "SEND_READ_RECEIPT_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun sendTypingIndicator(
        threadId: String,
        result: MethodChannel.Result
    ) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                chatThreadClient?.sendTypingNotification()
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "SEND_TYPING_INDICATOR_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun disconnectChatService(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                chatAdapter?.disconnect()
                chatClient?.stopRealtimeNotifications()
                chatAdapter = null
                chatClient = null
                withContext(Dispatchers.Main) {
                    result.success(null)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "DISCONNECT_CHAT_SERVICE_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun getInitialMessages(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                withContext(Dispatchers.Main) {
                    result.success(messages?.map { it.toJson() })
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "GET_INITIAL_MESSAGES_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun retrieveChatThreadProperties(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val properties = chatClient?.getChatThreadClient(threadId)?.properties
                withContext(Dispatchers.Main) {
                    result.success(properties?.toJson())
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "RETRIEVE_CHAT_THREAD_PROPERTIES_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun getPreviousMessages(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                withContext(Dispatchers.Main) {
                    result.success(messages?.map { it })
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "GET_PREVIOUS_MESSAGES_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun getListOfParticipants(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val participants = chatClient?.getChatThreadClient(threadId)?.listParticipants()
                withContext(Dispatchers.Main) {
                    result.success(participants?.map { it.toJson() })
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "GET_LIST_OF_PARTICIPANTS_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun isChatHasMoreMessages(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messageList = chatThreadClient?.listMessages()

                // If we can get a non-null iterator, we can check for more messages
                val iterator = messageList?.iterator()
                var hasMoreMessages = false

                // Check if there are messages and if we can move to the next page
                if (iterator != null && iterator.hasNext()) {
                    // Consume first page
                    while (iterator.hasNext()) {
                        iterator.next()
                    }
                    // Check if there's another page after this
                    hasMoreMessages = iterator.hasNext()
                }

                withContext(Dispatchers.Main) {
                    result.success(hasMoreMessages)
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "IS_CHAT_HAS_MORE_MESSAGES_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun getListReadReceipts(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val readReceipts = chatThreadClient?.listReadReceipts()
                withContext(Dispatchers.Main) {
                    result.success(readReceipts?.map { it.toJson() })
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "GET_LIST_READ_RECEIPTS_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun getLastMessage(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                val lastMessage = messages?.firstOrNull()
                withContext(Dispatchers.Main) {
                    result.success(lastMessage?.toJson())
                }
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    result.error(
                        "GET_LAST_MESSAGE_ERROR",
                        e.message,
                        null
                    )
                }
            }
        }
    }

    private fun subscribeToChatEvents() {
        chatClient?.let { client ->
            // Register real-time notification hooks
            client.addEventHandler(ChatEventType.TYPING_INDICATOR_RECEIVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_TYPING_INDICATOR_RECEIVED,
                        payload = (payload as TypingIndicatorReceivedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.READ_RECEIPT_RECEIVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_READ_RECEIPT_RECEIVED,
                        payload = (payload as ReadReceiptReceivedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_MESSAGE_RECEIVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_MESSAGE_RECEIVED,
                        payload = (payload as ChatMessageReceivedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_MESSAGE_EDITED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_MESSAGE_EDITED,
                        payload = (payload as ChatMessageEditedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_MESSAGE_DELETED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_MESSAGE_DELETED,
                        payload =  (payload as ChatMessageDeletedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_THREAD_CREATED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_THREAD_CREATED,
                        payload = (payload as ChatThreadCreatedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_THREAD_PROPERTIES_UPDATED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_THREAD_PROPERTIES_UPDATED,
                        payload = (payload as ChatThreadPropertiesUpdatedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_THREAD_DELETED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_THREAD_DELETED,
                        payload = (payload as ChatThreadDeletedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.PARTICIPANTS_ADDED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_PARTICIPANTS_ADDED,
                        payload = (payload as ParticipantsAddedEvent).toJson()
                    )
                )
            }

            client.addEventHandler(ChatEventType.PARTICIPANTS_REMOVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_PARTICIPANTS_REMOVED,
                        payload = (payload as ParticipantsRemovedEvent).toJson()
                    )
                )
            }

            // Add connection status change listener
            client.startRealtimeNotifications(context) {
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_REAL_TIME_NOTIFICATION_CONNECTED
                    )
                )
            }
        }
    }

    fun chatPushNotificationOpened(pushNotificationReceivedEvent: PushNotificationChatMessageReceivedEvent) {
        onSendEvent(
            Event(
                name = Constants.FlutterEvents.ON_CHAT_PUSH_NOTIFICATION_OPENED,
                payload = pushNotificationReceivedEvent.toJson()
            )
        )
    }
}