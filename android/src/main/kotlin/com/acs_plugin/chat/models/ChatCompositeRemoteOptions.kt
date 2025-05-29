package com.acs_plugin.chat.models

import com.acs_plugin.chat.service.sdk.wrapper.CommunicationIdentifier
import com.acs_plugin.chat.service.sdk.wrapper.into
import com.azure.android.communication.common.CommunicationTokenCredential

internal class ChatCompositeRemoteOptions internal constructor(
    val endpoint: String,
    val threadId: String,
    val credential: CommunicationTokenCredential,
    private val commonIdentity: CommunicationIdentifier,
    val displayName: String = "",
) {
    val identity: String by lazy { commonIdentity.into().id }
}
