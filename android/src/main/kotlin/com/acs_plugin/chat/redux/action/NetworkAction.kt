package com.acs_plugin.chat.redux.action

import org.threeten.bp.OffsetDateTime

internal sealed class NetworkAction : Action {
    class Connected : NetworkAction()
    class Disconnected : NetworkAction()
    class SetDisconnectedOffset(val disconnectOffsetDateTime: OffsetDateTime) : NetworkAction()
}
