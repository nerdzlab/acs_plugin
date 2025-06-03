// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.lobby

import android.content.Context
import android.util.AttributeSet
import android.view.View
import androidx.appcompat.widget.AppCompatImageView
import androidx.constraintlayout.widget.ConstraintLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch

internal class LobbyHeaderView : ConstraintLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var lobbyHeaderView: LobbyHeaderView
    private lateinit var headerLayout: ConstraintLayout
    private lateinit var closeButton: AppCompatImageView
    private lateinit var lobbyHeaderViewModel: LobbyHeaderViewModel
    private lateinit var displayParticipantListCallback: () -> Unit
    private lateinit var participantListButton: MaterialTextView

    override fun onFinishInflate() {
        super.onFinishInflate()
        lobbyHeaderView = this
        headerLayout = findViewById(R.id.azure_communication_ui_calling_lobby_header)
        closeButton = findViewById(R.id.azure_communication_ui_calling_lobby_close_button)
        closeButton.onSingleClickListener {
            closeLobbyHeaderView()
        }
        participantListButton = findViewById(R.id.azure_communication_ui_calling_lobby_open_list_button)
        participantListButton.onSingleClickListener {
            displayParticipantListCallback()
        }
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        lobbyHeaderViewModel: LobbyHeaderViewModel,
        displayParticipantList: () -> Unit
    ) {
        this.lobbyHeaderViewModel = lobbyHeaderViewModel
        this.displayParticipantListCallback = displayParticipantList
        setupAccessibility()

        viewLifecycleOwner.lifecycleScope.launch {
            lobbyHeaderViewModel.getDisplayLobbyHeaderFlow().collect {
                lobbyHeaderView.visibility = if (it) View.VISIBLE else View.GONE
            }
        }
    }

    private fun setupAccessibility() {
        participantListButton.contentDescription = context.getString(R.string.azure_communication_ui_calling_lobby_header_accessibility_label)
    }

    private fun closeLobbyHeaderView() {
        lobbyHeaderViewModel.close()
    }
}
