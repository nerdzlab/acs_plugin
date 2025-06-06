// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.menu

import android.annotation.SuppressLint
import android.content.Context
import android.view.ViewGroup.LayoutParams.WRAP_CONTENT
import android.widget.FrameLayout
import android.widget.LinearLayout
import android.widget.RelativeLayout
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data.ParticipantMenuType
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch

@SuppressLint("ViewConstructor")
internal class ParticipantMenuView(
    context: Context,
    private val viewModel: ParticipantMenuViewModel,
) : RelativeLayout(context) {

    private var participantNameTextView: MaterialTextView
    private var participantMenuContainer: LinearLayout
    private lateinit var menuDialog: BottomSheetDialog

    init {
        inflate(context, R.layout.participant_menu_list_view, this)
        participantNameTextView = findViewById(R.id.participant_name_text_view)
        participantMenuContainer = findViewById(R.id.participant_menu_list_container)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        onParticipantMenuClicked: (String, ParticipantMenuType) -> Unit
    ) {
        initializeMenuDialog()

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.displayMenuFlow.collect {
                if (it) {
                    menuDialog.show()
                } else {
                    if (menuDialog.isShowing) {
                        menuDialog.dismiss()
                    }
                }
            }
        }
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.participantNameFlow.collect {
                participantNameTextView.text = it
            }
        }
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.participantMenuItemsFlow.collect {
                participantMenuContainer.removeAllViews()
                it.forEach { item ->
                    val menuView = ParticipantMenuItemView(context)
                    menuView.setAction(item) { menuType ->
                        menuDialog.dismiss()
                        viewModel.userIdentifier?.let { id -> onParticipantMenuClicked(id, menuType) }
                    }
                    participantMenuContainer.addView(menuView)
                }
            }
        }
    }

    fun stop() {
        menuDialog.dismiss()
        this.removeAllViews()
    }

    private fun initializeMenuDialog() {
        menuDialog = BottomSheetDialog(context, R.style.RoundedBottomSheetDialog).apply {
            setContentView(this@ParticipantMenuView)
            setOnDismissListener {
                viewModel.close()
            }

            setOnShowListener { dialog ->
                val bottomSheet = (dialog as BottomSheetDialog)
                    .findViewById<FrameLayout>(com.google.android.material.R.id.design_bottom_sheet)
                bottomSheet?.let {
                    val behavior = BottomSheetBehavior.from(it)
                    behavior.state = BottomSheetBehavior.STATE_EXPANDED
                    behavior.skipCollapsed = true
                    behavior.isDraggable = true
                    it.layoutParams.height = WRAP_CONTENT
                }
            }
        }
    }
}
