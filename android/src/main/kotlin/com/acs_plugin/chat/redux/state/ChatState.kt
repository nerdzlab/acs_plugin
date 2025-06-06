package com.acs_plugin.chat.redux.state

import com.acs_plugin.chat.models.ChatInfoModel
import com.acs_plugin.chat.models.MessageContextMenuModel

// ChatStatus will help to subscribe to real tim notifications when state is initialized
// The foreground/background mode for activity can query as per state here
internal enum class ChatStatus {
    NONE,
    INITIALIZATION,
    INITIALIZED
}

internal data class ChatState(
    val chatStatus: ChatStatus,
    val chatInfoModel: ChatInfoModel,
    val lastReadMessageId: String,
    val messageContextMenu: MessageContextMenuModel,
)
