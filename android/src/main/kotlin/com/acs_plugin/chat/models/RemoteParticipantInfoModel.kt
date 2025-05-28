package com.acs_plugin.chat.models

import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier

internal data class RemoteParticipantInfoModel(
    val userIdentifier: CommunicationIdentifier,
    val displayName: String?,
    val isLocalUser: Boolean = false
)
