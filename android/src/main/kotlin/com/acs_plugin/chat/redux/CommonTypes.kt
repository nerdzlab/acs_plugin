package com.acs_plugin.chat.redux

import com.acs_plugin.chat.redux.action.Action

internal typealias Dispatch = (Action) -> Unit
internal typealias Middleware<State> = (store: Store<State>) -> (next: Dispatch) -> Dispatch
