// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.manager

import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.action.LifecycleAction
import com.acs_plugin.calling.redux.state.ReduxState

internal interface LifecycleManager {
    fun pause()
    fun resume()
}

internal class LifecycleManagerImpl(
    private val store: Store<ReduxState>,
) :
    LifecycleManager {

    override fun pause() {
        store.dispatch(action = LifecycleAction.EnterBackgroundTriggered())
    }

    override fun resume() {
        store.dispatch(action = LifecycleAction.EnterForegroundTriggered())
    }
}
