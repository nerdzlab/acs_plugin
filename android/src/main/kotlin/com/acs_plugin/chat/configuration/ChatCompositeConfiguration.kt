package com.acs_plugin.chat.configuration

internal class ChatCompositeConfiguration {
    var chatConfig: ChatConfiguration? = null

    var eventHandlerRepository = ChatCompositeEventHandlerRepository()
}
