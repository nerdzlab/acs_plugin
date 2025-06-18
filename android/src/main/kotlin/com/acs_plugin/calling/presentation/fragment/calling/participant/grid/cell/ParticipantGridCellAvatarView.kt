// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell

import android.content.Context
import android.view.View
import android.view.View.GONE
import android.view.View.VISIBLE
import android.view.View.INVISIBLE
import android.widget.FrameLayout
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleCoroutineScope
import com.acs_plugin.R
import com.acs_plugin.calling.models.CallCompositeParticipantViewData
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.ParticipantGridCellViewModel
import com.acs_plugin.calling.presentation.fragment.calling.reactionoverlay.ReactionOverlayView
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.persona.AvatarView
import com.microsoft.fluentui.util.isVisible
import kotlinx.coroutines.launch

internal class ParticipantGridCellAvatarView(
    private val avatarView: AvatarView,
    private val participantAvatarSpeakingFrameLayout: FrameLayout,
    private val participantContainer: ConstraintLayout,
    displayNameAndMicIndicatorViewContainer: View,
    private val displayNameAudioTextView: MaterialTextView,
    private val micIndicatorAudioImageView: AppCompatImageView,
    private val raiseHandIndicatorAudioImageView: AppCompatImageView,
    private val participantRaiseHandFrameIndicator: FrameLayout,
    private val getParticipantViewDataCallback: (participantID: String) -> CallCompositeParticipantViewData?,
    private val participantViewModel: ParticipantGridCellViewModel,
    private val onHoldTextView: MaterialTextView,
    private val context: Context,
    lifecycleScope: LifecycleCoroutineScope,
    private val reactionOverlayView: ReactionOverlayView,
    private val showParticipantMenuCallback: (participantID: String) -> Unit?
) {
    private var lastParticipantViewData: CallCompositeParticipantViewData? = null

    init {
        displayNameAndMicIndicatorViewContainer.onSingleClickListener {
            showParticipantMenuCallback(participantViewModel.getParticipantUserIdentifier())
        }

        lifecycleScope.launch {
            participantViewModel.getDisplayNameStateFlow().collect {
                lastParticipantViewData = null
                setDisplayName(it)
                updateParticipantViewData()
            }
        }

        lifecycleScope.launch {
            participantViewModel.showCallingTextStateFlow().collect {
                lastParticipantViewData = null
                updateParticipantViewData()
            }
        }

        lifecycleScope.launch {
            participantViewModel.getIsMutedStateFlow().collect {
                setMicButtonVisibility(it)
            }
        }

        lifecycleScope.launch {
            participantViewModel.getIsOnHoldStateFlow().collect {
                if (it) {
                    onHoldTextView.visibility = VISIBLE
                    micIndicatorAudioImageView.visibility = GONE
                } else {
                    onHoldTextView.visibility = INVISIBLE
                    setMicButtonVisibility(participantViewModel.getIsMutedStateFlow().value)
                }
            }
        }

        lifecycleScope.launch {
            participantViewModel.getIsSpeakingStateFlow().collect {
                setSpeakingIndicator(it)
            }
        }

        lifecycleScope.launch {
            participantViewModel.getVideoViewModelStateFlow().collect {
                if (it != null) {
                    participantContainer.visibility = INVISIBLE
                } else {
                    participantContainer.visibility = VISIBLE
                }
            }
        }

        lifecycleScope.launch {
            participantViewModel.getIsRaisedHandStateFlow().collect {
                setRaisedHandIndicator(it)
            }
        }

        lifecycleScope.launch {
            participantViewModel.getReactionTypeStateFlow().collect {
                reactionOverlayView.show(it) {
                    participantViewModel.onReactionShown()
                }
            }
        }
    }

    fun updateParticipantViewData() {
        val participantViewData =
            getParticipantViewDataCallback(participantViewModel.getParticipantUserIdentifier())
        if (participantViewData == null) {
            // force bitmap update be setting resource to 0
            avatarView.setImageResource(0)
            setDisplayName(participantViewModel.getDisplayNameStateFlow().value)
        } else if (lastParticipantViewData != participantViewData) {
            lastParticipantViewData = participantViewData

            avatarView.avatarImageBitmap = participantViewData.avatarBitmap
            avatarView.adjustViewBounds = true
            participantViewData.scaleType?.let { scaleType ->
                avatarView.scaleType = scaleType
            }
            participantViewData.displayName?.let { displayName ->
                setDisplayName(displayName)
            }
        }
    }

    private fun setTextViewDisplayName(displayName: String) {
        if (participantViewModel.showCallingTextStateFlow().value) {
            displayNameAudioTextView.visibility = VISIBLE
            displayNameAudioTextView.text = context.getString(R.string.azure_communication_ui_calling_call_view_calling)
            return
        }

        if (displayName.isBlank()) {
            displayNameAudioTextView.visibility = GONE
        } else {
            displayNameAudioTextView.visibility = VISIBLE
            displayNameAudioTextView.text = displayName
        }
    }

    private fun setSpeakingIndicator(
        isSpeaking: Boolean,
    ) {
        if (isSpeaking) {
            participantAvatarSpeakingFrameLayout.background = ContextCompat.getDrawable(
                context,
                R.drawable.bg_rounded_purple_frame_r12
            )
        } else {
            participantAvatarSpeakingFrameLayout.setBackgroundResource(0)
        }
    }

    private fun setRaisedHandIndicator(isRaisedHand: Boolean) {
        raiseHandIndicatorAudioImageView.isVisible = isRaisedHand
        participantRaiseHandFrameIndicator.isVisible = isRaisedHand
    }

    private fun setDisplayName(displayName: String) {
        avatarView.name = displayName
        avatarView.invalidate()
        setTextViewDisplayName(displayName)
    }

    private fun setMicButtonVisibility(isMicButtonVisible: Boolean) {
        if (!isMicButtonVisible) {
            micIndicatorAudioImageView.visibility = GONE
        } else {
            micIndicatorAudioImageView.visibility = VISIBLE
        }
    }
}
