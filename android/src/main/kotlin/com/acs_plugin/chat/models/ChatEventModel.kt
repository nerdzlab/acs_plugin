package com.acs_plugin.chat.models

import com.acs_plugin.chat.service.sdk.wrapper.ChatEventType
import org.threeten.bp.OffsetDateTime

internal data class ChatEventModel(
    val eventType: ChatEventType,
    val infoModel: BaseInfoModel,
    val eventReceivedOffsetDateTime: OffsetDateTime? = null,
)
