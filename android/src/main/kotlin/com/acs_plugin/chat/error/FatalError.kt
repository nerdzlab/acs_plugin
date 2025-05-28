package com.acs_plugin.chat.error

import com.acs_plugin.chat.models.ChatCompositeErrorCode

internal class FatalError(
    val fatalError: Throwable?,
    val chatCompositeErrorCode: ChatCompositeErrorCode?,
)
