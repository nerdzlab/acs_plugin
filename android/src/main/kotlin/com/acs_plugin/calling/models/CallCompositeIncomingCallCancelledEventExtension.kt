// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal fun buildCallCompositeIncomingCallCancelledEvent(
    code: Int,
    subCode: Int,
    callId: String,
): CallCompositeIncomingCallCancelledEvent {
    return CallCompositeIncomingCallCancelledEvent(
        code,
        subCode,
        callId
    )
}
