package com.acs_plugin.chat.redux.action

internal sealed class LifecycleAction : Action {
    object EnterForeground : LifecycleAction()
    object EnterBackground : LifecycleAction()
}
