package com.acs_plugin.chat.models

internal data class LocalParticipantInfoModel(
    val userIdentifier: String,
    val displayName: String?,
    val isActiveChatThreadParticipant: Boolean = true,
)
