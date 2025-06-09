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
import com.acs_plugin.extensions.toMap
import com.azure.android.communication.chat.ChatClient
import com.azure.android.communication.chat.ChatClientBuilder
import com.azure.android.communication.chat.ChatThreadClient
import com.azure.android.communication.chat.models.*
import com.azure.android.communication.common.CommunicationTokenCredential
import com.azure.android.core.util.RequestContext
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
    private val onSendEvent: (Event) -> Unit
) : MethodHandler {

    private var chatClient: ChatClient? = null
    private var chatAdapter: ChatAdapter? = null

    private val finishedResults = Collections.synchronizedSet(HashSet<MethodChannel.Result>())

    private val chatThreadClients = Collections.synchronizedMap(HashMap<String, ChatThreadClient>())

    private var pagingContinuationToken: String? = null
    private var allPagesFetched = false

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

                isChatHasMoreMessages(result)
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

            Constants.MethodChannels.GET_INITIAL_LIST_THREADS -> {
                getInitialListThreads(result)
                true
            }

            Constants.MethodChannels.GET_NEXT_THREADS -> {
                getNextThreads(result)
                true
            }

            Constants.MethodChannels.IS_MORE_THREADS_AVAILABLE -> {
                isMoreThreadsAvailable(result)
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

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val credential =
                    CommunicationTokenCredential(userData.token)

                chatClient = ChatClientBuilder().endpoint(endpoint).credential(credential).buildClient()

                val identifier: CommunicationIdentifier =
                    CommunicationIdentifier.CommunicationUserIdentifier(userData.userId)
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

    private fun initializeChatThread(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                getChatThreadClient(threadId)
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
                val chatThreadClient = getChatThreadClient(threadId)
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
                val chatThreadClient = getChatThreadClient(threadId)
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
                val chatThreadClient = getChatThreadClient(threadId)
                val sendMessageResult = chatThreadClient?.sendMessage(SendChatMessageOptions().apply {
                    setContent(content)
                    setSenderDisplayName(senderDisplayName)
                    setType(type?.into())
                    setMetadata(metadata)
                })
                handleResultSuccess(result, sendMessageResult?.id)
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
                val chatThreadClient = getChatThreadClient(threadId)
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
                val chatThreadClient = getChatThreadClient(threadId)
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
        // Reset pagination state
        pagingContinuationToken = null
        allPagesFetched = false

        CoroutineScope(Dispatchers.IO).launch {
            try {
                val threadClient = getChatThreadClient(threadId)
                var messages = emptyList<Map<String, Any?>>()
                var throwable: Throwable? = null

                try {
                    val options = ListChatMessagesOptions().apply { setMaxPageSize(200) }
                    val pagedIterable = threadClient?.listMessages(options, RequestContext.NONE)
                    val pagedResponse = pagedIterable?.byPage(null) // Start from the beginning

                    val response = pagedResponse?.iterator()?.next()
                    response?.apply {
                        if (continuationToken == null) {
                            allPagesFetched = true
                        }
                        pagingContinuationToken = continuationToken
                        messages = elements.map { it.toMap() }
                    }
                } catch (ex: Exception) {
                    throwable = ex
                }

                if (throwable != null) {
                    handleResultError(result, "GET_INITIAL_MESSAGES_ERROR", throwable.message, null)
                } else {
                    handleResultSuccess(result, messages)
                }
            } catch (e: Exception) {
                handleResultError(result, "GET_INITIAL_MESSAGES_ERROR", e.message, null)
            }
        }
    }

    private fun retrieveChatThreadProperties(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val properties = getChatThreadClient(threadId)?.properties
                handleResultSuccess(result, properties?.toMap())
            } catch (e: Exception) {
                handleResultError(result, "RETRIEVE_CHAT_THREAD_PROPERTIES_ERROR", e.message, null)
            }
        }
    }

    private fun getPreviousMessages(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val threadClient = getChatThreadClient(threadId)
                var messages = emptyList<Map<String, Any?>>()
                var throwable: Throwable? = null

                if (!allPagesFetched) {
                    try {
                        val options = ListChatMessagesOptions().apply { setMaxPageSize(200) }
                        val pagedIterable = threadClient?.listMessages(options, RequestContext.NONE)
                        val pagedResponse = pagedIterable?.byPage(pagingContinuationToken)

                        val response = pagedResponse?.iterator()?.next()
                        response?.apply {
                            if (continuationToken == null) {
                                allPagesFetched = true
                            }
                            pagingContinuationToken = continuationToken
                            messages = elements.map { it.toMap() }
                        }
                    } catch (ex: Exception) {
                        throwable = ex
                    }
                }

                if (throwable != null) {
                    handleResultError(result, "GET_PREVIOUS_MESSAGES_ERROR", throwable.message, null)
                } else {
                    handleResultSuccess(result, messages)
                }
            } catch (e: Exception) {
                handleResultError(result, "GET_PREVIOUS_MESSAGES_ERROR", e.message, null)
            }
        }
    }

    private fun getListOfParticipants(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val participants = getChatThreadClient(threadId)?.listParticipants()
                handleResultSuccess(result, participants?.map { it.toMap() })
            } catch (e: Exception) {
                handleResultError(result, "GET_LIST_OF_PARTICIPANTS_ERROR", e.message, null)
            }
        }
    }

    private fun isChatHasMoreMessages(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                handleResultSuccess(result, !allPagesFetched)
            } catch (e: Exception) {
                handleResultError(result, "IS_CHAT_HAS_MORE_MESSAGES_ERROR", e.message, null)
            }
        }
    }

    private fun getListReadReceipts(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = getChatThreadClient(threadId)
                val readReceipts = chatThreadClient?.listReadReceipts()
                handleResultSuccess(result, readReceipts?.byPage()?.firstOrNull()?.value?.map { it.toMap() })
            } catch (e: Exception) {
                handleResultError(result, "GET_LIST_READ_RECEIPTS_ERROR", e.message, null)
            }
        }
    }

    private fun getLastMessage(threadId: String, result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val chatThreadClient = getChatThreadClient(threadId)
                val messages = chatThreadClient?.listMessages()
                val lastMessage = messages?.firstOrNull()
                handleResultSuccess(result, lastMessage?.toMap())
            } catch (e: Exception) {
                handleResultError(result, "GET_LAST_MESSAGE_ERROR", e.message, null)
            }
        }
    }

    private fun getInitialListThreads(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                val threads = chatClient?.listChatThreads()
                handleResultSuccess(
                    result,
                    threads?.byPage()?.flatMap { it.value.map { chatThreadItem -> chatThreadItem.toMap() } })
            } catch (e: Exception) {
                handleResultError(result, "GET_INITIAL_LIST_THREADS_ERROR", e.message, null)
            }
        }
    }

    private fun getNextThreads(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
                // If we don't have a saved collection, get initial threads
//                if (threadsPagedIterable == null) {
//                    getInitialListThreads(result)
//                    return@launch
//                }
//
//                // Get the iterator if we haven't already
//                val iterator = threadsPagedIterable?.iterator()
//
//                if (iterator?.hasNext() == false) {
//                    handleResultSuccess(result, emptyList<Map<String, Any>>())
//                    return@launch
//                }
//
//                val threadsPage = iterator?.next()
//                // Map the threads to the same format as in getInitialListThreads
//                val mappedThreads = threadsPage?.toMap()
//
//                handleResultSuccess(result, mappedThreads)

                handleResultSuccess(result, emptyList<Map<String, Any>>())
            } catch (e: Exception) {
                handleResultError(result, "GET_NEXT_THREADS_ERROR", e.message, null)
            }
        }
    }

    private fun isMoreThreadsAvailable(result: MethodChannel.Result) {
        CoroutineScope(Dispatchers.IO).launch {
            try {
//                if (threadsPagedIterable == null) {
//                    handleResultSuccess(result, false)
//                    return@launch
//                }
//
//                val iterator = threadsPagedIterable?.iterator()
//                handleResultSuccess(result, iterator?.hasNext() ?: false)
                handleResultSuccess(result, false)
            } catch (e: Exception) {
                handleResultError(result, "IS_MORE_THREADS_AVAILABLE_ERROR", e.message, null)
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
                        payload = (payload as TypingIndicatorReceivedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.READ_RECEIPT_RECEIVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_READ_RECEIPT_RECEIVED,
                        payload = (payload as ReadReceiptReceivedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_MESSAGE_RECEIVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_MESSAGE_RECEIVED,
                        payload = (payload as ChatMessageReceivedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_MESSAGE_EDITED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_MESSAGE_EDITED,
                        payload = (payload as ChatMessageEditedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_MESSAGE_DELETED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_MESSAGE_DELETED,
                        payload = (payload as ChatMessageDeletedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_THREAD_CREATED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_THREAD_CREATED,
                        payload = (payload as ChatThreadCreatedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_THREAD_PROPERTIES_UPDATED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_THREAD_PROPERTIES_UPDATED,
                        payload = (payload as ChatThreadPropertiesUpdatedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.CHAT_THREAD_DELETED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_CHAT_THREAD_DELETED,
                        payload = (payload as ChatThreadDeletedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.PARTICIPANTS_ADDED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_PARTICIPANTS_ADDED,
                        payload = (payload as ParticipantsAddedEvent).toMap()
                    )
                )
            }

            client.addEventHandler(ChatEventType.PARTICIPANTS_REMOVED.into()) { payload ->
                onSendEvent(
                    Event(
                        name = Constants.FlutterEvents.ON_PARTICIPANTS_REMOVED,
                        payload = (payload as ParticipantsRemovedEvent).toMap()
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
        withContext(Dispatchers.Main) {
            Log.v("ChatHandler", "Success result: $data")
            result.success(data)
        }
    }

    private fun getChatThreadClient(threadId: String): ChatThreadClient? {
        return chatThreadClients[threadId] ?: chatClient?.getChatThreadClient(threadId)?.also {
            chatThreadClients[threadId] = it
        }
    }
}