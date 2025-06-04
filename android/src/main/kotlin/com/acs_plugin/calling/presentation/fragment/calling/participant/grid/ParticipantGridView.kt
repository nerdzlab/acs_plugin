// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid

import android.content.Context
import android.graphics.Rect
import android.util.AttributeSet
import android.view.View
import android.view.ViewGroup
import android.view.accessibility.AccessibilityManager
import android.widget.GridLayout
import androidx.core.view.AccessibilityDelegateCompat
import androidx.core.view.ViewCompat
import androidx.core.view.accessibility.AccessibilityNodeInfoCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import com.acs_plugin.R
import com.acs_plugin.calling.models.CallCompositeParticipantViewData
import com.acs_plugin.calling.presentation.VideoViewManager
import com.acs_plugin.calling.presentation.manager.AvatarViewManager
import com.acs_plugin.calling.service.sdk.VideoStreamRenderer
import kotlinx.coroutines.launch

/**
 * A grid view to display participants in a call.
 *
 * This view is responsible for:
 * -  Displaying remote participants' video streams or avatar.
 * -  Arranging participants in a grid layout.
 * -  Handling participant state updates (e.g., mute/unmute, speaking status).
 * -  Managing accessibility features for the participant grid.
 */
internal class ParticipantGridView : GridLayout {
    constructor(context: Context) : super(context)
    constructor(context: Context, attrs: AttributeSet?) : super(context, attrs)

    private lateinit var showFloatingHeaderCallBack: () -> Unit
    private lateinit var videoViewManager: VideoViewManager
    private lateinit var viewLifecycleOwner: LifecycleOwner
    private lateinit var participantGridViewModel: ParticipantGridViewModel
    private lateinit var getVideoStreamCallback: (String, String) -> View?
    private lateinit var getScreenShareVideoStreamRendererCallback: () -> VideoStreamRenderer?
    private lateinit var gridView: ParticipantGridView
    private lateinit var accessibilityManager: AccessibilityManager
    private lateinit var displayedRemoteParticipantsView: MutableList<ParticipantGridCellView>
    private lateinit var getParticipantViewDataCallback: (participantID: String) -> CallCompositeParticipantViewData?
    private lateinit var getMoreParticipantViewCallback: () -> Unit

    override fun onSizeChanged(w: Int, h: Int, oldw: Int, oldh: Int) {
        super.onSizeChanged(w, h, oldw, oldh)
        post {
            updateGrid(participantGridViewModel.getRemoteParticipantsUpdateStateFlow().value)
        }
    }

    override fun onFinishInflate() {
        super.onFinishInflate()
        gridView = findViewById(R.id.azure_communication_ui_call_participant_container)
    }

