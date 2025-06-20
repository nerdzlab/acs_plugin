// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling.participant.grid

import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.models.ReactionPayload
import com.acs_plugin.calling.presentation.fragment.calling.participant.grid.cell.ParticipantGridCellMoreView.Companion.MORE_VIEW_ID
import com.acs_plugin.calling.presentation.fragment.factories.ParticipantGridCellViewModelFactory
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.state.CaptionsState
import com.acs_plugin.calling.redux.state.CaptionsStatus
import com.acs_plugin.calling.redux.state.DeviceConfigurationState
import com.acs_plugin.calling.redux.state.MeetingViewMode
import com.acs_plugin.calling.redux.state.RttState
import com.acs_plugin.calling.redux.state.VisibilityStatus
import com.acs_plugin.calling.utilities.EventFlow
import com.acs_plugin.calling.utilities.MutableEventFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import java.lang.Integer.min

internal class ParticipantGridViewModel(
    private val participantGridCellViewModelFactory: ParticipantGridCellViewModelFactory,
    private val maxRemoteParticipantSize: Int,
    private val dispatch: (Action) -> Unit
) {

    private var remoteParticipantsUpdatedStateFlow: MutableStateFlow<List<ParticipantGridCellViewModel>> =
        MutableStateFlow(mutableListOf())

    private var displayedRemoteParticipantsViewModelMap =
        mutableMapOf<String, ParticipantGridCellViewModel>()

    private val mutableParticipantUpdated = MutableEventFlow()

    private var updateVideoStreamsCallback: ((List<Pair<String, String>>) -> Unit)? = null
    private var remoteParticipantStateModifiedTimeStamp: Number = 0
    private var dominantSpeakersStateModifiedTimestamp: Number = 0
    private var raisedHandStateModifiedTimestamp: Number = 0
    private var reactionStateModifiedTimestamp: Number = 0
    private var meetingViewModeStateModifiedTimestamp: Number = 0
    private var visibilityStatus: VisibilityStatus? = null
    private lateinit var isOverlayDisplayedFlow: MutableStateFlow<Boolean>
    private lateinit var isVerticalStyleGridMutableFlow: MutableStateFlow<Boolean>

    val isVerticalStyleGridFlow: StateFlow<Boolean>
        get() = isVerticalStyleGridMutableFlow

    val participantUpdated: EventFlow = mutableParticipantUpdated

    private lateinit var displayParticipantMenuCallback: (userIdentifier: String) -> Unit

    fun init(
        rttState: RttState,
        isOverlayDisplayedOverGrid: Boolean,
        deviceConfigurationState: DeviceConfigurationState,
        captionsState: CaptionsState,
        displayParticipantMenuCallback: (userIdentifier: String) -> Unit
    ) {
        isOverlayDisplayedFlow = MutableStateFlow(isOverlayDisplayedOverGrid)
        isVerticalStyleGridMutableFlow = MutableStateFlow(
            shouldUseVerticalStyleGrid(deviceConfigurationState, rttState, captionsState)
        )
        this.displayParticipantMenuCallback = displayParticipantMenuCallback
    }

    fun clear() {
        remoteParticipantStateModifiedTimeStamp = 0
        dominantSpeakersStateModifiedTimestamp = 0
        raisedHandStateModifiedTimestamp = 0
        displayedRemoteParticipantsViewModelMap.clear()
        remoteParticipantsUpdatedStateFlow.value = mutableListOf()
    }

    fun getRemoteParticipantsUpdateStateFlow(): StateFlow<List<ParticipantGridCellViewModel>> {
        return remoteParticipantsUpdatedStateFlow
    }

    fun setUpdateVideoStreamsCallback(callback: (List<Pair<String, String>>) -> Unit) {
        this.updateVideoStreamsCallback = callback
    }

    fun getMaxRemoteParticipantsSize(): Int {
        return if (visibilityStatus == VisibilityStatus.VISIBLE)
            maxRemoteParticipantSize else 1
    }

    fun getIsOverlayDisplayedFlow(): StateFlow<Boolean> = isOverlayDisplayedFlow

    fun update(
        remoteParticipantsMapUpdatedTimestamp: Number,
        remoteParticipantsMap: Map<String, ParticipantInfoModel>,
        dominantSpeakersInfo: List<String>,
        raisedHandInfo: List<String>,
        dominantSpeakersModifiedTimestamp: Number,
        raisedHandModifiedTimestamp: Number,
        visibilityStatus: VisibilityStatus,
        rttState: RttState,
        isOverlayDisplayedOverGrid: Boolean,
        deviceConfigurationState: DeviceConfigurationState,
        captionsState: CaptionsState,
        reaction: Map<String, ReactionPayload?>,
        reactionModifiedTimestamp: Number,
        meetingViewMode: MeetingViewMode,
        meetingViewModeModifiedTimestamp: Number
    ) {
        isOverlayDisplayedFlow.value = isOverlayDisplayedOverGrid
        isVerticalStyleGridMutableFlow.value = shouldUseVerticalStyleGrid(deviceConfigurationState, rttState, captionsState)

        if (remoteParticipantsMapUpdatedTimestamp == remoteParticipantStateModifiedTimeStamp &&
            dominantSpeakersModifiedTimestamp == dominantSpeakersStateModifiedTimestamp &&
            raisedHandModifiedTimestamp == raisedHandStateModifiedTimestamp &&
            reactionModifiedTimestamp == reactionStateModifiedTimestamp &&
            meetingViewModeModifiedTimestamp == meetingViewModeStateModifiedTimestamp &&
            this.visibilityStatus == visibilityStatus
        ) {
            return
        }

        remoteParticipantStateModifiedTimeStamp = remoteParticipantsMapUpdatedTimestamp
        dominantSpeakersStateModifiedTimestamp = dominantSpeakersModifiedTimestamp
        raisedHandStateModifiedTimestamp = raisedHandModifiedTimestamp
        reactionStateModifiedTimestamp = reactionModifiedTimestamp
        meetingViewModeStateModifiedTimestamp = meetingViewModeModifiedTimestamp
        this.visibilityStatus = visibilityStatus

        var remoteParticipantsMapSorted = updateRemoteParticipantsRaisedHand(remoteParticipantsMap, raisedHandInfo)
        remoteParticipantsMapSorted = updateRemoteParticipantsReaction(remoteParticipantsMapSorted, reaction)
        remoteParticipantsMapSorted = updateRemoteDominantSpeakerParticipants(remoteParticipantsMapSorted, dominantSpeakersInfo, meetingViewMode)

        val participantSharingScreen = getParticipantSharingScreen(remoteParticipantsMap)

        if (participantSharingScreen.isNullOrEmpty()) {
            if (remoteParticipantsMap.size > getMaxRemoteParticipantsSize()) {
                remoteParticipantsMapSorted =
                    sortRemoteParticipants(remoteParticipantsMap, dominantSpeakersInfo)
            }
        } else {
            remoteParticipantsMapSorted = mapOf(
                participantSharingScreen to remoteParticipantsMap[participantSharingScreen]!!
            )
        }

        val whiteboardParticipant = remoteParticipantsMapSorted.values.find { it.isWhiteboard }
        val dominantSpeakerParticipant = remoteParticipantsMapSorted.values.find { it.isDominantSpeaker && whiteboardParticipant == null }?.apply { modifiedTimestamp = System.currentTimeMillis() }
        val pinnedParticipant = remoteParticipantsMapSorted.values.find { it.isPinned && whiteboardParticipant == null }

        val primaryParticipant = whiteboardParticipant ?: dominantSpeakerParticipant ?: pinnedParticipant

        val displayedParticipants: MutableList<ParticipantInfoModel>

        if (primaryParticipant != null) {
            val others = remoteParticipantsMapSorted.filterKeys { it != primaryParticipant.userIdentifier }
            val secondary = sortRemoteParticipants(others, dominantSpeakersInfo).values.take(2)

            displayedParticipants = mutableListOf(primaryParticipant)
            displayedParticipants.addAll(secondary)

            val remainingCount = others.count() - secondary.count()
            if (remainingCount > 0) {
                displayedParticipants.removeAt(2)
                displayedParticipants.add(ParticipantInfoModel.createMoreParticipantInfoModel(remainingCount))
            }
        } else {
            val sorted = sortRemoteParticipants(remoteParticipantsMapSorted, dominantSpeakersInfo)
            val participants = sorted.values.take(8).toMutableList()
            val remainingCount = sorted.size - participants.size

            if (remainingCount > 0) {
                participants.removeAt(7)
                participants.add(ParticipantInfoModel.createMoreParticipantInfoModel(remainingCount))
            }

            displayedParticipants = participants
        }

        val displayedParticipantsMap = displayedParticipants.associateBy { it.userIdentifier }.toMutableMap()

        updateRemoteParticipantsVideoStreams(displayedParticipantsMap)
        updateDisplayedParticipants(primaryParticipant, displayedParticipantsMap)
    }

    fun onParticipantMenuClicked(userIdentifier: String) {
        displayParticipantMenuCallback(userIdentifier)
    }

    private fun shouldUseVerticalStyleGrid(
        deviceConfigurationState: DeviceConfigurationState,
        rttState: RttState,
        captionsState: CaptionsState,
    ): Boolean {
        return deviceConfigurationState.isPortrait ||
            rttState.isRttActive ||
            captionsState.status == CaptionsStatus.STARTED ||
            captionsState.status == CaptionsStatus.START_REQUESTED
    }

    private fun getParticipantSharingScreen(
        remoteParticipantsMap: Map<String, ParticipantInfoModel>,
    ): String? {
        remoteParticipantsMap.forEach { (id, participantInfoModel) ->
            if (participantInfoModel.screenShareVideoStreamModel != null) {
                return id
            }
        }
        return null
    }

    private fun updateDisplayedParticipants(
        currentPrimaryParticipant: ParticipantInfoModel?,
        remoteParticipantsMapSorted: MutableMap<String, ParticipantInfoModel>,
    ) {
        val alreadyDisplayedParticipants =
            displayedRemoteParticipantsViewModelMap.filter { (id, _) ->
                remoteParticipantsMapSorted.containsKey(id)
            }

        val viewModelsThatCanBeRemoved = displayedRemoteParticipantsViewModelMap.keys.filter {
            !remoteParticipantsMapSorted.containsKey(it)
        }.toMutableList()

        alreadyDisplayedParticipants.forEach { (id, participantViewModel) ->
            if (participantViewModel.getParticipantModifiedTimestamp()
                != remoteParticipantsMapSorted[id]!!.modifiedTimestamp
            ) {
                participantViewModel.update(
                    remoteParticipantsMapSorted[id]!!,
                )
            }
            remoteParticipantsMapSorted.remove(id)
        }

        val viewModelsToRemoveCount =
            viewModelsThatCanBeRemoved.size - remoteParticipantsMapSorted.size

        if (viewModelsToRemoveCount > 0) {
            val keysToRemove = viewModelsThatCanBeRemoved.takeLast(viewModelsToRemoveCount)
            displayedRemoteParticipantsViewModelMap.keys.removeAll(keysToRemove)
            viewModelsThatCanBeRemoved.removeAll(keysToRemove)
        }

        if (viewModelsThatCanBeRemoved.isNotEmpty()) {
            val listToPreserveOrder =
                displayedRemoteParticipantsViewModelMap.toList().toMutableList()
            viewModelsThatCanBeRemoved.forEach {
                val indexToSwap = displayedRemoteParticipantsViewModelMap.keys.indexOf(it)
                val viewModel = displayedRemoteParticipantsViewModelMap[it]
                listToPreserveOrder.removeAt(indexToSwap)
                val participantID = remoteParticipantsMapSorted.keys.first()
                val participantInfoModel = remoteParticipantsMapSorted[participantID]
                viewModel?.update(participantInfoModel!!)
                listToPreserveOrder.add(indexToSwap, Pair(participantID, viewModel!!))
                remoteParticipantsMapSorted.remove(participantID)
            }
            displayedRemoteParticipantsViewModelMap.clear()
            listToPreserveOrder.forEach {
                displayedRemoteParticipantsViewModelMap[it.first] = it.second
            }
        }

        remoteParticipantsMapSorted.forEach { (id, participantInfoModel) ->
            displayedRemoteParticipantsViewModelMap[id] =
                participantGridCellViewModelFactory.ParticipantGridCellViewModel(participantInfoModel, dispatch)
        }

        if (remoteParticipantsMapSorted.isNotEmpty() || viewModelsToRemoveCount > 0) {
            // Final reorder to ensure primary is first, more is last

            val ordered = displayedRemoteParticipantsViewModelMap.toList().toMutableList()

            val primary = ordered.find { it.second.getIsPrimaryParticipant() }
            val more = ordered.find { it.second.getParticipantUserIdentifier() == MORE_VIEW_ID }

            primary?.let {
                ordered.remove(it)
                ordered.add(0, it)
            }

            more?.let {
                ordered.remove(it)
                ordered.add(it)
            }

            displayedRemoteParticipantsViewModelMap.clear()
            ordered.forEach { displayedRemoteParticipantsViewModelMap[it.first] = it.second }

            remoteParticipantsUpdatedStateFlow.value =
                displayedRemoteParticipantsViewModelMap.values.toList()
        }

        val firstEntry = displayedRemoteParticipantsViewModelMap.entries.firstOrNull()

        if (currentPrimaryParticipant?.userIdentifier != null && firstEntry?.key != currentPrimaryParticipant.userIdentifier) {
            val reordered = displayedRemoteParticipantsViewModelMap.toList().toMutableList()

            val primaryParticipant = currentPrimaryParticipant.userIdentifier to participantGridCellViewModelFactory.ParticipantGridCellViewModel(currentPrimaryParticipant, dispatch)

            reordered.remove(primaryParticipant)
            reordered.add(0, primaryParticipant)

            displayedRemoteParticipantsViewModelMap.clear()
            reordered.forEach { displayedRemoteParticipantsViewModelMap[it.first] = it.second }

            remoteParticipantsUpdatedStateFlow.value = displayedRemoteParticipantsViewModelMap.values.toList()
        }

        // participants list may not be changed, but their state may be changed, like isMuted
        mutableParticipantUpdated.emit()
    }

    private fun sortRemoteParticipants(
        remoteParticipantsMap: Map<String, ParticipantInfoModel>,
        dominantSpeakersInfo: List<String>
    ): Map<String, ParticipantInfoModel> {

        val dominantSpeakersOrder = mutableMapOf<String, Int>()
        for (i in 0 until min(remoteParticipantsMap.size, dominantSpeakersInfo.count())) {
            dominantSpeakersOrder[dominantSpeakersInfo[i]] = i
        }

        val comparator = Comparator<Pair<String, ParticipantInfoModel>> { p1, p2 ->
            val (id1, participant1) = p1
            val (id2, participant2) = p2

            // 1. Raised hand
            if (participant1.isRaisedHand && !participant2.isRaisedHand) return@Comparator -1
            if (!participant1.isRaisedHand && participant2.isRaisedHand) return@Comparator 1

            // 1.5 Recent reactions
            if (participant1.selectedReaction != null && participant2.selectedReaction == null) return@Comparator -1
            if (participant1.selectedReaction == null && participant2.selectedReaction != null) return@Comparator 1

            // 2. Dominant speaker order
            val order1 = dominantSpeakersOrder[id1]
            val order2 = dominantSpeakersOrder[id2]
            when {
                order1 != null && order2 != null -> return@Comparator order1.compareTo(order2)
                order1 != null -> return@Comparator -1
                order2 != null -> return@Comparator 1
            }

            // 3. Fallback to camera presence
            return@Comparator when {
                participant1.cameraVideoStreamModel != null && participant2.cameraVideoStreamModel == null -> -1
                participant1.cameraVideoStreamModel == null && participant2.cameraVideoStreamModel != null -> 1
                else -> 0
            }
        }

        return remoteParticipantsMap
            .toList()
            .sortedWith(comparator)
            .toMap()
    }


    private fun updateRemoteParticipantsVideoStreams(
        participantViewModelMap: Map<String, ParticipantInfoModel>,
    ) {
        val usersVideoStream: MutableList<Pair<String, String>> = mutableListOf()
        participantViewModelMap.forEach { (participantId, participant) ->
            participant.cameraVideoStreamModel?.let {
                usersVideoStream.add(
                    Pair(
                        participantId,
                        participant.cameraVideoStreamModel!!.videoStreamID
                    )
                )
            }
            participant.screenShareVideoStreamModel?.let {
                usersVideoStream.add(
                    Pair(
                        participantId,
                        participant.screenShareVideoStreamModel!!.videoStreamID
                    )
                )
            }
        }
        updateVideoStreamsCallback?.invoke(usersVideoStream)
    }

    private fun updateRemoteDominantSpeakerParticipants(
        remoteParticipantsMap: Map<String, ParticipantInfoModel>,
        dominantSpeakersInfo: List<String>,
        meetingViewMode: MeetingViewMode
    ) : Map<String, ParticipantInfoModel> {
        val participants = remoteParticipantsMap.toMutableMap()
        val oldDominantSpeakerId = participants.values.find { it.isDominantSpeaker }?.userIdentifier

        if (meetingViewMode == MeetingViewMode.SPEAKER) {
            val dominantSpeakerId = dominantSpeakersInfo.firstOrNull()
            participants.forEach { (id, participant) ->
                participant.isDominantSpeaker = id == dominantSpeakerId && !participant.isMuted
            }
            participants.values.find { it.isDominantSpeaker }?.modifiedTimestamp = System.currentTimeMillis()
        } else {
            participants.forEach { (_, participant) ->
                participant.isDominantSpeaker = false
            }
            participants[oldDominantSpeakerId]?.apply { modifiedTimestamp = System.currentTimeMillis() }
        }

        return participants.toMap()
    }

    private fun updateRemoteParticipantsRaisedHand(
        remoteParticipantsMap: Map<String, ParticipantInfoModel>,
        raisedHandInfo: List<String>
    ) : Map<String, ParticipantInfoModel> {
        val oldRaisedHandParticipantsIdList = remoteParticipantsMap.values.filter { it.isRaisedHand }.map { it.userIdentifier }

        // Update isRaisedHand for all participants
        remoteParticipantsMap.values.forEach { participant ->
            participant.isRaisedHand = raisedHandInfo.contains(participant.userIdentifier).also {
                if (it || oldRaisedHandParticipantsIdList.contains(participant.userIdentifier)) {
                    participant.modifiedTimestamp = System.currentTimeMillis()
                }
            }
        }
        return remoteParticipantsMap.toMap()
    }

    private fun updateRemoteParticipantsReaction(
        remoteParticipantsMap: Map<String, ParticipantInfoModel>,
        reactionMap: Map<String, ReactionPayload?>
    ): Map<String, ParticipantInfoModel> {
        reactionMap.forEach { (participantId, payload) ->
            val participant = remoteParticipantsMap[participantId]
            if (participant != null && participant.selectedReaction != payload?.reaction) {
                participant.selectedReaction = payload?.reaction
                participant.modifiedTimestamp = System.currentTimeMillis()
            }
        }
        return remoteParticipantsMap.toMap()
    }
}
