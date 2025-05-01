// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.reducer

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.DeviceConfigurationAction
import com.acs_plugin.calling.redux.state.DeviceConfigurationState

internal interface DeviceConfigurationReducer : Reducer<DeviceConfigurationState>
internal class DeviceConfigurationReducerImpl : DeviceConfigurationReducer {
    override fun reduce(state: DeviceConfigurationState, action: Action): DeviceConfigurationState {
        return when (action) {
            is DeviceConfigurationAction.ToggleKeyboardVisibility -> {
                state.copy(isSoftwareKeyboardVisible = action.isSoftwareKeyboardVisible)
            }
            is DeviceConfigurationAction.ToggleTabletMode -> {
                state.copy(isTablet = action.isTablet)
            }
            is DeviceConfigurationAction.TogglePortraitMode -> {
                state.copy(isPortrait = action.isPortrait)
            }
            else -> state
        }
    }
}
