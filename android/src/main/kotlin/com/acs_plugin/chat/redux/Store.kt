package com.acs_plugin.chat.redux

import com.acs_plugin.chat.redux.action.Action
import kotlinx.coroutines.flow.MutableStateFlow

internal interface Store<S> {
    fun dispatch(action: Action)
    fun getStateFlow(): MutableStateFlow<S>
    fun getCurrentState(): S
    fun end()
}
