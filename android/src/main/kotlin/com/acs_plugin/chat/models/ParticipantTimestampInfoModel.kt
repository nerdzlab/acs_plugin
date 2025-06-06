package com.acs_plugin.chat.models

import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier
import org.threeten.bp.OffsetDateTime

internal data class ParticipantTimestampInfoModel(
    val userIdentifier: CommunicationIdentifier,
    val receivedOn: OffsetDateTime,
) : BaseInfoModel
