package com.acs_plugin.chat.models

internal data class MessagesPageModel(
    val messages: List<MessageInfoModel>?,
    val throwable: Throwable? = null,
    val allPagesFetched: Boolean = false,
)
