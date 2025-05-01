// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

import com.acs_plugin.calling.error.CallStateError
import com.acs_plugin.calling.error.FatalError

internal data class ErrorState(
    val fatalError: FatalError?,
    val callStateError: CallStateError?,
)
