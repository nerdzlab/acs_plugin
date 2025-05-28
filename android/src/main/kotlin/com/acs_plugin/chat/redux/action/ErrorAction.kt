package com.acs_plugin.chat.redux.action

import com.acs_plugin.chat.models.ChatCompositeErrorEvent

internal sealed class ErrorAction : Action {
    class ChatStateErrorOccurred(val chatCompositeErrorEvent: ChatCompositeErrorEvent) : ErrorAction()
}
