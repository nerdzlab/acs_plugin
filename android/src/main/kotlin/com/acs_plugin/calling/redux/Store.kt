// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux

import com.acs_plugin.calling.redux.action.Action
import kotlinx.coroutines.flow.MutableStateFlow

internal interface Store<S> {
    fun dispatch(action: Action)
    fun getStateFlow(): MutableStateFlow<S>
    fun getCurrentState(): S
    fun end()
}
