// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.hold

import android.content.Context
import android.content.res.Configuration
import android.graphics.PorterDuff
import android.graphics.PorterDuffColorFilter
import android.util.AttributeSet
import android.view.View
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.TextView
import androidx.appcompat.widget.AppCompatButton
import androidx.appcompat.widget.AppCompatImageView
import androidx.core.content.ContextCompat
import androidx.core.view.AccessibilityDelegateCompat
import androidx.core.view.ViewCompat
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.utilities.isAndroidTV
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.snackbar.BaseTransientBottomBar
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.snackbar.Snackbar
import com.microsoft.fluentui.R as fluentUiR
import kotlinx.coroutines.launch

internal class OnHoldOverlayView : LinearLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var waitingIcon: AppCompatImageView
    private lateinit var overlayTitle: MaterialTextView
    private lateinit var resumeButton: FrameLayout
    private lateinit var viewModel: OnHoldOverlayViewModel

    private lateinit var snackBar: Snackbar
    private lateinit var snackBarTextView: TextView

    override fun onFinishInflate() {
        super.onFinishInflate()
        waitingIcon =
            findViewById(R.id.azure_communication_ui_call_hold_overlay_wait_for_host_image)
        overlayTitle = findViewById(R.id.azure_communication_ui_call_hold_overlay_title)
        resumeButton = findViewById(R.id.azure_communication_ui_call_hold_resume_button)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        viewModel: OnHoldOverlayViewModel,
    ) {
        this.viewModel = viewModel

        setupUi()
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.getDisplayHoldOverlayFlow().collect {
                val lastVisibility = visibility
                visibility = if (it) VISIBLE else GONE
                if (isAndroidTV(context)) {
                    if (visibility == VISIBLE && lastVisibility != visibility) {
                        resumeButton.requestFocus()
                    }
                }
            }
        }

        ViewCompat.setAccessibilityDelegate(
            this,
            object : AccessibilityDelegateCompat() {
                override fun onInitializeAccessibilityNodeInfo(
                    host: View,
                    info: AccessibilityNodeInfoCompat,
                ) {
                    super.onInitializeAccessibilityNodeInfo(host, info)
                    info.removeAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_CLICK)
                    info.isClickable = false
                }
            }
        )

        initSnackBar()
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.getDisplayMicUsedToastStateFlow().collect {
                if (!it) {
                    snackBar.dismiss()
                } else {
                    displayMicInUseSnackbar()
                }
            }
        }
    }

    fun stop() {
        if (snackBar.isShown) {
            snackBar.dismiss()
        }
        rootView.invalidate()
        // to fix memory leak
        snackBar.anchorView = null
    }

    private fun displayMicInUseSnackbar() {
        val errorMessage = context.getString(R.string.azure_communication_ui_calling_mic_used)
        if (errorMessage.isBlank()) return
        snackBarTextView.text = errorMessage
        snackBar.run {
            if (isShown) {
                dismiss()
            }
            show()

            view.contentDescription =
                "${context.getString(R.string.azure_communication_ui_calling_alert_title)}: $errorMessage"
            view.accessibilityFocus()
        }
    }

    private fun initSnackBar() {
        snackBar = Snackbar.make(
            rootView,
            "",
            Snackbar.LENGTH_INDEFINITE,
            Snackbar.Style.REGULAR
        ).apply {
            animationMode = BaseTransientBottomBar.ANIMATION_MODE_FADE
            setAction(rootView.context!!.getText(R.string.azure_communication_ui_calling_snack_bar_button_dismiss)) {
            }
            if (context.resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
                anchorView =
                    rootView.findViewById(R.id.azure_communication_ui_call_call_buttons)
            }
            view.background.colorFilter = PorterDuffColorFilter(
                ContextCompat.getColor(
                    rootView.context,
                    R.color.azure_communication_ui_calling_color_snack_bar_background
                ),
                PorterDuff.Mode.SRC_IN
            )
            snackBarTextView = view.findViewById(fluentUiR.id.snackbar_text)
            snackBarTextView.setTextColor(
                ContextCompat.getColor(
                    rootView.context,
                    R.color.azure_communication_ui_calling_color_snack_bar_text_color
                )
            )
            view.findViewById<AppCompatButton>(fluentUiR.id.snackbar_action).apply {
                setTextColor(
                    ContextCompat.getColor(
                        rootView.context,
                        R.color.azure_communication_ui_calling_color_snack_bar_text_color
                    )
                )
                isAllCaps = false
                contentDescription =
                    rootView.context.getText(R.string.azure_communication_ui_calling_snack_bar_button_dismiss)
            }
        }
    }

    private fun setupUi() {
        waitingIcon.contentDescription =
            context.getString(R.string.azure_communication_ui_calling_hold_view_text)

        overlayTitle.text =
            context.getString(R.string.azure_communication_ui_calling_hold_view_text)
        resumeButton.onSingleClickListener {
            viewModel.resumeCall()
        }
    }



    private fun View.accessibilityFocus(): View {
        post {
            performAccessibilityAction(AccessibilityNodeInfo.ACTION_ACCESSIBILITY_FOCUS, null)
            sendAccessibilityEvent(AccessibilityEvent.TYPE_VIEW_SELECTED)
        }
        return this
    }
}
