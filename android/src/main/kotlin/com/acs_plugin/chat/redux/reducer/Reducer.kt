package com.acs_plugin.chat.redux.reducer

import com.acs_plugin.chat.redux.action.Action

internal interface Reducer<S> {
    fun reduce(state: S, action: Action): S
}
