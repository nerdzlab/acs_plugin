// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.action

import com.acs_plugin.calling.error.CallStateError
import com.acs_plugin.calling.error.FatalError

internal sealed class ErrorAction : Action {
    class FatalErrorOccurred(val error: FatalError) : ErrorAction()
    class CallStateErrorOccurred(val callStateError: CallStateError) : ErrorAction()
    class EmergencyExit : ErrorAction()
}
