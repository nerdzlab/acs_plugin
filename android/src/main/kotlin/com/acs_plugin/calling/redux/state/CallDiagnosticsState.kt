// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

import com.acs_plugin.calling.models.MediaCallDiagnosticModel
import com.acs_plugin.calling.models.NetworkCallDiagnosticModel
import com.acs_plugin.calling.models.NetworkQualityCallDiagnosticModel

internal data class CallDiagnosticsState(
    val networkQualityCallDiagnostic: NetworkQualityCallDiagnosticModel?,
    val networkCallDiagnostic: NetworkCallDiagnosticModel?,
    val mediaCallDiagnostic: MediaCallDiagnosticModel?
)
