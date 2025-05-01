// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.manager

import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.models.ParticipantCapabilityType

internal class CapabilitiesManager(
    private val callType: CallType,
) {
    fun hasCapability(
        capabilities: Set<ParticipantCapabilityType>,
        capability: ParticipantCapabilityType,
    ): Boolean {
        return when (callType) {
            CallType.GROUP_CALL,
            CallType.ONE_TO_N_OUTGOING,
            CallType.ONE_TO_ONE_INCOMING -> true
            CallType.TEAMS_MEETING,
            CallType.ROOMS_CALL -> capabilities.contains(capability)
        }
    }
}
