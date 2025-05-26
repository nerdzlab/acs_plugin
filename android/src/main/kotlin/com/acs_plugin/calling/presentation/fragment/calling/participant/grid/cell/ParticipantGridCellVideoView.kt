// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell

import android.content.Context
import android.view.View
import android.view.View.INVISIBLE
import android.view.View.VISIBLE
import android.view.View.GONE
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleCoroutineScope
import com.acs_plugin.R
import com.acs_plugin.calling.models.StreamType
import com.acs_plugin.calling.models.CallCompositeParticipantViewData
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.ParticipantGridCellViewModel
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.VideoViewModel
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.screenshare.ScreenShareViewManager
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.screenshare.ScreenShareZoomFrameLayout
import com.acs_plugin.calling.service.sdk.VideoStreamRenderer
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.util.isVisible
import kotlinx.coroutines.launch

internal class ParticipantGridCellVideoView(
    private val context: Context,
    lifecycleScope: LifecycleCoroutineScope,
    private val participantVideoContainerSpeakingFrameLayout: FrameLayout,
    private val videoContainer: ConstraintLayout,
    private val displayNameAndMicIndicatorViewContainer: View,
    private val displayNameOnVideoTextView: MaterialTextView,
    private val micIndicatorOnVideoImageView: AppCompatImageView,
    private val raiseHandIndicatorVideoImageView: AppCompatImageView,
    private val participantVideoRaiseHandFrameIndicator: FrameLayout,
    private val participantViewModel: ParticipantGridCellViewModel,
    private val getVideoStreamCallback: (String, String) -> View?,
    private val showFloatingHeaderCallBack: () -> Unit,
    private val getScreenShareVideoStreamRendererCallback: () -> VideoStreamRenderer?,
    private val getParticipantViewDataCallback: (participantID: String) -> CallCompositeParticipantViewData?,
) {
    private var videoStream: View? = null
    private var screenShareZoomFrameLayout: ScreenShareZoomFrameLayout? = null
    private var lastParticipantViewData: CallCompositeParticipantViewData? = null

    init {
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
            participantViewModel.getIsNameIndicatorVisibleStateFlow().collect {
                setNameAndMicIndicatorViewVisibility(it)
            }
        }

        lifecycleScope.launch {
            participantViewModel.getIsSpeakingStateFlow().collect {
                setSpeakingIndicator(it)
            }
        }
        lifecycleScope.launch {
            participantViewModel.getVideoViewModelStateFlow().collect {
                updateVideoStream(it)
                if (it != null) {
                    videoContainer.visibility = VISIBLE
                } else {
                    videoContainer.visibility = INVISIBLE
                }
            }
        }
        lifecycleScope.launch {
            participantViewModel.getIsRaisedHandStateFlow().collect {
                setRaisedHandIndicator(it)
            }
        }
    }

    fun updateParticipantViewData() {
        val participantViewData =
            getParticipantViewDataCallback(participantViewModel.getParticipantUserIdentifier())
        if (participantViewData == null) {
            setDisplayName(participantViewModel.getDisplayNameStateFlow().value)
        } else if (lastParticipantViewData != participantViewData) {
            lastParticipantViewData = participantViewData
            participantViewData.displayName?.let { displayName ->
                setDisplayName(displayName)
            }
        }
    }

    private fun updateVideoStream(
        videoViewModel: VideoViewModel?,
    ) {
        if (videoStream != null) {
            detachFromParentView(videoStream)
            videoStream = null
        }

        if (videoViewModel != null) {
            getVideoStreamCallback(
                participantViewModel.getParticipantUserIdentifier(),
                videoViewModel.videoStreamID
            )?.let { view ->
                videoStream = view
                setRendererView(view, videoViewModel.streamType)
            }
        } else {
            removeScreenShareZoomView()
        }
    }

    private fun removeScreenShareZoomView() {
        if (screenShareZoomFrameLayout != null) {
            // removing this code will cause issue when new user share screen (zoom will not work)
            screenShareZoomFrameLayout?.removeAllViews()
            videoContainer.removeView(screenShareZoomFrameLayout)
            screenShareZoomFrameLayout = null
            videoContainer.invalidate()
        }
    }

    private fun setSpeakingIndicator(
        isSpeaking: Boolean,
    ) {
        if (isSpeaking) {
            participantVideoContainerSpeakingFrameLayout.visibility = VISIBLE
        } else {
            participantVideoContainerSpeakingFrameLayout.visibility = GONE
        }
    }

    private fun setRendererView(rendererView: View, streamType: StreamType) {
        detachFromParentView(rendererView)

        if (streamType == StreamType.SCREEN_SHARING) {
            removeScreenShareZoomView()
            val screenShareFactory = ScreenShareViewManager(
                context,
                videoContainer,
                getScreenShareVideoStreamRendererCallback,
                showFloatingHeaderCallBack
            )
            screenShareZoomFrameLayout = screenShareFactory.getScreenShareView(rendererView)
            videoContainer.addView(screenShareZoomFrameLayout, 0)
            // scaled transformed view round corners are not visible when scroll is not at end
            // to avoid content outside speaking rectangle removing round corners
            videoContainer.background = ContextCompat.getDrawable(
                context,
                R.drawable.bg_light_pink_rounded_r12
            )
            participantVideoContainerSpeakingFrameLayout.background = ContextCompat.getDrawable(
                context,
                R.drawable.bg_rounded_purple_frame_r12
            )
            participantVideoRaiseHandFrameIndicator.background = ContextCompat.getDrawable(
                context,
                R.drawable.bg_rounded_orange_frame_r12
            )
            return
        }

        rendererView.background = ContextCompat.getDrawable(
            context,
            R.drawable.bg_light_pink_rounded_r12
        )
        videoContainer.background = ContextCompat.getDrawable(
            context,
            R.drawable.bg_light_pink_rounded_r12
        )
        participantVideoContainerSpeakingFrameLayout.background = ContextCompat.getDrawable(
            context,
            R.drawable.bg_rounded_purple_frame_r12
        )
        participantVideoRaiseHandFrameIndicator.background = ContextCompat.getDrawable(
            context,
            R.drawable.bg_rounded_orange_frame_r12
        )
        videoContainer.addView(rendererView, 0)
    }

    private fun setDisplayName(displayName: String) {
        if (participantViewModel.showCallingTextStateFlow().value) {
            displayNameOnVideoTextView.visibility = VISIBLE
            displayNameOnVideoTextView.text = context.getString(R.string.azure_communication_ui_calling_call_view_calling)
            return
        }
        if (displayName.isBlank()) {
            displayNameOnVideoTextView.visibility = GONE
        } else {
            displayNameOnVideoTextView.visibility = VISIBLE
            displayNameOnVideoTextView.text = displayName
        }
    }

    private fun setMicButtonVisibility(isMicButtonVisible: Boolean) {
        if (!isMicButtonVisible) {
            micIndicatorOnVideoImageView.visibility = GONE
        } else {
            micIndicatorOnVideoImageView.visibility = VISIBLE
        }
    }

    private fun setNameAndMicIndicatorViewVisibility(isNameIndicatorVisible: Boolean) {
        if (!isNameIndicatorVisible) {
            displayNameAndMicIndicatorViewContainer.visibility = GONE
        } else {
            displayNameAndMicIndicatorViewContainer.visibility = VISIBLE
        }
    }

    private fun setRaisedHandIndicator(isRaisedHand: Boolean) {
        raiseHandIndicatorVideoImageView.isVisible = isRaisedHand
        participantVideoRaiseHandFrameIndicator.isVisible = isRaisedHand
    }

    private fun detachFromParentView(view: View?) {
        if (view != null && view.parent != null) {
            (view.parent as ViewGroup).removeView(view)
        }
    }
}
