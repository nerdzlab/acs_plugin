package com.acs_plugin.calling.presentation.fragment.calling.participant.menu

import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data.ParticipantMenuItem
import com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data.ParticipantMenuType
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow

internal class ParticipantMenuViewModel() {

    private val displayMenuStateFlow = MutableStateFlow(false)
    val displayMenuFlow = displayMenuStateFlow.asStateFlow()

    private val participantNameStateFlow = MutableStateFlow("")
    val participantNameFlow = participantNameStateFlow.asStateFlow()

    private val participantMenuItemsStateFlow = MutableStateFlow(emptyList<ParticipantMenuItem>())
    val participantMenuItemsFlow = participantMenuItemsStateFlow.asStateFlow()

    var userIdentifier: String? = null

    fun displayParticipantMenu(
        isWhiteboardEnabled: Boolean,
        participant: ParticipantInfoModel
    ) {
        this.userIdentifier = participant.userIdentifier
        participantNameStateFlow.value = participant.displayName
        participantMenuItemsStateFlow.value = generateParticipantMenuItems(isWhiteboardEnabled, participant)
        displayMenuStateFlow.value = true
    }

    fun close() {
        displayMenuStateFlow.value = false
    }

    private fun generateParticipantMenuItems(
        isWhiteboardEnabled: Boolean,
        participant: ParticipantInfoModel
    ): List<ParticipantMenuItem> {
        return buildList {
            if (participant.isPinned) {
                add(ParticipantMenuType.UNPIN.mapToParticipantMenuItem())
            } else {
                add(ParticipantMenuType.PIN.mapToParticipantMenuItem().apply { isEnabled = !isWhiteboardEnabled })
            }
            if (participant.isVideoTurnOffForMe) {
                add(ParticipantMenuType.SHOW_VIDEO.mapToParticipantMenuItem().apply { isEnabled = participant.cameraVideoStreamModel != null })
            } else {
                add(
                    ParticipantMenuType.HIDE_VIDEO.mapToParticipantMenuItem().apply {
                        isEnabled = !participant.isWhiteboard && participant.cameraVideoStreamModel != null }
                )
            }
        }
    }
}
