// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.notification

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch

internal class UpperMessageBarNotificationView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var upperMessageBarNotificationLayout: ConstraintLayout
    private lateinit var upperMessageBarNotificationView: View
    private lateinit var upperMessageBarNotificationIconImageView: AppCompatImageView
    private lateinit var upperMessageBarNotificationMessage: MaterialTextView
    private lateinit var dismissImageButton: AppCompatImageView
    private lateinit var upperMessageBarNotificationViewModel: UpperMessageBarNotificationViewModel

    override fun onFinishInflate() {
        super.onFinishInflate()
        upperMessageBarNotificationLayout = this
        upperMessageBarNotificationView = findViewById(R.id.azure_communication_ui_calling_upper_message_bar_notification)
        upperMessageBarNotificationMessage =
            findViewById(R.id.azure_communication_ui_calling_upper_message_bar_notification_message)
        upperMessageBarNotificationIconImageView =
            findViewById(R.id.azure_communication_ui_calling_upper_message_bar_notification_icon)
        dismissImageButton =
            findViewById(R.id.azure_communication_ui_calling_upper_message_bar_notification_dismiss_button)
        dismissImageButton.onSingleClickListener {
            upperMessageBarNotificationViewModel.dismissNotificationByUser()
        }
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        upperMessageBarNotificationViewModel: UpperMessageBarNotificationViewModel,
    ) {
        this.upperMessageBarNotificationViewModel = upperMessageBarNotificationViewModel
        setupAccessibility()

        upperMessageBarNotificationLayout.visibility = VISIBLE
        viewLifecycleOwner.lifecycleScope.launch {
            upperMessageBarNotificationViewModel.getUpperMessageBarNotificationModelFlow().collect {
                if (!it.isEmpty()) {
                    upperMessageBarNotificationIconImageView.setImageDrawable(
                        ContextCompat.getDrawable(
                            context,
                            it.notificationIconId
                        )
                    )
                    upperMessageBarNotificationMessage.text = context.getString(it.notificationMessageId)
                }
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            upperMessageBarNotificationViewModel.getDismissUpperMessageBarNotificationFlow().collect {
                if (it) {
                    val viewGroup = upperMessageBarNotificationLayout.parent as ViewGroup
                    viewGroup.removeView(upperMessageBarNotificationLayout)
                }
            }
        }
    }

    private fun setupAccessibility() {
        dismissImageButton.contentDescription = context.getString(R.string.azure_communication_ui_calling_notification_dismiss_accessibility_label)
    }
}
