// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.redux.action

import com.acs_plugin.calling.models.CallCompositeLobbyErrorCode
import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.models.ReactionPayload

internal sealed class ParticipantAction : Action {
    class ListUpdated(val participantMap: Map<String, ParticipantInfoModel>) : ParticipantAction()
    class DominantSpeakersUpdated(val dominantSpeakersInfo: List<String>) : ParticipantAction()
    class RaisedHandsUpdated(val raisedHandsInfo: List<String>) : ParticipantAction()
    class AdmitAll : ParticipantAction()
    class Admit(val userIdentifier: String) : ParticipantAction()
    class Reject(val userIdentifier: String) : ParticipantAction()
    class LobbyError(val code: CallCompositeLobbyErrorCode) : ParticipantAction()
    class ClearLobbyError : ParticipantAction()
    class Remove(val userIdentifier: String) : ParticipantAction()
    class RemoveParticipantError : ParticipantAction()
    class ReactionParticipantUpdated(val participantReactionMap: Map<String, ReactionPayload?>) : ParticipantAction()

    class SetTotalParticipantCount(val totalParticipantCount: Int) : ParticipantAction()
}
