package com.acs_plugin.calling.error

import com.acs_plugin.calling.models.CallCompositeEventCode

internal class CallStateError(
    val errorCode: ErrorCode,
    val callCompositeEventCode: CallCompositeEventCode? = null
)
