// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal fun buildCallCompositeCallStateChangedEvent(
    code: CallCompositeCallStateCode,
    callEndReasonCode: Int,
    callEndReasonSubCode: Int,
    callId: String?
): CallCompositeCallStateChangedEvent {
    return CallCompositeCallStateChangedEvent(code, callEndReasonCode, callEndReasonSubCode, callId)
}
