// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participantlist

import android.annotation.SuppressLint
import android.app.AlertDialog
import android.content.Context
import android.view.accessibility.AccessibilityManager
import android.widget.FrameLayout
import android.widget.RelativeLayout
import androidx.core.content.ContextCompat
import androidx.lifecycle.LifecycleOwner
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.acs_plugin.R
import com.acs_plugin.calling.models.CallCompositeParticipantViewData
import com.acs_plugin.calling.models.ParticipantStatus
import com.acs_plugin.calling.presentation.manager.AvatarViewManager
import com.acs_plugin.calling.utilities.BottomCellAdapter
import com.acs_plugin.calling.utilities.BottomCellItem
import com.acs_plugin.calling.utilities.BottomCellItemType
import com.acs_plugin.extension.onSingleClickListener
import com.google.android.material.bottomsheet.BottomSheetBehavior
import com.google.android.material.bottomsheet.BottomSheetDialog
import com.google.android.material.textview.MaterialTextView
import com.microsoft.fluentui.util.isVisible
import kotlinx.coroutines.launch

@SuppressLint("ViewConstructor")
internal class ParticipantListView(
    context: Context,
    private val viewModel: ParticipantListViewModel,
    private val avatarViewManager: AvatarViewManager,
    private val onShareMeetingLinkClicked: () -> Unit
) : RelativeLayout(context) {
    private var participantTable: RecyclerView
    private var participantTitle: MaterialTextView
    private var shareMeetingLink: MaterialTextView

    private lateinit var participantListDialog: BottomSheetDialog
    private lateinit var bottomCellAdapter: BottomCellAdapter
    private lateinit var accessibilityManager: AccessibilityManager
    private var admitDeclinePopUpParticipantId = ""
    private lateinit var admitDeclineAlertDialog: AlertDialog

    init {
        inflate(context, R.layout.participants_list_view, this)
        participantTable = findViewById(R.id.participant_recycler_view)
        participantTitle = findViewById(R.id.participant_list_title)
        shareMeetingLink = findViewById(R.id.share_meeting_link_title)
        shareMeetingLink.onSingleClickListener {
            participantListDialog.dismiss()
            onShareMeetingLinkClicked.invoke()
        }
    }

    fun start(viewLifecycleOwner: LifecycleOwner) {
        initializeParticipantListDrawer()

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.sharingMeetingLinkVisibilityStateFlow.collect {
                shareMeetingLink.isVisible = it
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            avatarViewManager.getRemoteParticipantsPersonaSharedFlow().collect {
                if (participantListDialog.isShowing) {
                    updateParticipantListContent(
                        viewModel.participantListContentStateFlow.value,
                    )
                }
            }
        }

        viewLifecycleOwner.lifecycleScope.launch {
            viewModel.participantListContentStateFlow.collect { vvm ->
                if (vvm.isDisplayed) {
                    showParticipantList()
                } else {
                    if (participantListDialog.isShowing) {
                        participantListDialog.dismiss()
                    }
                }

                // To avoid, unnecessary updated to list, the state will update lists only when displayed
                if (participantListDialog.isShowing) {
                    updateParticipantListContent(vvm)
                }

                if (::admitDeclineAlertDialog.isInitialized && admitDeclineAlertDialog.isShowing &&
                    !vvm.remoteParticipantList.any { it.userIdentifier == admitDeclinePopUpParticipantId }
                ) {
                    admitDeclineAlertDialog.dismiss()
                }
            }
        }
    }

    fun stop() {
        // during screen rotation, destroy, the drawer should be displayed if open
        // to remove memory leak, on activity destroy dialog is dismissed
        // this setOnDismissListener(null) helps to not call view model state change during orientation
        participantListDialog.setOnDismissListener(null)
        bottomCellAdapter.setBottomCellItems(mutableListOf())
        participantTable.layoutManager = null
        participantListDialog.dismiss()
        this.removeAllViews()
    }

    private fun showParticipantList() {
        if (!participantListDialog.isShowing) {
            participantListDialog.show()
        }
    }

    private fun initializeParticipantListDrawer() {
        accessibilityManager =
            context?.applicationContext?.getSystemService(Context.ACCESSIBILITY_SERVICE) as AccessibilityManager

        participantListDialog = BottomSheetDialog(context, R.style.TopRoundedBottomSheetDialog).apply {
            setContentView(this@ParticipantListView)
            setOnDismissListener {
                viewModel.closeParticipantList()
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
        participantTable.adapter = bottomCellAdapter
        participantTable.layoutManager = LinearLayoutManager(context)
    }

    private fun updateParticipantListContent(
        participantListContent: ParticipantListContent,
    ) {
        if (this::bottomCellAdapter.isInitialized) {
            val bottomCellItems = generateBottomCellItems(participantListContent)
            with(bottomCellAdapter) {
                setBottomCellItems(bottomCellItems)
                notifyDataSetChanged()
            }
        }
    }

    private fun generateBottomCellItems(
        participantListContent: ParticipantListContent,
    ): MutableList<BottomCellItem> {
        participantTitle.text = context.getString(
            R.string.participant_list,
            participantListContent.totalActiveParticipantCount + 1 // add one for local participant
        )


        val bottomCellItemsInCallParticipants = mutableListOf<BottomCellItem>()
        val bottomCellItemsInLobbyParticipants = mutableListOf<BottomCellItem>()
        // since we can not get resources from model class, we create the local participant list cell
        // with suffix in this way
        val localParticipantViewModel = participantListContent.localParticipantListCell

        val localParticipantViewData =
            avatarViewManager.callCompositeLocalOptions?.participantViewData
        bottomCellItemsInCallParticipants
            .add(
                generateBottomCellItem(
                    getLocalParticipantNameToDisplay(
                        localParticipantViewData,
                        localParticipantViewModel.displayName,
                    ),
                    localParticipantViewModel.isMuted,
                    localParticipantViewData,
                    localParticipantViewModel.isOnHold,
                    localParticipantViewModel.userIdentifier,
                    localParticipantViewModel.status
                )
            )

        for (remoteParticipant in participantListContent.remoteParticipantList) {
            val remoteParticipantViewData =
                avatarViewManager.getRemoteParticipantViewData(remoteParticipant.userIdentifier)
            val finalName =
                getNameToDisplay(remoteParticipantViewData, remoteParticipant.displayName)

            if (remoteParticipant.status == ParticipantStatus.IN_LOBBY) {
                bottomCellItemsInLobbyParticipants.add(
                    generateBottomCellItem(
                        finalName.ifEmpty { context.getString(R.string.azure_communication_ui_calling_view_participant_drawer_unnamed) },
                        null,
                        remoteParticipantViewData,
                        null,
                        remoteParticipant.userIdentifier,
                        remoteParticipant.status
                    )
                )
            } else if (remoteParticipant.status != ParticipantStatus.DISCONNECTED) {
                bottomCellItemsInCallParticipants.add(
                    generateBottomCellItem(
                        finalName.ifEmpty { context.getString(R.string.azure_communication_ui_calling_view_participant_drawer_unnamed) },
                        remoteParticipant.isMuted,
                        remoteParticipantViewData,
                        remoteParticipant.isOnHold,
                        remoteParticipant.userIdentifier,
                        remoteParticipant.status
                    )
                )
            }
        }
        bottomCellItemsInCallParticipants.sortWith(compareBy(String.CASE_INSENSITIVE_ORDER) { it.title!! })

        val plusMoreParticipants = participantListContent.totalActiveParticipantCount -
            participantListContent.remoteParticipantList.count()

        if (plusMoreParticipants > 0) {
            val plusMorePeople = context.getString(
                R.string.azure_communication_ui_calling_participant_list_in_call_plus_more_people,
                plusMoreParticipants
            )
            bottomCellItemsInCallParticipants.add(
                BottomCellItem(
                    title = plusMorePeople,
                    contentDescription = plusMorePeople,
                    isOnHold = false,
                    itemType = BottomCellItemType.BottomMenuTitle,
                )
            )
        }
        bottomCellItemsInLobbyParticipants.sortWith(compareBy(String.CASE_INSENSITIVE_ORDER) { it.title!! })
        if (bottomCellItemsInLobbyParticipants.isNotEmpty()) {
            bottomCellItemsInLobbyParticipants.add(
                0,
                BottomCellItem(
                    title = context.getString(
                        R.string.azure_communication_ui_calling_participant_list_in_lobby_n_people,
                        bottomCellItemsInLobbyParticipants.size
                    ),
                    itemType = BottomCellItemType.BottomMenuTitle,
                    showAdmitAllButton = true,
                    admitAllButtonAction = {
                        admitAllLobbyParticipants()
                    }
                )
            )
        }
        return (bottomCellItemsInLobbyParticipants + bottomCellItemsInCallParticipants).toMutableList()
    }

    private fun admitAllLobbyParticipants() {
        viewModel.admitAllLobbyParticipants()
    }

    private fun getLocalParticipantNameToDisplay(
        participantViewData: CallCompositeParticipantViewData?,
        displayName: String,
    ): String {
        val localParticipantDisplayName = if (participantViewData?.displayName != null)
            participantViewData.displayName else displayName

        return resources.getString(
            R.string.azure_communication_ui_calling_view_participant_drawer_local_participant_format,
            localParticipantDisplayName,
        )
    }

    private fun generateBottomCellItem(
        displayName: String?,
        isMuted: Boolean?,
        participantViewData: CallCompositeParticipantViewData?,
        isOnHold: Boolean?,
        userIdentifier: String,
        status: ParticipantStatus?,
    ): BottomCellItem {
        val micIcon = ContextCompat.getDrawable(
            context,
            if (isMuted == true) R.drawable.ic_microphone_off
            else R.drawable.ic_microphone
        )

        val micAccessibilityAnnouncement = context.getString(
            if (isMuted == true) R.string.azure_communication_ui_calling_view_participant_list_muted_accessibility_label
            else R.string.azure_communication_ui_calling_view_participant_list_unmuted_accessibility_label
        )
        val onHoldAnnouncement: String = if (isOnHold == true) context.getString(R.string.azure_communication_ui_calling_remote_participant_on_hold) else ""
        val contentDescription = if (onHoldAnnouncement.isNotEmpty()) {
            "$displayName. $onHoldAnnouncement, ${context.getString(R.string.azure_communication_ui_calling_view_participant_list_dismiss_list)}"
        } else if (status == ParticipantStatus.IN_LOBBY) {
            "$displayName. ${context.getString(R.string.azure_communication_ui_calling_view_participant_list_dismiss_lobby_list)}"
        } else {
            "$displayName. $micAccessibilityAnnouncement, ${context.getString(R.string.azure_communication_ui_calling_view_participant_list_dismiss_list)}"
        }

        return BottomCellItem(
            title = displayName,
            contentDescription = contentDescription,
            accessoryImage = if (status != ParticipantStatus.IN_LOBBY) micIcon else null,
            accessoryColor = if (status != ParticipantStatus.IN_LOBBY) R.color.purple else null,
            accessoryImageDescription = micAccessibilityAnnouncement,
            isChecked = isMuted,
            participantViewData = participantViewData,
            isOnHold = isOnHold,
            onClickAction = {
                when (status) {
                    ParticipantStatus.IN_LOBBY -> showAdmitDialog(userIdentifier, displayName)
                    else -> displayParticipantMenu(userIdentifier, displayName)
                }

                if (status != ParticipantStatus.IN_LOBBY && accessibilityManager.isEnabled) {
                    participantListDialog.dismiss()
                }
            }
        )
    }

    private fun showAdmitDialog(userIdentifier: String, displayName: String?) {
        admitDeclinePopUpParticipantId = userIdentifier
        val dialog =
            AlertDialog.Builder(context, R.style.AzureCommunicationUICalling_AlertDialog_Theme)
        dialog.setMessage(
            context.getString(
                R.string.azure_communication_ui_calling_admit_name,
                displayName
            )
        )
            .setPositiveButton(
                context.getString(
                    R.string.azure_communication_ui_calling_admit
                )
            ) { _, _ ->
                viewModel.admitParticipant(userIdentifier)
            }
            .setNegativeButton(
                context.getString(
                    R.string.azure_communication_ui_calling_decline
                )
            ) { _, _ ->
                viewModel.declineParticipant(userIdentifier)
            }
        admitDeclineAlertDialog = dialog.create()
        admitDeclineAlertDialog.show()
    }

    private fun displayParticipantMenu(userIdentifier: String, displayName: String?) {
        viewModel.displayParticipantMenu(userIdentifier, displayName)
    }

    private fun getNameToDisplay(
        participantViewData: CallCompositeParticipantViewData?,
        displayName: String,
    ): String {
        return participantViewData?.displayName ?: displayName
    }
}
