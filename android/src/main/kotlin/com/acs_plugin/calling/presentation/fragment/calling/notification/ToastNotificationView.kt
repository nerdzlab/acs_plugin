// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.notification

import android.content.Context
import android.util.AttributeSet
import android.view.LayoutInflater
import android.widget.LinearLayout
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch

internal class ToastNotificationView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var notificationContainer: LinearLayout
    private lateinit var toastNotificationViewModel: ToastNotificationViewModel

    override fun onFinishInflate() {
        super.onFinishInflate()
        notificationContainer = findViewById(R.id.azure_communication_ui_calling_toast_notification_container)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        toastNotificationViewModel: ToastNotificationViewModel,
    ) {
        this.toastNotificationViewModel = toastNotificationViewModel

        viewLifecycleOwner.lifecycleScope.launch {
            toastNotificationViewModel.displayedNotificationsFlow.collect {
                notificationContainer.removeAllViews()

                val inflater = LayoutInflater.from(context)

                for (item in it) {
                    val itemView = inflater.inflate(R.layout.azure_communication_ui_calling_toast_notification_item, notificationContainer, false)

                    val icon = itemView.findViewById<AppCompatImageView>(R.id.azure_communication_ui_calling_toast_notification_icon)
                    val text = itemView.findViewById<MaterialTextView>(R.id.azure_communication_ui_calling_toast_notification_message)

                    icon.setImageDrawable(ContextCompat.getDrawable(context, item.notificationIconId))
                    text.text = context.getString(item.notificationMessageId)

                    notificationContainer.addView(itemView)
                }
            }
        }
    }

    fun stop() {
        this.removeAllViews()
    }
}
