package com.acs_plugin.chat.error

import com.acs_plugin.chat.configuration.ChatCompositeConfiguration
import com.acs_plugin.chat.models.ChatCompositeErrorCode
import com.acs_plugin.chat.models.ChatCompositeErrorEvent
import com.acs_plugin.chat.redux.AppStore
import com.acs_plugin.chat.redux.state.ReduxState
import com.acs_plugin.chat.utilities.CoroutineContextProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch
internal class ChatErrorHandler(
    coroutineContextProvider: CoroutineContextProvider,
    private val store: AppStore<ReduxState>,
    private val configuration: ChatCompositeConfiguration,
) {
    private val coroutineScope = CoroutineScope((coroutineContextProvider.Default))
    private var lastChatErrorEvent: ChatCompositeErrorEvent? = null

    fun start() {
        coroutineScope.launch(Dispatchers.Default) {
            store.getStateFlow().collect {
                onStateChanged(it)
            }
        }
    }
    private fun onStateChanged(state: ReduxState) {
        checkIfCallStateErrorIsNewAndNotify(
            state.errorState.chatCompositeErrorEvent,
            lastChatErrorEvent,
        ) { lastChatErrorEvent = it }
    }

    private fun chatStateErrorCallback(chatStateError: ChatCompositeErrorEvent) {
        try {
            configuration.eventHandlerRepository.getOnErrorHandlers()
                .forEach { it.handle(chatStateError) }
        } catch (error: Throwable) {
            // suppress any possible application errors
        }
    }

    private fun checkIfCallStateErrorIsNewAndNotify(
        newChatErrorEvent: ChatCompositeErrorEvent?,
        lastChatErrorEvent: ChatCompositeErrorEvent?,
        function: (ChatCompositeErrorEvent) -> Unit,
    ) {
        if (newChatErrorEvent != null && newChatErrorEvent != lastChatErrorEvent) {
            if (shouldNotifyError(newChatErrorEvent)) {
                function(newChatErrorEvent)
                chatStateErrorCallback(newChatErrorEvent)
            }
        }
    }

    // TODO: Check the logic again when we need to expose more error
    private fun shouldNotifyError(newCallStateError: ChatCompositeErrorEvent) =
        newCallStateError.errorCode == ChatCompositeErrorCode.JOIN_FAILED

    fun stop() {
        coroutineScope.cancel()
    }
}
