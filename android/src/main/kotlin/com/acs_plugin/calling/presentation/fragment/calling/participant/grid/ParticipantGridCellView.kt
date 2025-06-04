// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.widget.FrameLayout
import android.widget.RelativeLayout
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.lifecycle.LifecycleCoroutineScope
import com.acs_plugin.R
import com.acs_plugin.calling.models.CallCompositeParticipantViewData
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell.ParticipantGridCellAvatarView
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell.ParticipantGridCellMoreView
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell.ParticipantGridCellVideoView
import com.acs_plugin.calling.presentation.fragment.calling.reactionoverlay.ReactionOverlayView
import com.acs_plugin.calling.service.sdk.VideoStreamRenderer
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.persona.AvatarView

@SuppressLint("ViewConstructor")
internal class ParticipantGridCellView(
    context: Context,
    private val lifecycleScope: LifecycleCoroutineScope,
    private val participantViewModel: ParticipantGridCellViewModel,
    private val showFloatingHeaderCallBack: () -> Unit,
    private val getVideoStreamCallback: (String, String) -> View?,
    private val getScreenShareVideoStreamRendererCallback: () -> VideoStreamRenderer?,
    private val getParticipantViewDataCallback: (participantID: String) -> CallCompositeParticipantViewData?,
    private val getMoreViewCallback: () -> Unit
) : RelativeLayout(context) {

    private lateinit var avatarView: ParticipantGridCellAvatarView
    private lateinit var videoView: ParticipantGridCellVideoView
    private lateinit var moreView: ParticipantGridCellMoreView

    private var isMoreParticipantsCell = false

    init {
        isMoreParticipantsCell = participantViewModel.getParticipantUserIdentifier() == ParticipantGridCellMoreView.MORE_VIEW_ID

        if (isMoreParticipantsCell) {
            inflate(context, R.layout.participant_more_view, this)
            createMoreView()
        } else {
            inflate(context, R.layout.azure_communication_ui_calling_participant_avatar_view, this)
            inflate(context, R.layout.azure_communication_ui_calling_participant_video_view, this)
            createVideoView()
            createAvatarView()
        }
    }

    fun getParticipantIdentifier() = participantViewModel.getParticipantUserIdentifier()
    fun isPrimaryParticipant() = participantViewModel.getIsPrimaryParticipant()

    fun updateParticipantViewData() {
        if (isMoreParticipantsCell) {
            if (::avatarView.isInitialized) {
                avatarView.updateParticipantViewData()
            }
            if (::videoView.isInitialized) {
                videoView.updateParticipantViewData()
            }
        } else {
            if (::moreView.isInitialized) {
                moreView.updateMoreViewData()
            }
        }
    }

    private fun createAvatarView() {
        val avatarControl: AvatarView =
            findViewById(R.id.azure_communication_ui_participant_view_avatar)

        val participantAvatarSpeakingIndicator: FrameLayout =
            findViewById(R.id.azure_communication_ui_participant_view_avatar_is_speaking_frame)

        val participantAvatarContainer: ConstraintLayout =
            findViewById(R.id.azure_communication_ui_participant_avatar_view_container)

        val displayNameAudioTextView: MaterialTextView =
            findViewById(R.id.azure_communication_ui_participant_audio_view_display_name)

        val micIndicatorAudioImageView: AppCompatImageView =
            findViewById(R.id.azure_communication_ui_participant_audio_view_mic_indicator)

        val raiseHandIndicatorAudioImageView: AppCompatImageView =
            findViewById(R.id.azure_communication_ui_participant_audio_raise_hand_indicator)

        val participantRaiseHandFrameIndicator: FrameLayout =
            findViewById(R.id.azure_communication_ui_participant_view_avatar_raised_hand_frame)

        val onHoldTextView: MaterialTextView =
            findViewById(R.id.azure_communication_ui_calling_participant_audio_view_on_hold)

        val avatarReactionOverlay: ReactionOverlayView =
            findViewById(R.id.azure_communication_ui_participant_avatar_reaction_overlay)

        avatarView = ParticipantGridCellAvatarView(
            avatarControl,
            participantAvatarSpeakingIndicator,
            participantAvatarContainer,
            displayNameAudioTextView,
            micIndicatorAudioImageView,
            raiseHandIndicatorAudioImageView,
            participantRaiseHandFrameIndicator,
            getParticipantViewDataCallback,
            participantViewModel,
            onHoldTextView,
            context,
            lifecycleScope,
            avatarReactionOverlay
        )
    }

    private fun createVideoView() {
        val participantVideoContainerFrameLayout: FrameLayout =
            findViewById(R.id.azure_communication_ui_participant_video_view_frame)

        val videoContainer: ConstraintLayout =
            findViewById(R.id.azure_communication_ui_participant_video_view_container)

        val displayNameAndMicIndicatorViewContainer: View =
            findViewById(R.id.azure_communication_ui_participant_view_on_video_information_container)

        val displayNameOnVideoTextView: MaterialTextView =
            findViewById(R.id.azure_communication_ui_participant_view_on_video_display_name)

        val micIndicatorOnVideoImageView: AppCompatImageView =
            findViewById(R.id.azure_communication_ui_participant_view_on_video_mic_indicator)

        val raiseHandIndicatorVideoImageView: AppCompatImageView =
            findViewById(R.id.azure_communication_ui_participant_view_on_video_raise_hand_indicator)

        val participantVideoRaiseHandFrameIndicator: FrameLayout =
            findViewById(R.id.azure_communication_ui_participant_video_raised_hand_frame)

        val participantReactionOverlay: ReactionOverlayView =
            findViewById(R.id.azure_communication_ui_participant_video_reaction_overlay)

        videoView = ParticipantGridCellVideoView(
            context,
            lifecycleScope,
            participantVideoContainerFrameLayout,
            videoContainer,
            displayNameAndMicIndicatorViewContainer,
            displayNameOnVideoTextView,
            micIndicatorOnVideoImageView,
            raiseHandIndicatorVideoImageView,
            participantVideoRaiseHandFrameIndicator,
            participantViewModel,
            getVideoStreamCallback,
            showFloatingHeaderCallBack,
            getScreenShareVideoStreamRendererCallback,
            getParticipantViewDataCallback,
            participantReactionOverlay
        )
    }

    private fun createMoreView() {
        val moreViewContainerFrameLayout: FrameLayout =
            findViewById(R.id.participant_more_view_container)

        val participantMoreCountTextView: MaterialTextView =
            findViewById(R.id.participant_more_count)

        moreView = ParticipantGridCellMoreView(
            lifecycleScope,
            moreViewContainerFrameLayout,
            participantMoreCountTextView,
            participantViewModel,
            getMoreViewCallback
        )
    }
}
