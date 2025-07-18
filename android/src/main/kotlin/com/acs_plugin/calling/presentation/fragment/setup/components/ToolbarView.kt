// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup.components

import android.content.Context
import android.text.TextUtils
import android.util.AttributeSet
import android.widget.LinearLayout
import androidx.appcompat.widget.AppCompatImageView
import com.acs_plugin.R
import com.acs_plugin.calling.logger.Logger
import com.acs_plugin.calling.models.CallCompositeLocalOptions
import com.acs_plugin.extension.applyStatusBarInsetMarginTop
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView

internal class ToolbarView : LinearLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var navigationButton: AppCompatImageView
    private lateinit var toolbarTitle: MaterialTextView
    private lateinit var toolbarSubtitle: MaterialTextView
    private lateinit var logger: Logger
    private var callCompositeLocalOptions: CallCompositeLocalOptions? = null

    override fun onFinishInflate() {
        super.onFinishInflate()
        navigationButton = findViewById(R.id.azure_communication_ui_navigation_button)
        navigationButton.applyStatusBarInsetMarginTop()
        toolbarTitle = findViewById(R.id.azure_communication_ui_toolbar_title)
        toolbarSubtitle = findViewById(R.id.azure_communication_ui_toolbar_subtitle)
    }

    fun start(
        callCompositeLocalOptions: CallCompositeLocalOptions?,
        logger: Logger,
        exitComposite: () -> Unit
    ) {
        this.callCompositeLocalOptions = callCompositeLocalOptions
        this.logger = logger
        setActionBarTitleSubtitle()
        navigationButton.onSingleClickListener {
            exitComposite()
        }
    }

    fun stop() {
        // to fix memory leak
        rootView.invalidate()
    }

    private fun setActionBarTitleSubtitle() {
        val localOptions = callCompositeLocalOptions
        val titleText = if (!TextUtils.isEmpty(localOptions?.setupScreenViewData?.title)) {
            localOptions?.setupScreenViewData?.title
        } else {
            context.getString(R.string.start_your_call)
        }

        toolbarTitle.text = titleText

        val subtitleText = if (!localOptions?.setupScreenViewData?.subtitle.isNullOrEmpty()) {
            localOptions.setupScreenViewData?.subtitle
        } else {
            context.getString(R.string.check_your_video_audio)
        }

        toolbarSubtitle.text = subtitleText
    }
}
