// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import android.content.Context
import android.util.AttributeSet
import android.view.accessibility.AccessibilityEvent
import android.widget.FrameLayout
import android.widget.ProgressBar
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import com.acs_plugin.R
import com.acs_plugin.extension.onSingleClickListener

internal class JoinCallButtonHolderView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var setupJoinCallButton: FrameLayout
    private lateinit var setupJoinCallButtonBackground: AppCompatImageView
    private lateinit var setupJoinCallButtonText: AppCompatTextView

    private lateinit var progressBar: ProgressBar
    private lateinit var joiningCallText: AppCompatTextView

    private lateinit var viewModel: JoinCallButtonHolderViewModel

    override fun onFinishInflate() {
        super.onFinishInflate()
        setupJoinCallButton = findViewById(R.id.setup_join_call_button)
        setupJoinCallButtonBackground = findViewById(R.id.setup_join_call_button_background)
        setupJoinCallButtonText = findViewById(R.id.azure_communication_ui_setup_start_call_button_text)
        progressBar = findViewById(R.id.azure_communication_ui_setup_start_call_progress_bar)
        joiningCallText = findViewById(R.id.azure_communication_ui_setup_start_call_joining_text)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        viewModel: JoinCallButtonHolderViewModel
    ) {
        this.viewModel = viewModel
        setupJoinCallButtonText.text = context.getString(R.string.azure_communication_ui_calling_setup_view_button_join_call)

        setupJoinCallButton.onSingleClickListener {
            viewModel.launchCallScreen()
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.getJoinCallButtonEnabledFlow().collect {
                onJoinCallEnabledChanged(it)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.getDisableJoinCallButtonFlow().collect { onDisableJoinCallButtonChanged(it) }
        }

        if (viewModel.isStartCall()) {
            setupJoinCallButtonText.text = context.getString(R.string.azure_communication_ui_calling_setup_view_start_call)
            joiningCallText.text = context.getString(R.string.azure_communication_ui_calling_setup_view_button_starting_call)
        } else {
            setupJoinCallButtonText.text = context.getString(R.string.azure_communication_ui_calling_setup_view_button_join_call)
            joiningCallText.text = context.getString(R.string.azure_communication_ui_calling_setup_view_button_connecting_call)
        }
    }

    private fun onJoinCallEnabledChanged(isEnabled: Boolean) {
        setupJoinCallButton.isEnabled = isEnabled
        setupJoinCallButtonBackground.isEnabled = isEnabled
        setupJoinCallButtonText.isEnabled = isEnabled
    }

    private fun onDisableJoinCallButtonChanged(isBlocked: Boolean) {
        if (isBlocked) {
            setupJoinCallButton.visibility = GONE
            setupJoinCallButtonText.visibility = INVISIBLE
            progressBar.visibility = VISIBLE
            joiningCallText.visibility = VISIBLE

            joiningCallText.sendAccessibilityEvent(AccessibilityEvent.TYPE_VIEW_FOCUSED)
        } else {
            setupJoinCallButton.visibility = VISIBLE
            setupJoinCallButtonText.visibility = VISIBLE
            progressBar.visibility = GONE
            joiningCallText.visibility = GONE
        }
    }
}
