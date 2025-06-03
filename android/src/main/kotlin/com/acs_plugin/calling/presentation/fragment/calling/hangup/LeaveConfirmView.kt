// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.hangup

import android.annotation.SuppressLint
import android.content.Context
import android.view.View
import android.widget.FrameLayout
import android.widget.RelativeLayout
import androidx.core.content.ContextCompat
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.acs_plugin.R
import com.acs_plugin.calling.utilities.BottomCellAdapter
import com.acs_plugin.calling.utilities.BottomCellItem
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.coroutines.launch
import kotlin.math.max

@SuppressLint("ViewConstructor")
internal class LeaveConfirmView(
    private val viewModel: LeaveConfirmViewModel,
    context: Context,
) : RelativeLayout(context) {

    private var leaveConfirmMenuTable: RecyclerView
    private lateinit var leaveConfirmMenuDialog: BottomSheetDialog
    private lateinit var bottomCellAdapter: BottomCellAdapter

    init {
        inflate(context, R.layout.leave_confirm_view, this)
        leaveConfirmMenuTable = findViewById(R.id.leave_options_recycler_view)
    }

    fun stop() {
        bottomCellAdapter.setBottomCellItems(mutableListOf())
        leaveConfirmMenuTable.layoutManager = null
        leaveConfirmMenuDialog.dismiss()

        removeAllViews()
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner
    ) {
        bottomCellAdapter = BottomCellAdapter()
        bottomCellAdapter.setBottomCellItems(bottomCellItems)
        leaveConfirmMenuTable.adapter = bottomCellAdapter
        leaveConfirmMenuTable.layoutManager = AccessibilityManipulatingLinearLayoutManager(context)

        initializeLeaveConfirmMenuDrawer()
        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.shouldDisplayLeaveConfirmStateFlow.collect {
                if (it) {
                    showLeaveCallConfirm()
                }
            }
        }
    }

    private fun showLeaveCallConfirm() {
        if (!leaveConfirmMenuDialog.isShowing) {
            leaveConfirmMenuDialog.show()
        }
    }

    private fun initializeLeaveConfirmMenuDrawer() {
        leaveConfirmMenuDialog = BottomSheetDialog(context, R.style.RoundedBottomSheetDialog).apply {
            setContentView(this@LeaveConfirmView)
            setOnDismissListener {
                viewModel.cancel()
            }

            setOnShowListener { dialog ->
                val bottomSheet = (dialog as BottomSheetDialog)
                    .findViewById<FrameLayout>(com.google.android.material.R.id.design_bottom_sheet)
                bottomSheet?.let {
                    val behavior = BottomSheetBehavior.from(it)
                    behavior.state = BottomSheetBehavior.STATE_EXPANDED
                    behavior.skipCollapsed = true
                    behavior.isDraggable = true
                    it.layoutParams.height = FrameLayout.LayoutParams.WRAP_CONTENT
                }
            }
        }
    }

    private fun cancelLeaveConfirm() {
        leaveConfirmMenuDialog.dismiss()
    }

    private val bottomCellItems: List<BottomCellItem>
        get() {
            val bottomCellItems = mutableListOf(
                // Leave
                BottomCellItem(
                    icon = ContextCompat.getDrawable(
                        context,
                        R.drawable.azure_communication_ui_calling_leave_confirm_telephone_24
                    ),
                    title = context.getString(R.string.azure_communication_ui_calling_view_leave_call_button_text),
                    contentDescription = context.getString(R.string.azure_communication_ui_calling_leave_confirm_drawer_leave_button),
                    isOnHold = false,
                    onClickAction = {
                        viewModel.confirm()
                    }
                ),

                // Cancel
                BottomCellItem(
                    icon = ContextCompat.getDrawable(
                        context,
                        R.drawable.azure_communication_ui_calling_leave_confirm_dismiss_24
                    ),
                    title = context.getString(R.string.azure_communication_ui_calling_view_leave_call_cancel),
                    contentDescription = context.getString(R.string.azure_communication_ui_calling_leave_confirm_drawer_cancel_button),
                    isOnHold = false,
                    onClickAction = {
                        cancelLeaveConfirm()
                    },
                )
            )
            return bottomCellItems
        }

    class AccessibilityManipulatingLinearLayoutManager(context: Context) : LinearLayoutManager(context) {
        override fun getRowCountForAccessibility(
            recycler: RecyclerView.Recycler,
            state: RecyclerView.State
        ): Int {
            return max(super.getRowCountForAccessibility(recycler, state) - 1, 0)
        }

        override fun onInitializeAccessibilityNodeInfoForItem(
            recycler: RecyclerView.Recycler,
            state: RecyclerView.State,
            host: View,
            info: AccessibilityNodeInfoCompat
        ) {
            super.onInitializeAccessibilityNodeInfoForItem(recycler, state, host, info)
            try {
                info.let {
                    val itemInfo = AccessibilityNodeInfoCompat.CollectionItemInfoCompat.obtain(max(info.collectionItemInfo.rowIndex - 1, 0), info.collectionItemInfo.rowSpan, info.collectionItemInfo.columnIndex, info.collectionItemInfo.columnSpan, info.collectionItemInfo.isHeading, info.collectionItemInfo.isSelected)
                    if (info.collectionItemInfo.rowIndex == 0) {
                        info.setCollectionItemInfo(null)
                    } else {
                        info.setCollectionItemInfo(itemInfo)
                    }
                }
            } catch (e: Exception) {
                // Xamarin cause exception, info is null
                // Cause: -\java.lang.NullPointerException: Attempt to invoke virtual method 'int androidx.core.view.accessibility.AccessibilityNodeInfoCompat$CollectionItemInfoCompat.getRowIndex()
            }
        }
    }
}
