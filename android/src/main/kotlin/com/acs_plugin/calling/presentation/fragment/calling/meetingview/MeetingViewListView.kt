package com.acs_plugin.calling.presentation.fragment.calling.meetingview

import android.content.Context
import android.util.AttributeSet
import android.widget.FrameLayout
import android.widget.LinearLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.acs_plugin.R
import com.acs_plugin.calling.redux.state.MeetingViewMode
import com.acs_plugin.calling.utilities.BottomCellAdapter
import com.acs_plugin.calling.utilities.BottomCellItem
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import kotlinx.coroutines.launch

internal class MeetingViewListView @JvmOverloads constructor(
    context: Context,
    attrs: AttributeSet? = null
) : LinearLayout(context, attrs) {

    private lateinit var viewModel: MeetingViewListViewModel

    private lateinit var meetingViewDialog: BottomSheetDialog
    private lateinit var bottomCellAdapter: BottomCellAdapter
    private var meetingViewList: RecyclerView


    init {
        inflate(context, R.layout.meeting_view_list_view, this)
        meetingViewList = findViewById(R.id.meeting_list_recycle_view)
    }

    fun start(
        viewLifecycleOwner: LifecycleOwner,
        viewModel: MeetingViewListViewModel
    ) {
        this.viewModel = viewModel

        initializeMeetingViewDialog()

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.meetingViewModeStateFlow.collect {
                updateSelectedMeetingView(it)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.displayMeetingViewSelectionStateFlow.collect {
                if (it) {
                    showMeetingViewSelectionMenu()
                }
            }
        }
    }

    fun stop() {
        bottomCellAdapter.setBottomCellItems(mutableListOf())
        meetingViewList.layoutManager = null
        meetingViewDialog.dismiss()
        this.removeAllViews()
    }

    private fun showMeetingViewSelectionMenu() {
        meetingViewDialog.show()
    }

    private fun initializeMeetingViewDialog() {
        meetingViewDialog = BottomSheetDialog(context, R.style.RoundedBottomSheetDialog).apply {
            setContentView(this@MeetingViewListView)
            setOnDismissListener {
                viewModel.closeMeetingViewSelectionMenu()
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

        bottomCellAdapter = BottomCellAdapter()
        bottomCellAdapter.setBottomCellItems(provideMeetingViewListItems())
        meetingViewList.adapter = bottomCellAdapter
        meetingViewList.layoutManager = LinearLayoutManager(context)
    }

    private fun provideMeetingViewListItems(): List<BottomCellItem> {
        val selectedMeetingView = viewModel.meetingViewModeStateFlow.value
        val bottomCellItems = mutableListOf<BottomCellItem>()

        bottomCellItems.add(
            BottomCellItem(
                icon = ContextCompat.getDrawable(context, R.drawable.ic_grid_view),
                title = context.getString(R.string.gallery_view),
                isChecked = selectedMeetingView == MeetingViewMode.GALLERY,
                isOnHold = false,
                onClickAction = {
                    viewModel.switchMeetingView(MeetingViewMode.GALLERY)
                    meetingViewDialog.dismiss()
                }
            )
        )

        bottomCellItems.add(
            BottomCellItem(
                icon = ContextCompat.getDrawable(context, R.drawable.ic_avatar_placeholder),
                title = context.getString(R.string.speaker_view),
                isChecked = selectedMeetingView == MeetingViewMode.SPEAKER,
                isOnHold = false,
                onClickAction = {
                    viewModel.switchMeetingView(MeetingViewMode.SPEAKER)
                    meetingViewDialog.dismiss()
                }
            )
        )

        return bottomCellItems
    }

    private fun updateSelectedMeetingView(meetingViewMode: MeetingViewMode) {
        if (this::bottomCellAdapter.isInitialized) {
            bottomCellAdapter.enableBottomCellItem(
                bottomCellItemName = context.getString(
                    when (meetingViewMode) {
                        MeetingViewMode.GALLERY -> R.string.gallery_view
                        MeetingViewMode.SPEAKER -> R.string.speaker_view
                    }
                )
            )
        }
    }
}