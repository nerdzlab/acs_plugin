package com.acs_plugin.chat.redux.reducer

import com.acs_plugin.chat.redux.action.Action
import com.acs_plugin.chat.redux.action.NetworkAction
import com.acs_plugin.chat.redux.state.NetworkState
import com.acs_plugin.chat.redux.state.NetworkStatus

internal interface NetworkReducer : Reducer<NetworkState>

internal class NetworkReducerImpl : NetworkReducer {
    override fun reduce(state: NetworkState, action: Action): NetworkState {
        return when (action) {
            is NetworkAction.Connected -> {
                state.copy(networkStatus = NetworkStatus.CONNECTED)
            }
            is NetworkAction.Disconnected -> {
                state.copy(networkStatus = NetworkStatus.DISCONNECTED)
            }
            is NetworkAction.SetDisconnectedOffset -> {
                state.copy(disconnectOffsetDateTime = action.disconnectOffsetDateTime)
            }
            else -> state
        }
    }
}
