// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.action

import com.acs_plugin.calling.models.MediaCallDiagnosticModel
import com.acs_plugin.calling.models.NetworkCallDiagnosticModel
import com.acs_plugin.calling.models.NetworkQualityCallDiagnosticModel

internal sealed class CallDiagnosticsAction : Action {
    class NetworkQualityCallDiagnosticsUpdated(val networkQualityCallDiagnosticModel: NetworkQualityCallDiagnosticModel) : CallDiagnosticsAction()
    class NetworkCallDiagnosticsUpdated(val networkCallDiagnosticModel: NetworkCallDiagnosticModel) : CallDiagnosticsAction()
    class MediaCallDiagnosticsUpdated(val mediaCallDiagnosticModel: MediaCallDiagnosticModel) : CallDiagnosticsAction()

    class NetworkQualityCallDiagnosticsDismissed(val networkQualityCallDiagnosticModel: NetworkQualityCallDiagnosticModel) : CallDiagnosticsAction()
    class NetworkCallDiagnosticsDismissed(val networkCallDiagnosticModel: NetworkCallDiagnosticModel) : CallDiagnosticsAction()
    class MediaCallDiagnosticsDismissed(val mediaCallDiagnosticModel: MediaCallDiagnosticModel) : CallDiagnosticsAction()
}
