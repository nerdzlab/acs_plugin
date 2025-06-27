// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participantlist

import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.models.ParticipantStatus
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.ParticipantAction
import com.acs_plugin.calling.redux.state.AudioOperationalStatus
import com.acs_plugin.calling.redux.state.LocalUserState
import com.acs_plugin.calling.redux.state.VisibilityState
import com.acs_plugin.calling.redux.state.VisibilityStatus
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class ParticipantListViewModel(
    private val dispatch: (Action) -> Unit,
) {
    private val localUserIdentifier = ""
    private lateinit var participantListContentMutableStateFlow: MutableStateFlow<ParticipantListContent>
    private lateinit var displayParticipantMenuCallback: (userIdentifier: String, displayName: String?) -> Unit

    val participantListContentStateFlow: StateFlow<ParticipantListContent> get() = participantListContentMutableStateFlow

    private lateinit var sharingMeetingLinkVisibilityMutableStateFlow: MutableStateFlow<Boolean>
    val sharingMeetingLinkVisibilityStateFlow: StateFlow<Boolean> get() = sharingMeetingLinkVisibilityMutableStateFlow

    fun init(
        callType: CallType?,
        participantMap: Map<String, ParticipantInfoModel>,
        localUserState: LocalUserState,
        canShowLobby: Boolean,
        displayParticipantMenuCallback: (userIdentifier: String, displayName: String?) -> Unit,
        totalParticipantCountExceptHidden: Int,
    ) {
        val isSharingLinkVisible = callType != CallType.TEAMS_MEETING && callType != CallType.ONE_TO_ONE_INCOMING && callType != CallType.ONE_TO_N_OUTGOING
        sharingMeetingLinkVisibilityMutableStateFlow = MutableStateFlow(isSharingLinkVisible)

        val remoteParticipantList: List<ParticipantListCellModel> =
            participantMap.values.map {
                getRemoteParticipantListCellModel(it)
            }.filter { participantListRemoteParticipantVisibility(it, canShowLobby) }
        participantListContentMutableStateFlow = MutableStateFlow(
            ParticipantListContent(
                remoteParticipantList = remoteParticipantList,
                localParticipantListCell = getLocalParticipantListCellModel(localUserState),
                totalActiveParticipantCount = totalParticipantCountExceptHidden,
                isDisplayed = false
            )
        )

        this.displayParticipantMenuCallback = displayParticipantMenuCallback
    }

    fun update(
        callType: CallType?,
        participantMap: Map<String, ParticipantInfoModel>,
        localUserState: LocalUserState,
        visibilityState: VisibilityState,
        canShowLobby: Boolean,
        totalParticipantCountExceptHidden: Int,
    ) {
        val isSharingLinkVisible = callType != CallType.TEAMS_MEETING && callType != CallType.ONE_TO_ONE_INCOMING && callType != CallType.ONE_TO_N_OUTGOING
        sharingMeetingLinkVisibilityMutableStateFlow = MutableStateFlow(isSharingLinkVisible)

        val remoteParticipantList: MutableList<ParticipantListCellModel> =
            participantMap.values.map {
                getRemoteParticipantListCellModel(it)
            }.filter { participantListRemoteParticipantVisibility(it, canShowLobby) }.toMutableList()

        val display = if (visibilityState.status != VisibilityStatus.VISIBLE)
            false
        else participantListContentMutableStateFlow.value.isDisplayed

        participantListContentMutableStateFlow.value = ParticipantListContent(
            remoteParticipantList = remoteParticipantList,
            localParticipantListCell = getLocalParticipantListCellModel(localUserState),
            totalActiveParticipantCount = totalParticipantCountExceptHidden,
            isDisplayed = display,
        )
    }

    private fun participantListRemoteParticipantVisibility(
        it: ParticipantListCellModel,
        canShowLobby: Boolean,
    ) = (
        it.status != ParticipantStatus.DISCONNECTED &&
            if (it.status == ParticipantStatus.IN_LOBBY) canShowLobby else true
        )

    fun displayParticipantList() {
        participantListContentMutableStateFlow.value = participantListContentMutableStateFlow.value.copy(isDisplayed = true)
    }

    fun closeParticipantList() {
        participantListContentMutableStateFlow.value = participantListContentMutableStateFlow.value.copy(isDisplayed = false)
    }

    fun admitParticipant(userIdentifier: String) {
        dispatch(ParticipantAction.Admit(userIdentifier))
    }

    fun declineParticipant(userIdentifier: String) {
        dispatch(ParticipantAction.Reject(userIdentifier))
    }

    fun admitAllLobbyParticipants() {
        dispatch(ParticipantAction.AdmitAll())
    }

    fun displayParticipantMenu(userIdentifier: String, displayName: String?) {
        if (userIdentifier != localUserIdentifier) {
            closeParticipantList()
            displayParticipantMenuCallback(userIdentifier, displayName)
        }
    }

    private fun getLocalParticipantListCellModel(localUserState: LocalUserState): ParticipantListCellModel {
        val localUserDisplayName = localUserState.displayName
        return ParticipantListCellModel(
            localUserDisplayName ?: "",
            localUserState.audioState.operation == AudioOperationalStatus.OFF,
            localUserIdentifier,
            false
        )
    }

    private fun getRemoteParticipantListCellModel(it: ParticipantInfoModel): ParticipantListCellModel {
        return ParticipantListCellModel(
            it.displayName.trim(), it.isMuted,
            it.userIdentifier,
            it.participantStatus == ParticipantStatus.HOLD,
            it.participantStatus,
        )
    }
}

internal data class ParticipantListContent(
    val remoteParticipantList: List<ParticipantListCellModel>,
    val localParticipantListCell: ParticipantListCellModel,
    val totalActiveParticipantCount: Int,
    val isDisplayed: Boolean,
)

internal data class ParticipantListCellModel(
    val displayName: String,
    val isMuted: Boolean,
    val userIdentifier: String,
    val isOnHold: Boolean,
    val status: ParticipantStatus? = null,
)
