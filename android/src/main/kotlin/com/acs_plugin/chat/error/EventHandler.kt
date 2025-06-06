package com.acs_plugin.chat.error

import com.acs_plugin.chat.configuration.ChatCompositeConfiguration
import com.acs_plugin.chat.redux.AppStore
import com.acs_plugin.chat.redux.state.ReduxState
import com.acs_plugin.chat.utilities.CoroutineContextProvider
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch

internal class EventHandler(
    coroutineContextProvider: CoroutineContextProvider,
    private val store: AppStore<ReduxState>,
    private val configuration: ChatCompositeConfiguration,
) {
    private var isActiveChatThreadParticipantStateFlow = MutableStateFlow(
        store.getCurrentState().participantState.localParticipantInfoModel.isActiveChatThreadParticipant
    )

    private val coroutineScope = CoroutineScope((coroutineContextProvider.Default))

    fun start() {
        coroutineScope.launch(Dispatchers.Default) {
            store.getStateFlow().collect {
                isActiveChatThreadParticipantStateFlow.value =
                    it.participantState.localParticipantInfoModel.isActiveChatThreadParticipant
            }
        }

        coroutineScope.launch(Dispatchers.Default) {
            isActiveChatThreadParticipantStateFlow.collect {
                onIsActiveChanged(it)
            }
        }
    }

    fun stop() {
        coroutineScope.cancel()
    }

    private fun onIsActiveChanged(
        isActiveChatThreadParticipant: Boolean
    ) {
        if (!isActiveChatThreadParticipant) {
            configuration.eventHandlerRepository.getLocalParticipantRemovedHandlers().forEach {
                it.handle(store.getCurrentState().participantState.localParticipantInfoModel.userIdentifier)
            }
        }
    }
}
