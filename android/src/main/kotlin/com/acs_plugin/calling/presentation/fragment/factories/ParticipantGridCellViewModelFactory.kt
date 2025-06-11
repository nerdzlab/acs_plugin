// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.factories

import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.ParticipantGridCellViewModel
import com.acs_plugin.calling.redux.action.Action

internal class ParticipantGridCellViewModelFactory {
    fun ParticipantGridCellViewModel(
        participantInfoModel: ParticipantInfoModel,
        dispatch: (Action) -> Unit
    ): ParticipantGridCellViewModel =
        ParticipantGridCellViewModel(
            participantInfoModel.userIdentifier,
            participantInfoModel.displayName,
            participantInfoModel.cameraVideoStreamModel,
            participantInfoModel.screenShareVideoStreamModel,
            participantInfoModel.isCameraDisabled,
            participantInfoModel.isMuted,
            participantInfoModel.isSpeaking,
            participantInfoModel.isRaisedHand,
            participantInfoModel.modifiedTimestamp,
            participantInfoModel.participantStatus,
            participantInfoModel.selectedReaction,
            participantInfoModel.isPrimaryParticipant(),
            participantInfoModel.isVideoTurnOffForMe,
            dispatch
        )
}
