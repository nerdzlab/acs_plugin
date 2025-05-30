package com.acs_plugin.handler

import android.content.Context
import android.content.SharedPreferences
import android.util.Log
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
import java.util.*

class ChatHandler(
    private val context: Context,
    private val tokenRefresher: (((String?, Throwable?) -> Unit) -> Unit)?,
    private val onSendEvent: (Event) -> Unit
) : MethodHandler {

    private var chatClient: ChatClient? = null
    private var chatAdapter: ChatAdapter? = null

    private val finishedResults = Collections.synchronizedSet(HashSet<MethodChannel.Result>())

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
        call: MethodCall,
        result: MethodChannel.Result
    ): Boolean {
        val args = call.arguments as? Map<*, *>
        return when (call.method) {
            Constants.MethodChannels.SETUP_CHAT_SERVICE -> {
                val endpoint = args?.get(Constants.Arguments.ENDPOINT) as? String
                if (endpoint != null) {
                    this.chatEndpoint = endpoint
                    setupChatAdapter(endpoint, result)
                } else {
                    handleResultError(result, "INVALID_ARGUMENTS", "Missing 'endpoint'")
                }
                true
            }

            Constants.MethodChannels.INIT_CHAT_THREAD -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId != null) {
                    initializeChatThread(threadId, result)
                } else {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing 'threadId'")
                }
                true
            }

            Constants.MethodChannels.SEND_MESSAGE -> {
                val content = args?.get(Constants.Arguments.CONTENT) as? String
                val senderDisplayName = args?.get(Constants.Arguments.SENDER_DISPLAY_NAME) as? String
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String

                if (content == null || senderDisplayName == null || threadId == null) {
                    handleResultError(
                        result,
                        "MISSING_ARGUMENTS",
                        "Missing 'content', 'senderDisplayName' or 'threadId'"
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
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing 'messageId', 'content' or 'threadId'")
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
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
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
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
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
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
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
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                getInitialMessages(threadId, result)
                true
            }

            Constants.MethodChannels.RETRIEVE_CHAT_THREAD_PROPERTIES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                retrieveChatThreadProperties(threadId, result)
                true
            }

            Constants.MethodChannels.GET_LIST_OF_PARTICIPANTS -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                getListOfParticipants(threadId, result)
                true
            }

            Constants.MethodChannels.GET_PREVIOUS_MESSAGES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                getPreviousMessages(threadId, result)
                true
            }

            Constants.MethodChannels.IS_CHAT_HAS_MORE_MESSAGES -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                isChatHasMoreMessages(threadId, result)
                true
            }

            Constants.MethodChannels.GET_LIST_READ_RECEIPTS -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                getListReadReceipts(threadId, result)
                true
            }

            Constants.MethodChannels.GET_LAST_MESSAGE -> {
                val threadId = args?.get(Constants.Arguments.THREAD_ID) as? String
                if (threadId == null) {
                    handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
                    return true
                }

                getLastMessage(threadId, result)
                true
            }

            else -> {
                try {
                    result.notImplemented()
                } catch (_: Exception) {
                }
                true
            }
        }
    }

    private fun setupChatAdapter(endpoint: String, result: MethodChannel.Result) {
        val userData = userData
        if (userData == null) {
            handleResultError(result, "MISSING_ARGUMENTS", "Missing arguments")
            return
        }

        tokenRefresher?.invoke { token, error ->
            if (error != null) {
                handleResultError(result, "TOKEN_REFRESH_ERROR", error.message)
                return@invoke
            }

            if (token == null) {
                handleResultError(result, "TOKEN_REFRESH_ERROR", "Token is null")
                return@invoke
            }

            CoroutineScope(Dispatchers.IO).launch {
                try {
                    val credential =
                        CommunicationTokenCredential("eyJhbGciOiJSUzI1NiIsImtpZCI6IkRCQTFENTczNEY1MzM4QkRENjRGNjA4NjE2QTQ5NzFCOTEwNjU5QjAiLCJ4NXQiOiIyNkhWYzA5VE9MM1dUMkNHRnFTWEc1RUdXYkEiLCJ0eXAiOiJKV1QifQ.eyJza3lwZWlkIjoiYWNzOjZkMTQxM2NmLTJkMjQtNDE5MS1hNTcwLTExZGE5MTZlODQyNV8wMDAwMDAyNy1iNjUwLWUxODQtNWI0Mi1hZDNhMGQwMDRkNjEiLCJzY3AiOjE3OTIsImNzaSI6IjE3NDg1OTc2MTUiLCJleHAiOjE3NDg2ODQwMTUsInJnbiI6ImRlIiwiYWNzU2NvcGUiOiJjaGF0LHZvaXAiLCJyZXNvdXJjZUlkIjoiNmQxNDEzY2YtMmQyNC00MTkxLWE1NzAtMTFkYTkxNmU4NDI1IiwicmVzb3VyY2VMb2NhdGlvbiI6Imdlcm1hbnkiLCJpYXQiOjE3NDg1OTc2MTV9.MZxMUb3RJc0f2apPtiTotpPj8rHRWhTvs1TPQVQwkJ0AkZ00JViRUKrnn3gzvGGv49ZYGJCBPFXbwPtUxkTJUsNOBKY6iPdFN_IzJXMml-34B_Dc28rb5CBZHTbdEQ6RdZkenjmCPeUq6thSV2w0-CtW_je6sGZtFOxNoQfLwhWGPQhy7ZjVyAnvJnC0Msg_DMqd1zEWk5kcz7BgXdr1zEEKeYaNKH9qaAJqPnmRde9wYzEmQnAG3pez4CT5GfyVsm0dG_aDHo8WrK9-X1jN0JqL7W9XXUsz5JdyfreYM8mi05sw3seEI53Aj2V-k93off0a_3LY2Dm4w4ybj1r8gg")

                    chatClient = ChatClientBuilder().endpoint(endpoint).credential(credential).buildClient()

                    val identifier: CommunicationIdentifier =
                        CommunicationIdentifier.CommunicationUserIdentifier("8:acs:6d1413cf-2d24-4191-a570-11da916e8425_00000027-b650-e184-5b42-ad3a0d004d61")
                    chatClient?.startRealtimeNotifications(context) {}

                    chatAdapter = ChatAdapterBuilder().endpoint(endpoint).identity(identifier).credential(credential)
                        .displayName(userData.name).build()

                    chatAdapter?.connect(context)
                    subscribeToChatEvents()
                    handleResultSuccess(result)
                } catch (e: Exception) {
                    handleResultError(result, "CHAT_SETUP_ERROR", e.message, null)
                }
            }
        }
    }

    private fun initializeChatThread(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                chatClient?.getChatThreadClient(threadId)
                handleResultSuccess(result)
            } catch (e: Exception) {
                handleResultError(result, "CHAT_THREAD_INIT_ERROR", e.message, null)
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
                handleResultSuccess(result)
            } catch (e: Exception) {
                withContext(Dispatchers.Main) {
                    handleResultError(result, "DELETE_MESSAGE_ERROR", e.message, null)
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
                handleResultSuccess(result)
            } catch (e: Exception) {
                handleResultError(result, "EDIT_MESSAGE_ERROR", e.message, null)
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
                handleResultSuccess(result)
            } catch (e: Exception) {
                handleResultError(result, "SEND_MESSAGE_ERROR", e.message, null)
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
                handleResultSuccess(result)
            } catch (e: Exception) {
                handleResultError(result, "SEND_READ_RECEIPT_ERROR", e.message, null)
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
                handleResultSuccess(result)
            } catch (e: Exception) {
                handleResultError(result, "SEND_TYPING_INDICATOR_ERROR", e.message, null)
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
                handleResultSuccess(result)
            } catch (e: Exception) {
                handleResultError(result, "DISCONNECT_CHAT_SERVICE_ERROR", e.message, null)
            }
        }
    }

    private fun getInitialMessages(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                handleResultSuccess(result, messages?.map { it.toJson() })
            } catch (e: Exception) {
                handleResultError(result, "GET_INITIAL_MESSAGES_ERROR", e.message, null)
            }
        }
    }

    private fun retrieveChatThreadProperties(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val properties = chatClient?.getChatThreadClient(threadId)?.properties
                handleResultSuccess(result, properties?.toJson())
            } catch (e: Exception) {
                handleResultError(result, "RETRIEVE_CHAT_THREAD_PROPERTIES_ERROR", e.message, null)
            }
        }
    }

    private fun getPreviousMessages(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                handleResultSuccess(result, messages?.map { it })
            } catch (e: Exception) {
                handleResultError(result, "GET_PREVIOUS_MESSAGES_ERROR", e.message, null)
            }
        }
    }

    private fun getListOfParticipants(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val participants = chatClient?.getChatThreadClient(threadId)?.listParticipants()
                handleResultSuccess(result, participants?.map { it.toJson() })
            } catch (e: Exception) {
                handleResultError(result, "GET_LIST_OF_PARTICIPANTS_ERROR", e.message, null)
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

                handleResultSuccess(result, hasMoreMessages)
            } catch (e: Exception) {
                handleResultError(result, "IS_CHAT_HAS_MORE_MESSAGES_ERROR", e.message, null)
            }
        }
    }

    private fun getListReadReceipts(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val readReceipts = chatThreadClient?.listReadReceipts()
                handleResultSuccess(result, readReceipts?.map { it.toJson() })
            } catch (e: Exception) {
                handleResultError(result, "GET_LIST_READ_RECEIPTS_ERROR", e.message, null)
            }
        }
    }

    private fun getLastMessage(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = chatClient?.getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                val lastMessage = messages?.firstOrNull()
                handleResultSuccess(result, lastMessage?.toJson())
            } catch (e: Exception) {
                handleResultError(result, "GET_LAST_MESSAGE_ERROR", e.message, null)
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
                        payload = (payload as ChatMessageDeletedEvent).toJson()
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

    private fun isFinished(result: MethodChannel.Result): Boolean {
        if (finishedResults.contains(result)) {
            return true
        }
        finishedResults.add(result)
        return false
    }

    private fun handleResultError(
        result: MethodChannel.Result,
        errorCode: String,
        errorMessage: String?,
        errorDetails: Any? = null
    ) {
        Log.e("ChatHandler", "$errorCode - $errorMessage")
        CoroutineScope(Dispatchers.Main).launch {
            try {
                if (!isFinished(result)) {
                    result.error(errorCode, errorMessage, errorDetails)
                }
            } catch (ex: Exception) {
            }
        }
    }

    private suspend fun handleResultSuccess(result: MethodChannel.Result, data: Any? = null) {
        Log.v("ChatHandler", "Success result: $data")
        withContext(Dispatchers.Main) {
            if (!isFinished(result))
                result.success(data)
        }
    }
}