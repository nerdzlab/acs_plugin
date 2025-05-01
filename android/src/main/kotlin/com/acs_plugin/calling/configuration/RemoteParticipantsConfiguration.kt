// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.configuration

import com.acs_plugin.calling.models.CallCompositeParticipantViewData
import com.acs_plugin.calling.models.CallCompositeSetParticipantViewDataResult
import com.acs_plugin.calling.service.sdk.CommunicationIdentifier
import java.lang.ref.WeakReference

internal data class RemoteParticipantViewData(
    val identifier: CommunicationIdentifier,
    val participantViewData: CallCompositeParticipantViewData,
)

internal interface RemoteParticipantsConfigurationHandler {
    fun onSetParticipantViewData(data: RemoteParticipantViewData): CallCompositeSetParticipantViewDataResult
    fun onRemoveParticipantViewData(identifier: String)
}

internal class RemoteParticipantsConfiguration {
    private var handler: WeakReference<RemoteParticipantsConfigurationHandler>? = null

    fun setHandler(handler: RemoteParticipantsConfigurationHandler) {
        this.handler = WeakReference<RemoteParticipantsConfigurationHandler>(handler)
    }

    fun setParticipantViewData(
        identifier: CommunicationIdentifier,
        participantViewData: CallCompositeParticipantViewData,
    ): CallCompositeSetParticipantViewDataResult {
        handler?.get()?.let {
            return@setParticipantViewData it.onSetParticipantViewData(
                RemoteParticipantViewData(identifier, participantViewData)
            )
        }
        return CallCompositeSetParticipantViewDataResult.PARTICIPANT_NOT_IN_CALL
    }

    fun removeParticipantViewData(identifier: String) {
        handler?.get()?.onRemoveParticipantViewData(identifier)
    }
}