    fun start(
        participantGridViewModel: ParticipantGridViewModel,
        videoViewManager: VideoViewManager,
        viewLifecycleOwner: LifecycleOwner,
        showFloatingHeader: () -> Unit,
        avatarViewManager: AvatarViewManager,
        getMoreParticipantViewCallback: () -> Unit,
    ) {
        accessibilityManager =
            context.applicationContext.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager

        if (accessibilityManager.isEnabled) {
            ViewCompat.setAccessibilityDelegate(
                this,
                object : AccessibilityDelegateCompat() {
                    override fun onInitializeAccessibilityNodeInfo(
                        host: View,
                        info: AccessibilityNodeInfoCompat,
                    ) {
                        super.onInitializeAccessibilityNodeInfo(host, info)
                        info.removeAction(AccessibilityNodeInfoCompat.AccessibilityActionCompat.ACTION_CLICK)
                        info.isClickable = false
                    }
                }
            )
        }

        this.videoViewManager = videoViewManager
        this.viewLifecycleOwner = viewLifecycleOwner
        this.participantGridViewModel = participantGridViewModel
        this.showFloatingHeaderCallBack = showFloatingHeader
        this.getMoreParticipantViewCallback = getMoreParticipantViewCallback
        this.getVideoStreamCallback = { participantID: String, videoStreamID: String ->
            this.videoViewManager.getRemoteVideoStreamRenderer(participantID, videoStreamID)
        }

        this.getScreenShareVideoStreamRendererCallback = {
            this.videoViewManager.getScreenShareVideoStreamRenderer()
        }

        this.participantGridViewModel.setUpdateVideoStreamsCallback { users ->
            this.videoViewManager.removeRemoteParticipantVideoRenderer(users)
        }

        this.getParticipantViewDataCallback = { participantID ->
            avatarViewManager.getRemoteParticipantViewData(participantID)
        }

        viewLifecycleOwner.lifecycleScope.launch {
            avatarViewManager.getRemoteParticipantsPersonaSharedFlow()
                .collect { remoteParticipantViewData ->
                    if (::displayedRemoteParticipantsView.isInitialized && displayedRemoteParticipantsView.isNotEmpty()) {
                        displayedRemoteParticipantsView.forEach { displayedParticipant ->
                            val identifier = displayedParticipant.getParticipantIdentifier()
                            if (remoteParticipantViewData.containsKey(identifier)) {
                                displayedParticipant.updateParticipantViewData()
                            }
                        }
                    }
                }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            participantGridViewModel.getRemoteParticipantsUpdateStateFlow().collect {
                post { updateGrid(it) }
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            participantGridViewModel.getIsOverlayDisplayedFlow().collect {
                val importantForAccessibility = if (it) {
                    ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_NO_HIDE_DESCENDANTS
                } else {
                    ViewCompat.IMPORTANT_FOR_ACCESSIBILITY_YES
                }
                ViewCompat.setImportantForAccessibility(gridView, importantForAccessibility)
            }
        }

        addOnLayoutChangeListener { _, left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom ->
            if (left != oldLeft || right != oldRight || top != oldTop || bottom != oldBottom) {
                val sourceRectHint = Rect()
                getGlobalVisibleRect(sourceRectHint)
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            participantGridViewModel.participantUpdated.events.collect {
                updateContentDescription()
            }
        }
    }

    fun stop() {
        removeAllViews()
    }

    private fun updateGrid(displayedRemoteParticipantsViewModel: List<ParticipantGridCellViewModel>) {
        videoViewManager.updateScalingForRemoteStream()
        removeAllViews()
        displayedRemoteParticipantsView = mutableListOf()

        displayedRemoteParticipantsViewModel.forEach {
            val participantView = ParticipantGridCellView(
                context,
                viewLifecycleOwner.lifecycleScope,
                it,
                showFloatingHeaderCallBack,
                getVideoStreamCallback,
                getScreenShareVideoStreamRendererCallback,
                getParticipantViewDataCallback,
                getMoreParticipantViewCallback
            )
            displayedRemoteParticipantsView.add(participantView)
        }

        applyLayout(displayedRemoteParticipantsView)
    }

    private fun updateContentDescription() {
        val muted = context.getString(R.string.azure_communication_ui_calling_view_participant_list_muted_accessibility_label)
        val unmuted = context.getString(R.string.azure_communication_ui_calling_view_participant_list_unmuted_accessibility_label)

        val participants = participantGridViewModel.getRemoteParticipantsUpdateStateFlow().value.joinToString {
            val muteState = if (it.getIsMutedStateFlow().value) muted else unmuted
            "${it.getDisplayNameStateFlow().value}, $muteState."
        }

        gridView.contentDescription = if (participants.isNotEmpty())
            context.getString(R.string.azure_communication_ui_calling_view_call_with_accessibility_label, participants)
        else context.getString(R.string.azure_communication_ui_calling_view_info_header_waiting_for_others_to_join)
    }

    private fun applyLayout(participants: List<ParticipantGridCellView>) {
        val primary = participants.firstOrNull { it.isPrimaryParticipant() }

        if (primary != null) {
            val secondaries = participants.filter { !it.isPrimaryParticipant() }

            // Layout: 2 rows, 1 column for primary full-width
            setGridRowsColumn(2, 1)

            val totalHeight = height
            val primaryHeight = (totalHeight * 0.7f).toInt()
            val secondaryHeight = totalHeight - primaryHeight

            // Add primary to first row, full width
            addParticipantToGrid(
                rowSpan = 1,
                columnSpan = 1,
                participantGridCellView = primary,
                customHeight = primaryHeight
            )

            // Prepare bottom row for secondaries
            val secondaryRow = GridLayout(context).apply {
                layoutParams = LayoutParams().apply {
                    width = this@ParticipantGridView.width
                    height = secondaryHeight
                }
                rowCount = 1
                columnCount = 2
                orientation = HORIZONTAL
            }

            secondaries.take(2).forEach { secondary ->
                val params = LayoutParams().apply {
                    width = this@ParticipantGridView.width / 2
                    height = secondaryHeight
                }
                secondary.layoutParams = params
                detachFromParentView(secondary)
                secondaryRow.addView(secondary)
            }

            this.addView(secondaryRow)
        } else {
            when (participants.size) {
                3 -> {
                    setGridRowsColumn(2, 2)

                    val firstRow = participants.subList(0, 2)
                    val secondRow = participants[2]

                    firstRow.forEach {
                        addParticipantToGrid(
                            rowSpan = 1,
                            columnSpan = 1,
                            participantGridCellView = it,
                            customHeight = height / 2,
                            customWidth = width / 2
                        )
                    }

                    addParticipantToGrid(
                        rowSpan = 1,
                        columnSpan = 2,
                        participantGridCellView = secondRow,
                        customWidth = width,
                        customHeight = height / 2
                    )
                }

                5 -> {
                    setGridRowsColumn(3, 2)

                    participants.subList(0, 4).forEach {
                        addParticipantToGrid(
                            rowSpan = 1,
                            columnSpan = 1,
                            participantGridCellView = it,
                            customHeight = height / 3,
                            customWidth = width / 2
                        )
                    }

                    addParticipantToGrid(
                        rowSpan = 1,
                        columnSpan = 2,
                        participantGridCellView = participants[4],
                        customHeight = height / 3,
                        customWidth = width
                    )
                }

                7 -> {
                    setGridRowsColumn(4, 2)

                    participants.subList(0, 6).forEach {
                        addParticipantToGrid(
                            rowSpan = 1,
                            columnSpan = 1,
                            participantGridCellView = it,
                            customHeight = height / 4,
                            customWidth = width / 2
                        )
                    }

                    addParticipantToGrid(
                        rowSpan = 1,
                        columnSpan = 2,
                        participantGridCellView = participants[6],
                        customHeight = height / 4,
                        customWidth = width
                    )
                }

                else -> {
                    setGridRowsColumns(participants.size)
                    participants.forEach {
                        addParticipantToGrid(participantGridCellView = it)
                    }
                }
            }
        }
    }

    private fun setGridRowsColumns(size: Int) {
        when (size) {
            1 -> setGridRowsColumn(1, 1)
            2 -> setGridRowsColumn(2, 1)
            3, 4 -> setGridRowsColumn(2, 2)
            5, 6 -> setGridRowsColumn(3, 2)
            7, 8 -> setGridRowsColumn(4, 2)
            else -> setGridRowsColumn(4, 2)
        }
    }

    private fun setGridRowsColumn(rows: Int, columns: Int) {
        this.rowCount = rows
        this.columnCount = columns
    }

    private fun addParticipantToGrid(
        columnSpan: Int = 1,
        rowSpan: Int = 1,
        participantGridCellView: ParticipantGridCellView,
        customWidth: Int? = null,
        customHeight: Int? = null
    ) {
        val rowSpec = spec(UNDEFINED, rowSpan)
        val columnSpec = spec(UNDEFINED, columnSpan)
        val params = LayoutParams(rowSpec, columnSpec)

        params.width = customWidth ?: width / columnCount
        params.height = customHeight ?: height / rowCount

        this.orientation = HORIZONTAL
        participantGridCellView.layoutParams = params
        detachFromParentView(participantGridCellView)
        this.addView(participantGridCellView)
    }

    private fun detachFromParentView(view: View?) {
        (view?.parent as? ViewGroup)?.removeView(view)
    }
}
