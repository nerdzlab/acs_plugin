// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.navigation

import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.state.NavigationStatus
import com.acs_plugin.calling.redux.state.ReduxState
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.StateFlow

internal class NavigationRouterImpl(private val store: Store<ReduxState>) : NavigationRouter {

    private val navigationFlow = MutableStateFlow(NavigationStatus.NONE)

    override suspend fun start() {
        store.getStateFlow().collect {
            navigationFlow.value = it.navigationState.navigationState
        }
    }

    override fun getNavigationStateFlow(): StateFlow<NavigationStatus> {
        return navigationFlow
    }
}
