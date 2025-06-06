// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.models

import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell.ParticipantGridCellMoreView.Companion.MORE_VIEW_ID

internal enum class ParticipantStatus {
    IDLE,
    EARLY_MEDIA,
    CONNECTING,
    CONNECTED,
    HOLD,
    DISCONNECTED,
    IN_LOBBY,
    RINGING,
}

internal data class ParticipantInfoModel(
    var displayName: String,
    val userIdentifier: String,
    var isMuted: Boolean,
    var isCameraDisabled: Boolean,
    var isSpeaking: Boolean,
    var isTypingRtt: Boolean,
    var participantStatus: ParticipantStatus?,
    var screenShareVideoStreamModel: VideoStreamModel?,
    var cameraVideoStreamModel: VideoStreamModel?,
    var modifiedTimestamp: Number,
    var isRaisedHand: Boolean = false,
    var selectedReaction: ReactionType? = null,
    var isWhiteboard: Boolean = false,
    var isPinned: Boolean = false,
    var isVideoTurnOffForMe: Boolean = false
) {

    fun isPrimaryParticipant(): Boolean {
        return isWhiteboard || isPinned
    }

    companion object {

        fun createMoreParticipantInfoModel(remainingCount: Int): ParticipantInfoModel {
            return ParticipantInfoModel(
                displayName = "+$remainingCount",
                userIdentifier = MORE_VIEW_ID,
                isMuted = true,
                isCameraDisabled = true,
                isSpeaking = false,
                isTypingRtt = false,
                participantStatus = null,
                screenShareVideoStreamModel = null,
                cameraVideoStreamModel = null,
                modifiedTimestamp = System.currentTimeMillis(),
                isRaisedHand = false,
                selectedReaction = null
            )
        }
    }
}
