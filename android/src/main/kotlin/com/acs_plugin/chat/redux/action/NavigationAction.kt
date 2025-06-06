package com.acs_plugin.chat.redux.action

internal sealed class NavigationAction : Action {
    class GotoParticipants : NavigationAction()
    class Pop : NavigationAction()
}
