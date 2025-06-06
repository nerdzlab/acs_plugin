package com.acs_plugin.chat.redux.state

import com.acs_plugin.chat.models.ChatCompositeErrorEvent
import com.acs_plugin.chat.error.FatalError

internal data class ErrorState(
    val fatalError: FatalError?,
    val chatCompositeErrorEvent: ChatCompositeErrorEvent?,
)
