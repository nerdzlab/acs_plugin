package com.acs_plugin.chat.redux.state

import com.acs_plugin.chat.models.LocalParticipantInfoModel
import com.acs_plugin.chat.models.RemoteParticipantInfoModel
import org.threeten.bp.OffsetDateTime

internal data class ParticipantsState(
    val participants: Map<String, RemoteParticipantInfoModel>,
    val participantTyping: Map<String, String>,
    val participantsReadReceiptMap: Map<String, OffsetDateTime>,
    val latestReadMessageTimestamp: OffsetDateTime,
    val localParticipantInfoModel: LocalParticipantInfoModel,
    val hiddenParticipant: Set<String>,
)
