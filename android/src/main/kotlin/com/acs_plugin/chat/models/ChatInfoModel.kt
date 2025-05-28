package com.acs_plugin.chat.models

internal data class ChatInfoModel(
    val threadId: String,
    val topic: String?,
    val allMessagesFetched: Boolean = false,
    val isThreadDeleted: Boolean = false,
)
