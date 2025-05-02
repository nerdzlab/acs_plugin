// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

import com.acs_plugin.calling.error.CallStateError
import com.acs_plugin.calling.redux.state.CallingStatus

internal class CallInfoModel(
    val callingStatus: CallingStatus,
    val callStateError: CallStateError?,
    val callEndReasonCode: Int? = null,
    val callEndReasonSubCode: Int? = null,
)
