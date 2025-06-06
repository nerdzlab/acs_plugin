package com.acs_plugin.chat.service.sdk.wrapper

import com.azure.android.communication.chat.models.ChatEvent
import com.azure.android.communication.chat.models.ChatEventType
import com.azure.android.communication.chat.models.RealTimeNotificationCallback

internal class ChatEventWrapper(
    private val eventType: ChatEventType,
    private val onEventReceived: (ChatEventType, ChatEvent) -> Unit,
) : RealTimeNotificationCallback {
    override fun onChatEvent(chatEvent: ChatEvent) {
        onEventReceived(eventType, chatEvent)
    }
}
