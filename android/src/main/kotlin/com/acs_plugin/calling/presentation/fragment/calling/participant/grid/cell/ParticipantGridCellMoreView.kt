package com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell

import android.widget.FrameLayout
import androidx.lifecycle.LifecycleCoroutineScope
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.ParticipantGridCellViewModel
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.textview.MaterialTextView
import kotlinx.coroutines.launch

internal class ParticipantGridCellMoreView(
    private val lifecycleScope: LifecycleCoroutineScope,
    moreViewContainer: FrameLayout,
    private val moreCountTextView: MaterialTextView,
    private val participantViewModel: ParticipantGridCellViewModel,
    private val getMoreViewCallback: () -> Unit
) {

    companion object {
        const val MORE_VIEW_ID = "participant_more_view_id"
    }

    init {
        updateMoreViewData()
        moreViewContainer.onSingleClickListener { getMoreViewCallback.invoke() }
    }

    fun updateMoreViewData() {
        lifecycleScope.launch {
            participantViewModel.getDisplayNameStateFlow().collect {
                moreCountTextView.text = it
            }
        }
    }
}