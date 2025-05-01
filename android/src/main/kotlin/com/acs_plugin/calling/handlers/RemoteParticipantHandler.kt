// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.handlers

import com.acs_plugin.calling.configuration.CallCompositeConfiguration
import com.acs_plugin.calling.models.CallCompositeRemoteParticipantJoinedEvent
import com.acs_plugin.calling.models.buildCallCompositeRemoteParticipantLeftEvent
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.state.ReduxState
import com.acs_plugin.calling.redux.state.RemoteParticipantsState
import com.acs_plugin.calling.service.sdk.CallingSDK
import com.acs_plugin.calling.service.sdk.into
import kotlinx.coroutines.flow.collect

internal class RemoteParticipantHandler(
    private val configuration: CallCompositeConfiguration,
    private val store: Store<ReduxState>,
    private val remoteParticipantsCollection: CallingSDK,
) {
    private var lastRemoteParticipantsState: RemoteParticipantsState? = null

    suspend fun start() {
        store.getStateFlow().collect {
            onStateChanged(it.remoteParticipantState)
        }
    }

    private fun onStateChanged(remoteParticipantsState: RemoteParticipantsState) {
        if (remoteParticipantsState.participantMapModifiedTimestamp != lastRemoteParticipantsState?.participantMapModifiedTimestamp) {
            if (configuration.callCompositeEventsHandler.getOnRemoteParticipantJoinedHandlers().any()) {
                if (lastRemoteParticipantsState != null) {
                    val joinedParticipants =
                        remoteParticipantsState.participantMap.keys.filter { it !in lastRemoteParticipantsState!!.participantMap.keys }
                    sendRemoteParticipantJoinedEvent(joinedParticipants)
                } else {
                    sendRemoteParticipantJoinedEvent(remoteParticipantsState.participantMap.keys.toList())
                }
            }

            val leftParticipants =
                lastRemoteParticipantsState?.participantMap?.keys?.filter { it !in remoteParticipantsState.participantMap.keys }
            leftParticipants?.forEach {
                configuration.remoteParticipantsConfiguration.removeParticipantViewData(it)
            }
            leftParticipants?.let {
                sendRemoteParticipantLeftEvent(it)
            }

            lastRemoteParticipantsState = remoteParticipantsState
        }
    }

    private fun sendRemoteParticipantLeftEvent(leftParticipants: List<String>) {
        if (configuration.callCompositeEventsHandler.getOnRemoteParticipantRemovedHandlers().any()) {
            try {
                if (leftParticipants.isNotEmpty()) {
                    val identifiers = leftParticipants.map {
                        com.azure.android.communication.common.CommunicationIdentifier.fromRawId(it)
                    }
                    val eventArgs =
                        buildCallCompositeRemoteParticipantLeftEvent(
                            identifiers
                        )
                    configuration.callCompositeEventsHandler.getOnRemoteParticipantRemovedHandlers()
                        .forEach { it.handle(eventArgs) }
                }
            } catch (error: Throwable) {
                // suppress any possible application errors
            }
        }
    }

    private fun sendRemoteParticipantJoinedEvent(joinedParticipant: List<String>) {
        try {
            if (joinedParticipant.isNotEmpty()) {
                val participantIdMap = remoteParticipantsCollection.getRemoteParticipantsMap()
                val identifiers = joinedParticipant.map {
                    participantIdMap.getValue(it).identifier.into()
                }
                val eventArgs = CallCompositeRemoteParticipantJoinedEvent(identifiers)
                configuration.callCompositeEventsHandler.getOnRemoteParticipantJoinedHandlers()
                    .forEach { it.handle(eventArgs) }
            }
        } catch (error: Throwable) {
            // suppress any possible application errors
        }
    }
}
