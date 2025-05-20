// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.lobby

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.widget.LinearLayout
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.view.AccessibilityDelegateCompat
import androidx.core.view.ViewCompat
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch

internal class WaitingLobbyOverlayView : LinearLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var waitingIcon: AppCompatImageView
    private lateinit var overlayTitle: MaterialTextView
    private lateinit var overlayInfo: MaterialTextView
    private lateinit var viewModel: WaitingLobbyOverlayViewModel

    override fun onFinishInflate() {
        super.onFinishInflate()
        waitingIcon = findViewById(R.id.azure_communication_ui_call_call_lobby_overlay_wait_for_host_image)
        overlayTitle = findViewById(R.id.azure_communication_ui_call_lobby_overlay_title)
        overlayInfo = findViewById(R.id.azure_communication_ui_call_lobby_overlay_info)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        viewModel: WaitingLobbyOverlayViewModel,
    ) {
        this.viewModel = viewModel

        setupUi()
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.getDisplayLobbyOverlayFlow().collect {
                visibility = if (it) VISIBLE else GONE
            }
        }

        ViewCompat.setAccessibilityDelegate(
            this,
            object : AccessibilityDelegateCompat() {
                override fun onInitializeAccessibilityNodeInfo(host: View, info: AccessibilityNodeInfoCompat) {
                    super.onInitializeAccessibilityNodeInfo(host, info)
                    info.removeAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_CLICK)
                    info.isClickable = false
                }
            }
        )
    }

    private fun setupUi() {
        waitingIcon.contentDescription = context.getString(R.string.azure_communication_ui_calling_lobby_view_text_waiting_for_host)

        overlayTitle.text = context.getString(R.string.azure_communication_ui_calling_lobby_view_text_waiting_for_host)

        overlayInfo.text = context.getString(R.string.azure_communication_ui_calling_lobby_view_text_waiting_details)
    }
}
