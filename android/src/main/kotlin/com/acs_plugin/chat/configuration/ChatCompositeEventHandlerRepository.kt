package com.acs_plugin.chat.configuration

import com.acs_plugin.chat.ChatCompositeEventHandler
import com.acs_plugin.chat.models.ChatCompositeErrorEvent

internal class ChatCompositeEventHandlerRepository {
    private val eventHandlers = mutableListOf<ChatCompositeEventHandler<String>>()
    private val errorHandlers = mutableListOf<ChatCompositeEventHandler<ChatCompositeErrorEvent>>()

    fun getOnErrorHandlers(): List<ChatCompositeEventHandler<ChatCompositeErrorEvent>> = errorHandlers

    fun addOnErrorEventHandler(errorHandler: ChatCompositeEventHandler<ChatCompositeErrorEvent>) =
        errorHandlers.add(errorHandler)

    fun removeOnErrorEventHandler(errorHandler: ChatCompositeEventHandler<ChatCompositeErrorEvent>) =
        errorHandlers.remove(errorHandler)

    fun getLocalParticipantRemovedHandlers(): List<ChatCompositeEventHandler<String>> {
        return eventHandlers
    }
}
