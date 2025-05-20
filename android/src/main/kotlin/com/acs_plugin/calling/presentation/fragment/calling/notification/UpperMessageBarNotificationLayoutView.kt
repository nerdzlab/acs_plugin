// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.notification

import android.content.Context
import android.util.AttributeSet
import android.widget.LinearLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import kotlinx.coroutines.launch

internal class UpperMessageBarNotificationLayoutView : LinearLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var upperMessageBarNotificationLayout: LinearLayout

    private lateinit var upperMessageBarNotificationLayoutViewModel: UpperMessageBarNotificationLayoutViewModel

    override fun onFinishInflate() {
        super.onFinishInflate()
        upperMessageBarNotificationLayout = this
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        upperMessageBarNotificationLayoutViewModel: UpperMessageBarNotificationLayoutViewModel,
    ) {
        this.upperMessageBarNotificationLayoutViewModel = upperMessageBarNotificationLayoutViewModel
        upperMessageBarNotificationLayout.visibility = VISIBLE

        viewLifecycleOwner.lifecycleScope.launch {
            upperMessageBarNotificationLayoutViewModel.getNewUpperMessageBarNotificationFlow().collect {
                if (!it.upperMessageBarNotificationModel.isEmpty()) {
                    val upperMessageBarNotificationView: UpperMessageBarNotificationView = inflate(
                        context,
                        R.layout.azure_communication_ui_calling_upper_message_bar_notification,
                        null
                    ) as UpperMessageBarNotificationView
                    upperMessageBarNotificationView.start(
                        viewLifecycleOwner,
                        it,
                    )

                    val layoutParams = LayoutParams(upperMessageBarNotificationLayout.layoutParams)
                    layoutParams.bottomMargin = (8 * context.resources.displayMetrics.density).toInt()
                    upperMessageBarNotificationLayout.addView(upperMessageBarNotificationView, layoutParams)
                }
            }
        }
    }

    fun stop() {
        this.removeAllViews()
    }
}
