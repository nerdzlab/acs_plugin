package com.acs_plugin.chat.redux.state

internal enum class NavigationStatus {
    NONE,
    PARTICIPANTS,
}

internal data class NavigationState(val navigationStatus: NavigationStatus)
