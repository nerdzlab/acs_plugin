// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.error

internal class CallCompositeError(
    var errorCode: ErrorCode,
    var cause: Throwable,
)
