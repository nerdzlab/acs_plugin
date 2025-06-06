package com.acs_plugin.chat.models

internal data class RemoteParticipantsInfoModel(
    val participants: List<RemoteParticipantInfoModel>,
) : BaseInfoModel
