// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.header

import android.content.Context
import android.util.AttributeSet
import android.view.View
import android.widget.ImageButton
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.core.view.ViewCompat
import androidx.core.view.isVisible
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.MultitaskingCallCompositeActivity
import com.acs_plugin.calling.utilities.isAndroidTV
import com.acs_plugin.calling.utilities.launchAll
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.util.activity

internal class InfoHeaderView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var floatingHeader: ConstraintLayout
    private lateinit var headerView: View
    private lateinit var participantNumberText: MaterialTextView
    private lateinit var subtitleText: MaterialTextView
    /* <CALL_START_TIME>
    private lateinit var callDurationText: MaterialTextView
    </CALL_START_TIME> */
    private lateinit var displayParticipantsImageButton: AppCompatImageView
    private lateinit var backButton: AppCompatImageView
    private lateinit var customButton1: ImageButton
    private lateinit var customButton2: ImageButton
    private lateinit var chatButton: AppCompatImageView
    private lateinit var infoHeaderViewModel: InfoHeaderViewModel
    private lateinit var displayParticipantListCallback: () -> Unit

    override fun onFinishInflate() {
        super.onFinishInflate()
        floatingHeader = this
        headerView = findViewById(R.id.azure_communication_ui_call_floating_header)
        participantNumberText =
            findViewById(R.id.azure_communication_ui_call_participant_number_text)
        subtitleText = findViewById(R.id.azure_communication_ui_call_header_subtitle)
        /* <CALL_START_TIME>
        callDurationText = findViewById(R.id.azure_communication_ui_call_header_duration)
        </CALL_START_TIME> */
        displayParticipantsImageButton =
            findViewById(R.id.azure_communication_ui_call_bottom_drawer_button)
        displayParticipantsImageButton.onSingleClickListener {
            displayParticipantListCallback()
        }
        backButton = findViewById(R.id.azure_communication_ui_call_header_back_button)

        backButton.onSingleClickListener {
            if (infoHeaderViewModel.multitaskingEnabled) {
                (context.activity as? MultitaskingCallCompositeActivity)?.hide()
            } else {
                infoHeaderViewModel.requestCallEnd()
            }
        }
//        customButton1 = findViewById(R.id.azure_communication_ui_call_header_custom_button_1)
//        customButton2 = findViewById(R.id.azure_communication_ui_call_header_custom_button_2)
        chatButton = findViewById(R.id.azure_communication_ui_call_info_header_chat_button)
        chatButton.onSingleClickListener { infoHeaderViewModel.onChatButtonClicked() }
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        infoHeaderViewModel: InfoHeaderViewModel,
        displayParticipantList: () -> Unit,
    ) {
        this.infoHeaderViewModel = infoHeaderViewModel
        this.displayParticipantListCallback = displayParticipantList
        setupAccessibility()
        viewLifecycleOwner.lifecycleScope.launchAll(
            {
                infoHeaderViewModel.getIsVisible().collect {
                    floatingHeader.visibility = if (it) View.VISIBLE else View.GONE
                    // If we are on television, set the focus to the participants button
                    if (it && isAndroidTV(context)) {
                        displayParticipantsImageButton.requestFocus()
                    }
                }
            },
            {
                infoHeaderViewModel.getTitleStateFlow().collect {
                    if (it.isNullOrEmpty()) {
                        return@collect
                    }
                    participantNumberText.text = it
                }
            },
            {
                infoHeaderViewModel.getSubtitleStateFlow().collect {
                    if (it.isNullOrEmpty()) {
                        subtitleText.visibility = View.GONE
                        return@collect
                    }
                    subtitleText.text = it
                    subtitleText.visibility = View.VISIBLE
                }
            },
            {
                infoHeaderViewModel.getNumberOfParticipantsFlow().collect {
                    if (!infoHeaderViewModel.getTitleStateFlow().value.isNullOrEmpty()) {
                        return@collect
                    }

                    participantNumberText.text = when (it) {
                        0 -> context.getString(R.string.azure_communication_ui_calling_view_info_header_waiting_for_others_to_join)

                        1 -> context.getString(R.string.azure_communication_ui_calling_view_info_header_call_with_1_person)

                        else -> resources.getString(
                            R.string.azure_communication_ui_calling_view_info_header_call_with_n_people,
                            it
                        )
                    }
                }
            },
            {
                infoHeaderViewModel.getIsOverlayDisplayedFlow().collect {
                    if (it) {
                        ViewCompat.setImportantForAccessibility(
                            headerView,
                            ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS
                        )
                    } else {
                        ViewCompat.setImportantForAccessibility(
                            headerView,
                            ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_YES
                        )
                    }
                }
            },
            {
                infoHeaderViewModel.getChatButtonVisibilityStateFlow().collect {
                    chatButton.isVisible = it
                }
            },
//            {
//                infoHeaderViewModel.getCustomButton1StateFlow().collect { button ->
//                    updateCustomButton(button, customButton1)
//                }
//            },
//            {
//                infoHeaderViewModel.getCustomButton2StateFlow().collect { button ->
//                    updateCustomButton(button, customButton2)
//                }
//            },
            /* <CALL_START_TIME>
            {
                infoHeaderViewModel.getDisplayCallDurationFlow().collect {
                    callDurationText.isVisible = it
                }
            },
            {
                infoHeaderViewModel.getCallDurationFlow().collect {
                    callDurationText.text = it
                }
            }
            </CALL_START_TIME> */
        )
    }

    private fun updateCustomButton(customButtonEntry: InfoHeaderViewModel.CustomButtonEntry?, customButton: ImageButton) {
        customButton.visibility = if (customButtonEntry?.isVisible == true) View.VISIBLE else View.GONE
        customButtonEntry?.let {
            customButton.isEnabled = customButtonEntry.isEnabled
            customButton.setImageResource(customButtonEntry.icon)
            customButton.setOnClickListener {
                infoHeaderViewModel.onCustomButtonClicked(context, customButtonEntry.id)
            }
        }
    }

    private fun setupAccessibility() {
        displayParticipantsImageButton.contentDescription = context.getString(R.string.azure_communication_ui_calling_view_participant_list_open_accessibility_label)
        backButton.contentDescription = context.getString(R.string.azure_communication_ui_calling_view_go_back)
    }
}
