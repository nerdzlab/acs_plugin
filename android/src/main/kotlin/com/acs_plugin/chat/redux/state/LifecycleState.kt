package com.acs_plugin.chat.redux.state

internal enum class LifecycleStatus {
    FOREGROUND,
    BACKGROUND,
}

internal data class LifecycleState(val state: LifecycleStatus)
