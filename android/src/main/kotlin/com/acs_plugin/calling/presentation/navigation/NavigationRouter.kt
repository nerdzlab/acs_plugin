// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.navigation

import com.acs_plugin.calling.redux.state.NavigationStatus
import kotlinx.coroutines.flow.StateFlow

internal interface NavigationRouter {
    suspend fun start()
    fun getNavigationStateFlow(): StateFlow<NavigationStatus>
}
