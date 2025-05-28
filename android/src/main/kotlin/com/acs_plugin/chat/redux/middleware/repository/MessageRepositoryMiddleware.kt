package com.acs_plugin.chat.redux.middleware.repository

import com.acs_plugin.chat.models.EMPTY_MESSAGE_INFO_MODEL
import com.acs_plugin.chat.models.MessageInfoModel
import com.acs_plugin.chat.models.MessageSendStatus
import com.acs_plugin.chat.redux.Dispatch
import com.acs_plugin.chat.redux.Middleware
import com.acs_plugin.chat.redux.Store
import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.action.ChatAction
import com.acs_plugin.chat.redux.action.NetworkAction
import com.acs_plugin.chat.redux.action.ParticipantAction
import com.acs_plugin.chat.redux.action.RepositoryAction
import com.acs_plugin.chat.redux.middleware.sdk.ChatMiddleware
import com.acs_plugin.chat.redux.state.ReduxState
import com.acs_plugin.chat.repository.MessageRepository
import com.acs_plugin.chat.service.sdk.wrapper.ChatMessageType
import com.acs_plugin.chat.utilities.findMessageById
import org.threeten.bp.OffsetDateTime

internal interface MessageRepositoryMiddleware

// MessagesRepositoryMiddleware
//
// Manages
// ChatServiceListener (Service -> Redux)
// ChatActionHandler (Redux -> Service)
internal class MessageRepositoryMiddlewareImpl(
    private val messageRepository: MessageRepository,
) :
    Middleware<ReduxState>,
    ChatMiddleware,
    MessageRepositoryMiddleware {

    override fun invoke(store: Store<ReduxState>) = { next: Dispatch ->
        { action: Action ->
            when (action) {
                is ChatAction.SendMessage -> processSendMessage(action, store::dispatch)
                is ChatAction.MessageSent -> processMessageSent(action, store::dispatch)
                is ChatAction.MessageSentFailed -> processMessageSentFailed(action, store::dispatch)
                is ChatAction.MessagesPageReceived -> processPageReceived(action, store::dispatch)
                is ChatAction.MessageReceived -> processMessageReceived(action, store::dispatch)
                is ChatAction.MessageDeleted -> processDeletedMessage(action, store::dispatch)
                is ChatAction.MessageEdited -> processEditMessage(action, store::dispatch)
                is ParticipantAction.ParticipantsAdded -> processParticipantsAdded(
                    action,
                    store::dispatch
                )
                is ParticipantAction.ParticipantsRemoved -> {
                    if (action.participants.any { it.isLocalUser }) {
                        processLocalParticipantRemoved(store::dispatch)
                    } else {
                        processParticipantsRemoved(action, store::dispatch)
                    }
                }
                is NetworkAction.Disconnected -> processNetworkDisconnected(store::dispatch)
            }

            // Pass Action down the chain
            next(action)
        }
    }

    private fun processNetworkDisconnected(
        dispatch: Dispatch,
    ) {
        messageRepository.get(messageRepository.size - 1)?.let { messageInfoModel ->
            val offsetDateTime = messageInfoModel.deletedOn ?: messageInfoModel.editedOn
                ?: messageInfoModel.createdOn
            offsetDateTime?.let {
                dispatch(NetworkAction.SetDisconnectedOffset(it))
            }
        }
    }

    private fun processMessageReceived(
        action: ChatAction.MessageReceived,
        dispatch: Dispatch,
    ) {
        val oldMessage = messageRepository.findMessageById(action.message.normalizedID)
        if (oldMessage == EMPTY_MESSAGE_INFO_MODEL) {
            messageRepository.addMessage(action.message)
        } else {
            messageRepository.replaceMessage(
                oldMessage,
                action.message
            )
        }

        notifyUpdate(dispatch)
    }

    // Before the hits the server
    private fun processSendMessage(
        action: ChatAction.SendMessage,
        dispatch: Dispatch,
    ) {
        messageRepository.addMessage(action.messageInfoModel)
        notifyUpdate(dispatch)
    }

    private fun processMessageSent(
        action: ChatAction.MessageSent,
        dispatch: Dispatch,
    ) {
        messageRepository.removeMessage(action.messageInfoModel)
        messageRepository.addMessage(
            action.messageInfoModel.copy(
                id = action.id,
                sendStatus = MessageSendStatus.SENT
            )
        )
        notifyUpdate(dispatch)
    }

    private fun processMessageSentFailed(
        action: ChatAction.MessageSentFailed,
        dispatch: Dispatch,
    ) {
        messageRepository.replaceMessage(
            action.messageInfoModel,
            action.messageInfoModel.copy(
                sendStatus = MessageSendStatus.FAILED
            )
        )
        notifyUpdate(dispatch)
    }

    private fun processPageReceived(
        action: ChatAction.MessagesPageReceived,
        dispatch: Dispatch,
    ) {
        messageRepository.addPage(action.messages.reversed())
        notifyUpdate(dispatch)
    }

    private var skipFirstParticipantsAddedMessage = true
    // Fake a message for Participant Added
    private fun processParticipantsAdded(
        action: ParticipantAction.ParticipantsAdded,
        dispatch: Dispatch,
    ) {
        // This comes through at start, but we don't want to pass it through
        // since it's also in the historical messages
        if (skipFirstParticipantsAddedMessage) {
            skipFirstParticipantsAddedMessage = false
            return
        }
        messageRepository.addMessage(
            MessageInfoModel(
                internalId = System.currentTimeMillis().toString(),
                participants = action.participants,
                content = null,
                createdOn = OffsetDateTime.now(),
                senderDisplayName = null,
                messageType = ChatMessageType.PARTICIPANT_ADDED,
            )
        )
        notifyUpdate(dispatch)
    }

    private fun processParticipantsRemoved(
        action: ParticipantAction.ParticipantsRemoved,
        dispatch: Dispatch,
    ) {
        messageRepository.addMessage(
            MessageInfoModel(
                internalId = System.currentTimeMillis().toString(),
                participants = action.participants,
                content = null,
                createdOn = OffsetDateTime.now(),
                senderDisplayName = null,
                messageType = ChatMessageType.PARTICIPANT_REMOVED,
            )
        )
        notifyUpdate(dispatch)
    }

    private fun processLocalParticipantRemoved(
        dispatch: Dispatch,
    ) {
        messageRepository.addMessage(
            MessageInfoModel(
                internalId = System.currentTimeMillis().toString(),
                isCurrentUser = true,
                content = null,
                createdOn = OffsetDateTime.now(),
                senderDisplayName = null,
                messageType = ChatMessageType.PARTICIPANT_REMOVED,
            )
        )
        notifyUpdate(dispatch)
    }

    private fun processDeletedMessage(action: ChatAction.MessageDeleted, dispatch: Dispatch) {
        messageRepository.removeMessage(action.message)
        notifyUpdate(dispatch)
    }

    private fun processEditMessage(action: ChatAction.MessageEdited, dispatch: Dispatch) {
        val oldMessage = messageRepository.findMessageById(action.message.normalizedID)
        if (oldMessage == EMPTY_MESSAGE_INFO_MODEL) {
            // Do nothing? add message? throw error?
            // messageRepository.addMessage(action.message)
        } else {
            messageRepository.replaceMessage(
                oldMessage,
                action.message.copy(
                    messageType = oldMessage.messageType,
                    version = oldMessage.version,
                    senderDisplayName = oldMessage.senderDisplayName,
                    createdOn = oldMessage.createdOn,
                    editedOn = OffsetDateTime.now(), // Is it in edit object?
                    deletedOn = oldMessage.deletedOn,
                    sendStatus = oldMessage.sendStatus,
                    senderCommunicationIdentifier = oldMessage.senderCommunicationIdentifier,
                    isCurrentUser = oldMessage.isCurrentUser
                )
            )
        }
        notifyUpdate(dispatch)
    }

    // Notify the UI of an update
    private fun notifyUpdate(dispatch: (Action) -> Unit) {
        messageRepository.refreshSnapshot()
        dispatch(RepositoryAction.RepositoryUpdated())
    }
}
