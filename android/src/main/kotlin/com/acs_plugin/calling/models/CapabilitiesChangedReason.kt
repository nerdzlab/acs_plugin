// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

internal enum class CapabilitiesChangedReason {
    /**
     * Role changed
     */
    ROLE_CHANGED,

    /**
     * User policy changed
     */
    USER_POLICY_CHANGED,

    /**
     * Meeting details changed
     */
    MEETING_DETAILS_CHANGED
}
