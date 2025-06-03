package com.acs_plugin.chat.models

import org.threeten.bp.OffsetDateTime

internal data class ChatThreadInfoModel(
    val topic: String? = null,
    val receivedOn: OffsetDateTime? = null,
) : BaseInfoModel
