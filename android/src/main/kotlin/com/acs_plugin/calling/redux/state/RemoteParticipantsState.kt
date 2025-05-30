// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.state

import com.acs_plugin.calling.models.CallCompositeLobbyErrorCode
import com.acs_plugin.calling.models.ParticipantInfoModel

internal data class RemoteParticipantsState(
    val participantMap: Map<String, ParticipantInfoModel>,
    val participantMapModifiedTimestamp: Number,
    val dominantSpeakersInfo: List<String>,
    val raisedHandsInfo: List<String>,
    val dominantSpeakersModifiedTimestamp: Number,
    val raisedHandsModifiedTimestamp: Number,
    val lobbyErrorCode: CallCompositeLobbyErrorCode?,
    val totalParticipantCount: Int,
)
