// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

internal data class DeviceConfigurationState(
    val isSoftwareKeyboardVisible: Boolean = false,
    val isTablet: Boolean = false,
    val isPortrait: Boolean = false,
)
