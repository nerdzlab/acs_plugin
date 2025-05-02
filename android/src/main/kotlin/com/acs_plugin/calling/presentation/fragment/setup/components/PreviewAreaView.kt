// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import android.content.Context
import android.util.AttributeSet
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.azure.android.communication.calling.ScalingMode
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.VideoViewManager
import com.acs_plugin.calling.utilities.isAndroidTV
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

internal class PreviewAreaView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var viewModel: PreviewAreaViewModel
    private lateinit var videoViewManager: VideoViewManager
    private lateinit var localParticipantCameraHolder: ConstraintLayout

    override fun onFinishInflate() {
        super.onFinishInflate()
        localParticipantCameraHolder =
            findViewById(R.id.azure_communication_ui_setup_local_video_holder)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        localParticipantRendererViewModel: PreviewAreaViewModel,
        videoViewManager: VideoViewManager,
    ) {

        this.viewModel = localParticipantRendererViewModel
        this.videoViewManager = videoViewManager

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.getVideoStreamIDStateFlow().collect {
                createLocalParticipantView(it)
            }
        }
    }

    private fun createLocalParticipantView(videoStreamID: String?) {
        videoViewManager.updateLocalVideoRenderer(videoStreamID)

        if (!videoStreamID.isNullOrEmpty()) {
            localParticipantCameraHolder.removeAllViews()
            videoViewManager.getLocalVideoRenderer(
                videoStreamID,
                if (isAndroidTV(localParticipantCameraHolder.context)) ScalingMode.FIT else ScalingMode.CROP
            )?.let { view ->
                view.background = this.context.let {
                    ContextCompat.getDrawable(
                        it,
                        R.drawable.azure_communication_ui_calling_corner_radius_rectangle_4dp
                    )
                }
                localParticipantCameraHolder.addView(view, 0)
            }
        } else {
            localParticipantCameraHolder.removeAllViews()
        }
    }
}
