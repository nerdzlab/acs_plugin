package com.acs_plugin.chat.service.sdk.wrapper

internal data class SendChatMessageResult(val id: String)

internal fun SendChatMessageResult.into(): com.azure.android.communication.chat.models.SendChatMessageResult {
    return com.azure.android.communication.chat.models.SendChatMessageResult().setId(this.id)
}

internal fun com.azure.android.communication.chat.models.SendChatMessageResult.into(): SendChatMessageResult {
    return SendChatMessageResult(this.id)
}
