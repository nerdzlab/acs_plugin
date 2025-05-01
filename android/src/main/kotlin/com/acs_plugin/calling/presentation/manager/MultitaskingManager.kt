// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.manager

import com.acs_plugin.calling.configuration.CallCompositeConfiguration
import com.acs_plugin.calling.models.CallCompositePictureInPictureChangedEvent
import com.acs_plugin.calling.redux.AppStore
import com.acs_plugin.calling.redux.state.VisibilityStatus
import com.acs_plugin.calling.redux.state.ReduxState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

internal class MultitaskingManager(
    private val store: AppStore<ReduxState>,
    private val configuration: CallCompositeConfiguration
) {

    private var pipStatus = store.getCurrentState().visibilityState.status

    fun start(
        coroutineScope: CoroutineScope,
    ) {
        coroutineScope.launch {
            store.getStateFlow().collect {
                if (pipStatus != it.visibilityState.status) {
                    pipStatus = it.visibilityState.status
                    notify(it.visibilityState.status)
                }
            }
        }
    }

    private fun notify(status: VisibilityStatus) {
        try {
            configuration.callCompositeEventsHandler.getOnMultitaskingStateChangedEventHandlers().forEach { handler ->
                handler.handle(
                    CallCompositePictureInPictureChangedEvent(
                        status == VisibilityStatus.PIP_MODE_ENTERED
                    )
                )
            }
        } catch (error: Throwable) {
            // suppress any possible application errors
        }
    }
}
