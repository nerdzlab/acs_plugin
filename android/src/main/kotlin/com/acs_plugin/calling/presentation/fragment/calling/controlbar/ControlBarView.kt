// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.controlbar

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.view.accessibility.AccessibilityEvent
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.AccessibilityDelegateCompat
import androidx.core.view.ViewCompat
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.redux.state.AudioDeviceSelectionStatus
import com.acs_plugin.calling.redux.state.AudioOperationalStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.utilities.isTablet
import com.acs_plugin.calling.utilities.launchAll
import com.acs_plugin.extension.onSingleClickListener

internal class ControlBarView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var viewModel: ControlBarViewModel
    private lateinit var endCallButton: AppCompatImageView
    private lateinit var cameraToggle: AppCompatImageView
    private lateinit var micToggle: AppCompatImageView
    private lateinit var audioDeviceButton: AppCompatImageView
    private lateinit var moreButton: AppCompatImageView

    override fun onFinishInflate() {
        super.onFinishInflate()
        endCallButton = findViewById(R.id.azure_communication_ui_call_end_call_button)
        cameraToggle = findViewById(R.id.azure_communication_ui_call_cameraToggle)
        micToggle = findViewById(R.id.azure_communication_ui_call_call_audio)
        audioDeviceButton = findViewById(R.id.azure_communication_ui_call_audio_device_button)
        moreButton = findViewById(R.id.azure_communication_ui_call_control_bar_more)

        subscribeClickListener()
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        viewModel: ControlBarViewModel,
    ) {
        this.viewModel = viewModel

        setupAccessibility()
        viewLifecycleOwner.lifecycleScope.launchAll(
            {
                viewModel.audioOperationalStatus.collect {
                    updateMic(it)
                }
            },
            {
                viewModel.isCameraButtonVisible.collect {
                    cameraToggle.visibility = if (it) View.VISIBLE else View.GONE
                    updateChainStyle()
                }
            },
            {
                viewModel.isCameraButtonEnabled.collect {
                    cameraToggle.isEnabled = it
                }
            },
            {
                viewModel.cameraStatus.collect {
                    updateCamera(it)
                }
            },
            {
                viewModel.audioDeviceSelection.collect {
                    setAudioDeviceButtonState(it)
                }
            },
            {
                viewModel.isMicButtonEnabled.collect {
                    micToggle.isEnabled = it
                }
            },
            {
                viewModel.isMicButtonVisible.collect {
                    micToggle.visibility = if (it) View.VISIBLE else View.GONE
                    updateChainStyle()
                }
            },
            {
                viewModel.isAudioDeviceButtonEnabled.collect {
                    audioDeviceButton.isEnabled = it
                }
            },
            {
                viewModel.isAudioDeviceButtonVisible.collect {
                    audioDeviceButton.visibility = if (it) View.VISIBLE else View.GONE
                    updateChainStyle()
                }
            },
            {
                viewModel.isMoreButtonEnabled.collect {
                    moreButton.isEnabled = it
                }
            },
            {
                viewModel.isMoreButtonVisible.collect {
                    moreButton.visibility = if (it) View.VISIBLE else View.GONE
                    updateChainStyle()
                }
            },
            {
                viewModel.isVisible.collect {
                    visibility = if (it) View.VISIBLE else View.GONE
                }
            },
        )
    }

    private fun updateChainStyle() {
        if (isTablet(context))
            return

        val layout =
            if (viewModel.isCameraButtonVisible.value &&
                viewModel.isMicButtonVisible.value &&
                viewModel.isAudioDeviceButtonVisible.value &&
                viewModel.isMoreButtonVisible.value
            )
                LayoutParams.CHAIN_SPREAD_INSIDE
            else
                LayoutParams.CHAIN_PACKED

        (cameraToggle.layoutParams as LayoutParams).horizontalChainStyle = layout
        (cameraToggle.layoutParams as LayoutParams).verticalChainStyle = layout
        (micToggle.layoutParams as LayoutParams).horizontalChainStyle = layout
        (micToggle.layoutParams as LayoutParams).verticalChainStyle = layout
        (cameraToggle.layoutParams as LayoutParams).horizontalChainStyle = layout
        (cameraToggle.layoutParams as LayoutParams).verticalChainStyle = layout
        (audioDeviceButton.layoutParams as LayoutParams).horizontalChainStyle = layout
        (audioDeviceButton.layoutParams as LayoutParams).verticalChainStyle = layout
        (moreButton.layoutParams as LayoutParams).horizontalChainStyle = layout
        (moreButton.layoutParams as LayoutParams).verticalChainStyle = layout
        (endCallButton.layoutParams as LayoutParams).horizontalChainStyle = layout
        (endCallButton.layoutParams as LayoutParams).verticalChainStyle = layout
    }

    private fun accessibilityNonSelectableViews() = setOf(micToggle, cameraToggle)

    private val alwaysOffSelectedAccessibilityDelegate = object : AccessibilityDelegateCompat() {
        override fun onInitializeAccessibilityNodeInfo(
            host: View,
            info: AccessibilityNodeInfoCompat
        ) {
            super.onInitializeAccessibilityNodeInfo(host, info)
            if (host in accessibilityNonSelectableViews()) {
                // From an accessibility standpoint these views are never "selected"
                info.isSelected = false
            }
        }
    }

    private fun setupAccessibility() {
        ViewCompat.setAccessibilityDelegate(
            this,
            object : AccessibilityDelegateCompat() {
                override fun onRequestSendAccessibilityEvent(
                    host: ViewGroup,
                    child: View,
                    event: AccessibilityEvent
                ): Boolean {
                    if (child in accessibilityNonSelectableViews() && event.eventType == AccessibilityEvent.TYPE_VIEW_SELECTED) {
                        // We don't want Accessibility TalkBock to read out the "Selected" status of
                        // these views because that's just the way we've internally set up the
                        // icons to have different drawables based on the current status
                        return false
                    }
                    return super.onRequestSendAccessibilityEvent(host, child, event)
                }
            }
        )
        ViewCompat.setAccessibilityDelegate(micToggle, alwaysOffSelectedAccessibilityDelegate)
        ViewCompat.setAccessibilityDelegate(cameraToggle, alwaysOffSelectedAccessibilityDelegate)

        endCallButton.contentDescription = context.getString(R.string.azure_communication_ui_calling_view_button_hang_up_accessibility_label)

        audioDeviceButton.contentDescription = context.getString(R.string.azure_communication_ui_calling_view_button_device_options_accessibility_label)
    }

    private fun updateCamera(cameraOperationalStatus: CameraOperationalStatus) {
        when (cameraOperationalStatus) {
            CameraOperationalStatus.ON -> {
                cameraToggle.isSelected = true
                cameraToggle.setImageResource(R.drawable.ic_camera)
                cameraToggle.contentDescription =
                    context.getString(R.string.azure_communication_ui_calling_setup_view_button_video_on)
            }

            CameraOperationalStatus.OFF -> {
                cameraToggle.isSelected = false
                cameraToggle.setImageResource(R.drawable.ic_camera_off)
                cameraToggle.contentDescription =
                    context.getString(R.string.azure_communication_ui_calling_setup_view_button_video_off)
            }

            else -> {}
        }
    }

    private fun updateMic(audioOperationalStatus: AudioOperationalStatus) {
        when (audioOperationalStatus) {
            AudioOperationalStatus.ON -> {
                // show un-mute icon
                micToggle.isSelected = true
                micToggle.setImageResource(R.drawable.ic_microphone)
                micToggle.contentDescription = context.getString(R.string.azure_communication_ui_calling_setup_view_button_mic_on)
            }
            AudioOperationalStatus.OFF -> {
                // show mute icon
                micToggle.isSelected = false
                micToggle.setImageResource(R.drawable.ic_microphone_off)
                micToggle.contentDescription = context.getString(R.string.azure_communication_ui_calling_setup_view_button_mic_off)
            }
            else -> {}
        }
    }

    private fun setAudioDeviceButtonState(audioDeviceSelectionStatus: AudioDeviceSelectionStatus) {
        when (audioDeviceSelectionStatus) {
            AudioDeviceSelectionStatus.SPEAKER_SELECTED -> {
                audioDeviceButton.setImageResource(
                    R.drawable.ic_speaker
                )
            }
            AudioDeviceSelectionStatus.RECEIVER_SELECTED -> {
                audioDeviceButton.setImageResource(
                    R.drawable.ic_speaker
                )
            }
            AudioDeviceSelectionStatus.BLUETOOTH_SCO_SELECTED -> {
                audioDeviceButton.setImageResource(
                    R.drawable.ic_speaker_bluetooth
                )
            }
            AudioDeviceSelectionStatus.AUDIO_OFF_SELECTED -> {
                audioDeviceButton.setImageResource(
                    R.drawable.ic_speaker_off
                )
            }
            else -> {}
        }
    }

    private fun subscribeClickListener() {
        endCallButton.onSingleClickListener {
            viewModel.requestCallEnd()
        }
        micToggle.onSingleClickListener {
            viewModel.micButtonClicked(context)
            if (micToggle.isSelected) {
                viewModel.turnMicOff()
            } else {
                viewModel.turnMicOn()
            }
            postDelayed({ micToggle.requestFocus() }, 33)
        }
        cameraToggle.onSingleClickListener {
            viewModel.cameraButtonClicked(context)
            if (cameraToggle.isSelected) {
                viewModel.turnCameraOff()
            } else {
                viewModel.turnCameraOn()
            }
            postDelayed({ cameraToggle.requestFocus() }, 33)
        }
        audioDeviceButton.onSingleClickListener {
            viewModel.onAudioDeviceClick(context)
            viewModel.openAudioDeviceSelectionMenu()
        }
        moreButton.onSingleClickListener {
            viewModel.openMoreMenu()
        }
    }
}
