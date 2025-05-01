// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal data class CapabilitiesChangedEvent(
    val changedCapabilities: List<ParticipantCapability>,
    val capabilitiesChangedReason: CapabilitiesChangedReason
)
