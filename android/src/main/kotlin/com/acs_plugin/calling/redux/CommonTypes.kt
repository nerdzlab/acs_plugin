// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux

import com.acs_plugin.calling.redux.action.Action

internal typealias Dispatch = (Action) -> Unit
internal typealias Middleware<State> = (store: Store<State>) -> (next: Dispatch) -> Dispatch
