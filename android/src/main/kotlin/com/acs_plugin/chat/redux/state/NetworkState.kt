package com.acs_plugin.chat.redux.state

import org.threeten.bp.OffsetDateTime

internal enum class NetworkStatus {
    CONNECTED,
    DISCONNECTED,
}

internal data class NetworkState(
    val networkStatus: NetworkStatus,
    // last native chat sdk notification received offset date time
    val disconnectOffsetDateTime: OffsetDateTime?,
)
