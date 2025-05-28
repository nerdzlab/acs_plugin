// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid

import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.models.ParticipantStatus
import com.acs_plugin.calling.models.VideoStreamModel
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class ParticipantGridCellViewModel(
    userIdentifier: String,
    displayName: String,
    cameraVideoStreamModel: VideoStreamModel?,
    screenShareVideoStreamModel: VideoStreamModel?,
    isCameraDisabled: Boolean,
    isMuted: Boolean,
    isSpeaking: Boolean,
    isRaisedHand: Boolean,
    modifiedTimestamp: Number,
    participantStatus: ParticipantStatus?,
    reactionType: ReactionType?
) {
    private var isOnHoldStateFlow = MutableStateFlow(isOnHold(participantStatus))
    private var isCallingStateFlow = MutableStateFlow(isCalling(participantStatus))
    private var displayNameStateFlow = MutableStateFlow(displayName)
    private var isMutedStateFlow = MutableStateFlow(isMuted)
    private var isSpeakingStateFlow = MutableStateFlow(isSpeaking && !isMuted)
    private var isRaisedHandStateFlow = MutableStateFlow(isRaisedHand)
    private var reactionTypeStateFlow = MutableStateFlow(reactionType)
    private var isNameIndicatorVisibleStateFlow = MutableStateFlow(true)
    private var videoViewModelStateFlow = MutableStateFlow(
        getVideoStreamModel(
            createVideoViewModel(cameraVideoStreamModel),
            createVideoViewModel(screenShareVideoStreamModel),
            isOnHoldStateFlow.value,
            isCameraDisabled,
        )
    )

    private var participantModifiedTimestamp = modifiedTimestamp
    private var participantUserIdentifier = userIdentifier

    fun getParticipantUserIdentifier(): String {
        return participantUserIdentifier
    }

    fun showCallingTextStateFlow(): StateFlow<Boolean> {
        return isCallingStateFlow
    }

    fun getDisplayNameStateFlow(): StateFlow<String> {
        return displayNameStateFlow
    }

    fun getIsMutedStateFlow(): StateFlow<Boolean> {
        return isMutedStateFlow
    }

    fun getIsNameIndicatorVisibleStateFlow(): StateFlow<Boolean> {
        return isNameIndicatorVisibleStateFlow
    }

    fun getIsSpeakingStateFlow(): StateFlow<Boolean> {
        return isSpeakingStateFlow
    }

    fun getVideoViewModelStateFlow(): StateFlow<VideoViewModel?> {
        return videoViewModelStateFlow
    }

    fun getParticipantModifiedTimestamp(): Number {
        return participantModifiedTimestamp
    }

    fun getIsOnHoldStateFlow(): StateFlow<Boolean> {
        return isOnHoldStateFlow
    }

    fun getIsRaisedHandStateFlow(): StateFlow<Boolean> {
        return isRaisedHandStateFlow
    }

    fun getReactionTypeStateFlow(): StateFlow<ReactionType?> {
        return reactionTypeStateFlow
    }

    fun update(
        participant: ParticipantInfoModel,
    ) {
        this.participantUserIdentifier = participant.userIdentifier
        this.displayNameStateFlow.value = participant.displayName
        this.isMutedStateFlow.value = participant.isMuted && !isCalling(participant.participantStatus)
        this.isOnHoldStateFlow.value = isOnHold(participant.participantStatus)

        this.isNameIndicatorVisibleStateFlow.value =
            !(participant.displayName.isBlank() && !participant.isMuted)

        this.videoViewModelStateFlow.value = getVideoStreamModel(
            createVideoViewModel(participant.cameraVideoStreamModel),
            createVideoViewModel(participant.screenShareVideoStreamModel),
            this.isOnHoldStateFlow.value,
            participant.isCameraDisabled
        )

        this.isSpeakingStateFlow.value = (participant.isSpeaking && !participant.isMuted && !participant.isRaisedHand) ||
            participant.isTypingRtt
        this.participantModifiedTimestamp = participant.modifiedTimestamp
        this.isCallingStateFlow.value = isCalling(participant.participantStatus)
        this.isRaisedHandStateFlow.value = participant.isRaisedHand
        this.reactionTypeStateFlow.value = participant.selectedReaction
    }

    private fun isCalling(participantStatus: ParticipantStatus?) =
        participantStatus == ParticipantStatus.CONNECTING || participantStatus == ParticipantStatus.RINGING

    private fun createVideoViewModel(videoStreamModel: VideoStreamModel?): VideoViewModel? {
        videoStreamModel?.let {
            return VideoViewModel(videoStreamModel.videoStreamID, videoStreamModel.streamType)
        }
        return null
    }

    private fun getVideoStreamModel(
        cameraVideoStreamModel: VideoViewModel?,
        screenShareVideoStreamModel: VideoViewModel?,
        isOnHold: Boolean,
        isCameraDisabled: Boolean
    ): VideoViewModel? {
        if (isOnHold) return null
        if (screenShareVideoStreamModel != null) return screenShareVideoStreamModel
        if (isCameraDisabled) return null
        if (cameraVideoStreamModel != null) return cameraVideoStreamModel
        return null
    }

    private fun isOnHold(participantStatus: ParticipantStatus?) =
        participantStatus == ParticipantStatus.HOLD
}
