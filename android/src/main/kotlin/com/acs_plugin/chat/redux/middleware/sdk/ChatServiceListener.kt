package com.acs_plugin.chat.redux.middleware.sdk

import com.acs_plugin.chat.models.ChatCompositeErrorCode
import com.acs_plugin.chat.models.ChatCompositeErrorEvent
import com.acs_plugin.chat.models.ChatEventModel
import com.acs_plugin.chat.models.ChatThreadInfoModel
import com.acs_plugin.chat.models.LocalParticipantInfoModel
import com.acs_plugin.chat.models.MessageInfoModel
import com.acs_plugin.chat.models.MessagesPageModel
import com.acs_plugin.chat.models.ParticipantTimestampInfoModel
import com.acs_plugin.chat.models.RemoteParticipantsInfoModel
import com.acs_plugin.chat.redux.Dispatch
import com.acs_plugin.chat.redux.Store
import com.acs_plugin.chat.redux.action.ChatAction
import com.acs_plugin.chat.redux.action.ErrorAction
import com.acs_plugin.chat.redux.action.ParticipantAction
import com.acs_plugin.chat.redux.state.ChatStatus
import com.acs_plugin.chat.redux.state.ReduxState
import com.acs_plugin.chat.service.ChatService
import com.acs_plugin.chat.service.sdk.wrapper.ChatEventType
import com.acs_plugin.chat.utilities.CoroutineContextProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.cancel
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch

// Listens to Events from SDK and Dispatches actions
// Service -> Redux
internal class ChatServiceListener(
    private val chatService: ChatService,
    coroutineContextProvider: CoroutineContextProvider,
) {
    private val coroutineScope = CoroutineScope(coroutineContextProvider.Default)
    private val typingIndicatorDuration = 8000L

    fun subscribe(store: Store<ReduxState>) {
        val dispatch = store::dispatch
        coroutineScope.launch {
            chatService.getChatStatusStateFlow()?.collect {
                when (it) {
                    ChatStatus.INITIALIZATION -> dispatch(ChatAction.Initialization())
                    ChatStatus.INITIALIZED -> dispatch(ChatAction.Initialized())
                    else -> {}
                }
            }
        }

        coroutineScope.launch {
            chatService.getMessagesPageSharedFlow()?.collect {
                val threadId = store.getCurrentState().chatState.chatInfoModel.threadId
                onMessagesPageModelReceived(messagesPageModel = it, dispatch = dispatch, threadId)
            }
        }

        coroutineScope.launch {
            chatService.getChatEventSharedFlow()?.collect {
                handleInfoModel(
                    it,
                    dispatch,
                    store.getCurrentState().participantState.localParticipantInfoModel
                )
            }
        }
    }

    fun unsubscribe() {
        chatService.stopEventNotifications()
        coroutineScope.cancel()
    }

    private fun onMessagesPageModelReceived(
        messagesPageModel: MessagesPageModel,
        dispatch: Dispatch,
        threadId: String
    ) {

        messagesPageModel.throwable?.let {
            val error = ChatCompositeErrorEvent(threadId, ChatCompositeErrorCode.FETCH_MESSAGES_FAILED, null)
            // TODO: lets use only one action and state to fire error for timing
            // TODO: while working on error stories, we can create separate states for every error
            dispatch(ErrorAction.ChatStateErrorOccurred(chatCompositeErrorEvent = error))
        }

        messagesPageModel.messages?.let {
            val id = chatService.getAdminUserId()
            dispatch(ChatAction.MessagesPageReceived(messages = it))
        }

        if (messagesPageModel.allPagesFetched) {
            dispatch(ChatAction.AllMessagesFetched())
        }
    }

    private fun handleInfoModel(
        it: ChatEventModel,
        dispatch: Dispatch,
        localParticipantInfoModel: LocalParticipantInfoModel,
    ) {
        when (it.infoModel) {
            is MessageInfoModel -> {
                when (it.eventType) {
                    ChatEventType.CHAT_MESSAGE_RECEIVED -> {
                        val infoModel = it.infoModel
                        dispatch(ChatAction.MessageReceived(message = infoModel))
                    }
                    ChatEventType.CHAT_MESSAGE_EDITED -> {
                        dispatch(ChatAction.MessageEdited(message = it.infoModel))
                    }
                    ChatEventType.CHAT_MESSAGE_DELETED -> {
                        dispatch(ChatAction.MessageDeleted(message = it.infoModel))
                    }
                    else -> {}
                }
            }
            is ParticipantTimestampInfoModel -> {
                when (it.eventType) {
                    ChatEventType.TYPING_INDICATOR_RECEIVED -> {
                        val infoModel = it.infoModel
                        dispatch(ParticipantAction.AddParticipantTyping(infoModel = infoModel))
                        coroutineScope.launch {
                            delay(typingIndicatorDuration)
                            dispatch(
                                ParticipantAction.RemoveParticipantTyping(infoModel = infoModel)
                            )
                        }
                    }
                    ChatEventType.READ_RECEIPT_RECEIVED -> {
                        val infoModel = it.infoModel
                        dispatch(ParticipantAction.ReadReceiptReceived(infoModel = infoModel))
                    }
                    else -> {}
                }
            }
            is ChatThreadInfoModel -> {
                when (it.eventType) {
                    ChatEventType.CHAT_THREAD_DELETED -> {
                        dispatch(ChatAction.ThreadDeleted())
                    }
                    ChatEventType.CHAT_THREAD_PROPERTIES_UPDATED -> {
                        it.infoModel.topic?.let {
                            dispatch(ChatAction.TopicUpdated(it))
                        }
                    }
                    else -> {}
                }
            }
            is RemoteParticipantsInfoModel -> {
                when (it.eventType) {
                    ChatEventType.PARTICIPANTS_ADDED -> {
                        // remove admin user from chat
                        val joinedParticipants =
                            it.infoModel.participants.filter { it.userIdentifier.id != chatService.getAdminUserId() }
                        dispatch(ParticipantAction.ParticipantsAdded(participants = joinedParticipants))
                    }
                    ChatEventType.PARTICIPANTS_REMOVED -> {

                        dispatch(
                            ParticipantAction.ParticipantsRemoved(
                                participants = it.infoModel.participants
                            )
                        )
                    }
                    else -> {}
                }
            }
        }
    }
}
