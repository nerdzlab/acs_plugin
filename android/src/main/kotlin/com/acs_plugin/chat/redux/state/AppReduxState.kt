package com.acs_plugin.chat.redux.state

import com.acs_plugin.chat.models.ChatInfoModel
import com.acs_plugin.chat.models.EMPTY_MESSAGE_INFO_MODEL
import com.acs_plugin.chat.models.LocalParticipantInfoModel
import com.acs_plugin.chat.models.MessageContextMenuModel
import org.threeten.bp.OffsetDateTime

internal class AppReduxState(
    threadID: String,
    localParticipantIdentifier: String,
    localParticipantDisplayName: String?,
) : ReduxState {
    override var chatState: ChatState = ChatState(
        chatStatus = ChatStatus.NONE,
        chatInfoModel = ChatInfoModel(
            threadId = threadID,
            topic = null,
            allMessagesFetched = false,
            isThreadDeleted = false
        ),
        lastReadMessageId = "",
        messageContextMenu = MessageContextMenuModel(EMPTY_MESSAGE_INFO_MODEL, emptyList())
    )

    override var participantState: ParticipantsState = ParticipantsState(
        localParticipantInfoModel = LocalParticipantInfoModel(
            userIdentifier = localParticipantIdentifier,
            displayName = localParticipantDisplayName
        ),
        participants = mapOf(),
        participantTyping = mapOf(),
        participantsReadReceiptMap = mapOf(),
        latestReadMessageTimestamp = OffsetDateTime.MIN,
        hiddenParticipant = setOf()
    )

    override var lifecycleState: LifecycleState = LifecycleState(LifecycleStatus.FOREGROUND)

    override var errorState: ErrorState = ErrorState(fatalError = null, chatCompositeErrorEvent = null)

    override var navigationState: NavigationState = NavigationState(NavigationStatus.NONE)

    override var repositoryState: RepositoryState =
        RepositoryState(lastUpdatedTimestamp = System.currentTimeMillis())

    override var networkState: NetworkState =
        NetworkState(networkStatus = NetworkStatus.CONNECTED, disconnectOffsetDateTime = null)
}
