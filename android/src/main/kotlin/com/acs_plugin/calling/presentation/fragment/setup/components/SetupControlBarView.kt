// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import android.content.Context
import android.util.AttributeSet
import android.widget.LinearLayout
import androidx.appcompat.content.res.AppCompatResources
import androidx.appcompat.widget.AppCompatImageView
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.redux.state.AudioDeviceSelectionStatus
import com.acs_plugin.calling.redux.state.AudioOperationalStatus
import com.acs_plugin.calling.redux.state.AudioState
import com.acs_plugin.calling.redux.state.BlurStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.extension.onSingleClickListener
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

internal class SetupControlBarView : LinearLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var viewModel: SetupControlBarViewModel
    private lateinit var micButton: AppCompatImageView
    private lateinit var cameraButton: AppCompatImageView
    private lateinit var cameraSwitchButton: AppCompatImageView
    private lateinit var cameraBlurButton: AppCompatImageView
    private lateinit var audioDeviceButton: AppCompatImageView

    private var isCameraOn: Boolean = false
    private var isMicOn: Boolean = false
    private var isBlurOn: Boolean = false

    override fun onFinishInflate() {
        super.onFinishInflate()
        micButton = findViewById(R.id.setup_mic_button)
        cameraButton = findViewById(R.id.setup_camera_button)
        cameraSwitchButton = findViewById(R.id.setup_camera_switch_button)
        cameraBlurButton = findViewById(R.id.setup_blur_button)
        audioDeviceButton = findViewById(R.id.setup_audio_button)


        micButton.onSingleClickListener { toggleAudio() }
        cameraButton.onSingleClickListener { toggleVideo() }
        cameraSwitchButton.onSingleClickListener { viewModel.switchCamera(context) }
        cameraBlurButton.onSingleClickListener { toggleBlur() }
        audioDeviceButton.onSingleClickListener { viewModel.audioDeviceClicked(context) }
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        setupControlBarViewModel: SetupControlBarViewModel,
    ) {
        viewModel = setupControlBarViewModel

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.isVisibleState.collect { visible ->
                visibility = if (visible) VISIBLE else INVISIBLE
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.cameraIsEnabled.collect {
                cameraButton.isEnabled = it
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.cameraIsVisible.collect {
                cameraButton.visibility = if (it) VISIBLE else GONE
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.cameraState.collect {
                setCameraButtonState(it)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.blurState.collect {
                setBlurButtonState(it)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.micIsEnabled.collect {
                micButton.isEnabled = it
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.micVisible.collect {
                micButton.visibility = if (it) VISIBLE else GONE
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.audioOperationalStatusStat.collect {
                setMicButtonState(it)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.switchCameraEnabled.collect {
                cameraSwitchButton.isEnabled = it
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.blurEnabled.collect {
                cameraBlurButton.isEnabled = it
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.audioDeviceButtonEnabled.collect {
                audioDeviceButton.isEnabled = it
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.audioDeviceButtonVisible.collect {
                audioDeviceButton.visibility = if (it) VISIBLE else GONE
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.audioDeviceSelectionStatusState.collect {
                setAudioDeviceButtonState(it)
            }
        }
    }

    private fun setMicButtonState(audioOperationalStatus: AudioOperationalStatus) {
        micButton.apply {
            when (audioOperationalStatus) {
                AudioOperationalStatus.ON -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_microphone))
                AudioOperationalStatus.OFF -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_microphone_off))
                else -> {}
            }
        }
    }

    private fun setCameraButtonState(operation: CameraOperationalStatus) {
        cameraButton.apply {
            when (operation) {
                CameraOperationalStatus.ON -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_camera))
                CameraOperationalStatus.OFF -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_camera_off))
                else -> {}
            }
        }
    }

    private fun setBlurButtonState(status: BlurStatus) {
        cameraBlurButton.apply {
            when (status) {
                BlurStatus.ON -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_blur))
                BlurStatus.OFF -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_blur_off))
            }
        }
    }

    private fun setAudioDeviceButtonState(audioState: AudioState) {
        audioDeviceButton.apply {
            when (audioState.device) {
                AudioDeviceSelectionStatus.SPEAKER_SELECTED -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_speaker))
                AudioDeviceSelectionStatus.RECEIVER_SELECTED -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_speaker))
                AudioDeviceSelectionStatus.BLUETOOTH_SCO_SELECTED -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_speaker_bluetooth))
                AudioDeviceSelectionStatus.AUDIO_OFF_SELECTED -> setImageDrawable(AppCompatResources.getDrawable(this.context, R.drawable.ic_speaker_off))
                else -> Unit
            }
        }
    }

    private fun toggleAudio() {
        if (isMicOn) {
            viewModel.turnMicOff(context)
        } else {
            viewModel.turnMicOn(context)
        }
        isMicOn = !isMicOn
    }

    private fun toggleVideo() {
        if (isCameraOn) {
            viewModel.turnCameraOff(context)
        } else {
            viewModel.turnCameraOn(context)
        }
        isCameraOn = !isCameraOn
    }

    private fun toggleBlur() {
        if (isBlurOn) {
            viewModel.turnBlurOff(context)
        } else {
            viewModel.turnBlurOn(context)
        }
        isBlurOn = !isBlurOn
    }
}