package com.acs_plugin.chat.redux.action

internal sealed class RepositoryAction : Action {
    class RepositoryUpdated : RepositoryAction()
}
