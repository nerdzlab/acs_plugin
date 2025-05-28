package com.acs_plugin.chat.configuration

import com.azure.android.communication.common.CommunicationTokenCredential

internal class ChatConfiguration(
    val endpoint: String,
    val identity: String,
    val credential: CommunicationTokenCredential,
    val applicationID: String,
    val sdkName: String,
    val sdkVersion: String,
    val threadId: String,
    val senderDisplayName: String,
)
