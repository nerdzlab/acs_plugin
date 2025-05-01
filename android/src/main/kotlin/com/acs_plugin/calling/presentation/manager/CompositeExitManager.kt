// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.manager

import com.acs_plugin.calling.configuration.CallCompositeConfiguration
import com.acs_plugin.calling.models.CallCompositeDismissedEvent
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.action.CallingAction
import com.acs_plugin.calling.redux.action.NavigationAction
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.ReduxState

internal class CompositeExitManager(
    private val store: Store<ReduxState>,
    private val configuration: CallCompositeConfiguration
) {

    private var exitCallBack: (() -> Unit)? = null

    fun onCompositeDestroy() {
        try {
            notifyCompositeExit()
            exitCallBack?.invoke()
        } catch (error: Throwable) {
            // suppress any possible application errors
        }
    }

    fun exit(onExit: (() -> Unit)? = null) {
        exitCallBack = onExit
        val callIsNotInProgress =
            store.getCurrentState().callState.callingStatus == CallingStatus.NONE ||
                store.getCurrentState().callState.callingStatus == CallingStatus.DISCONNECTED

        // if call state is none or Disconnected exit composite
        if (callIsNotInProgress) {
            store.dispatch(action = NavigationAction.Exit())
        } else {
            // end call
            store.dispatch(action = CallingAction.CallEndRequested())
        }
    }

    private fun notifyCompositeExit() {
        configuration.callCompositeEventsHandler.getOnExitEventHandlers().forEach {
            val eventArgs =
                CallCompositeDismissedEvent(
                    store.getCurrentState().errorState.fatalError?.errorCode?.toCallCompositeErrorCode(),
                    store.getCurrentState().errorState.fatalError?.fatalError
                )
            it.handle(eventArgs)
        }
    }
}
