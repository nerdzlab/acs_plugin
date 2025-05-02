// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.service

import com.acs_plugin.calling.data.CallHistoryRepository
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.state.ReduxState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.launch

internal interface CallHistoryService {
    fun start(coroutineScope: CoroutineScope)
}

internal class CallHistoryServiceImpl(
    private val store: Store<ReduxState>,
    private val callHistoryRepository: CallHistoryRepository,
) : CallHistoryService {
    private val callIdStateFlow = MutableStateFlow<String?>(null)

    override fun start(coroutineScope: CoroutineScope) {
        coroutineScope.launch {
            store.getStateFlow().collect {
                callIdStateFlow.value = it.callState.callId
            }
        }

        coroutineScope.launch {
            callIdStateFlow.collect { callId ->
                val callStartDateTime = store.getCurrentState().callState.callStartDateTime
                if (callId != null && callStartDateTime != null) {
                    callHistoryRepository.insert(callId, callStartDateTime)
                }
            }
        }
    }
}
