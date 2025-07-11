// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.calling

import android.util.Log
import com.acs_plugin.calling.configuration.CallType
import com.acs_plugin.calling.models.CallCompositeAudioVideoMode
import com.acs_plugin.calling.models.CallCompositeCallScreenOptions
import com.acs_plugin.calling.models.CallCompositeLeaveCallConfirmationMode
import com.acs_plugin.calling.models.ParticipantCapabilityType
import com.acs_plugin.calling.models.ParticipantInfoModel
import com.acs_plugin.calling.models.ParticipantStatus
import com.acs_plugin.calling.presentation.fragment.BaseViewModel
import com.acs_plugin.calling.presentation.fragment.calling.participant.menu.data.ParticipantMenuType
import com.acs_plugin.calling.presentation.fragment.factories.CallingViewModelFactory
import com.acs_plugin.calling.presentation.manager.CapabilitiesManager
import com.acs_plugin.calling.presentation.manager.NetworkManager
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.action.CallingAction
import com.acs_plugin.calling.redux.action.ParticipantAction
import com.acs_plugin.calling.redux.action.RttAction
import com.acs_plugin.calling.redux.state.CallingStatus
import com.acs_plugin.calling.redux.state.CaptionsStatus
import com.acs_plugin.calling.redux.state.LifecycleStatus
import com.acs_plugin.calling.redux.state.PermissionStatus
import com.acs_plugin.calling.redux.state.ReduxState
import com.acs_plugin.calling.redux.state.RttState
import com.acs_plugin.calling.redux.state.VisibilityState
import com.acs_plugin.calling.redux.state.VisibilityStatus
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.MutableSharedFlow
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow

internal class CallingViewModel(
    store: Store<ReduxState>,
    callingViewModelProvider: CallingViewModelFactory,
    private val networkManager: NetworkManager,
    private val callScreenOptions: CallCompositeCallScreenOptions? = null,
    val multitaskingEnabled: Boolean,
    val avMode: CallCompositeAudioVideoMode,
    private val callType: CallType? = null,
    private val capabilitiesManager: CapabilitiesManager,
) : BaseViewModel(store) {

    private val _shareMeetingLinkMutableFlow = MutableSharedFlow<String>(extraBufferCapacity = 1)
    var shareMeetingLinkMutableFlow = _shareMeetingLinkMutableFlow as SharedFlow<String>

    private var isCaptionsVisibleMutableFlow = MutableStateFlow(false)
    // This is a flag to ensure that the call is started only once
    // This is to avoid a lag between updating isDefaultParametersCallStarted
    private var callStartRequested = false

    private var isWhiteboardEnabled = false
    private var pinnedUserIdentifier: String? = null
    private var turnOffVideoParticipantsIds: MutableList<String> = mutableListOf()

    val moreCallOptionsListViewModel = callingViewModelProvider.moreCallOptionsListViewModel
    val participantGridViewModel = callingViewModelProvider.participantGridViewModel
    val controlBarViewModel = callingViewModelProvider.controlBarViewModel
    val confirmLeaveOverlayViewModel = callingViewModelProvider.confirmLeaveOverlayViewModel
    val localParticipantViewModel = callingViewModelProvider.localParticipantViewModel
    val floatingHeaderViewModel = callingViewModelProvider.floatingHeaderViewModel
    val upperMessageBarNotificationLayoutViewModel = callingViewModelProvider.upperMessageBarNotificationLayoutViewModel
    val toastNotificationViewModel = callingViewModelProvider.toastNotificationViewModel
    val audioDeviceListViewModel = callingViewModelProvider.audioDeviceListViewModel
    val participantListViewModel = callingViewModelProvider.participantListViewModel
    val bannerViewModel = callingViewModelProvider.bannerViewModel
    val waitingLobbyOverlayViewModel = callingViewModelProvider.waitingLobbyOverlayViewModel
    val connectingLobbyOverlayViewModel = callingViewModelProvider.connectingOverlayViewModel
    val holdOverlayViewModel = callingViewModelProvider.onHoldOverlayViewModel
    val errorInfoViewModel = callingViewModelProvider.errorInfoViewModel
    val lobbyHeaderViewModel = callingViewModelProvider.lobbyHeaderViewModel
    val lobbyErrorHeaderViewModel = callingViewModelProvider.lobbyErrorHeaderViewModel
    val participantMenuViewModel = callingViewModelProvider.participantMenuViewModel
    val captionsListViewModel = callingViewModelProvider.captionsListViewModel
    val captionsLanguageSelectionListViewModel = callingViewModelProvider.captionsLanguageSelectionListViewModel
    val captionsLayoutViewModel = callingViewModelProvider.captionsViewModel
    val moreActionsListViewModel = callingViewModelProvider.moreActionsListViewModel
    val meetingViewListViewModel = callingViewModelProvider.meetingViewListViewModel
    val isCaptionsVisibleFlow: StateFlow<Boolean> = isCaptionsVisibleMutableFlow
    var isCaptionsMaximized: Boolean = false
    val whiteboardId: String = store.getCurrentState().callState.whiteboardId.orEmpty()

    fun switchFloatingHeader() {
        floatingHeaderViewModel.switchFloatingHeader()
    }

    fun requestCallEndOnBackPressed() {
        confirmLeaveOverlayViewModel.requestExitConfirmation()
    }

    fun requestCallEnd() {
        callScreenOptions?.controlBarOptions?.leaveCallConfirmation?.let {
            if (it == CallCompositeLeaveCallConfirmationMode.ALWAYS_ENABLED) {
                confirmLeaveOverlayViewModel.requestExitConfirmation()
            } else {
                leaveCallWithoutConfirmation()
            }
        }
            // Default to always enabled
            ?: confirmLeaveOverlayViewModel.requestExitConfirmation()
    }

    fun onShareMeetingLinkClicked() {
        _shareMeetingLinkMutableFlow.tryEmit(store.getCurrentState().callState.callIdForSharing.orEmpty())
    }

    override fun init(coroutineScope: CoroutineScope) {
        val state = store.getCurrentState()
        val remoteParticipantsForGridView = remoteParticipantsForGridView(state.remoteParticipantState.participantMap)
        val remoteParticipantsWithOutWhiteboard = state.remoteParticipantState.participantMap.toMutableMap().apply { remove(whiteboardId) }

        controlBarViewModel.init(
            permissionState = state.permissionState,
            cameraState = state.localParticipantState.cameraState,
            audioState = state.localParticipantState.audioState,
            callState = state.callState,
            requestCallEndCallback = this::requestCallEnd,
            openAudioDeviceSelectionMenuCallback = audioDeviceListViewModel::displayAudioDeviceSelectionMenu,
            visibilityState = state.visibilityState,
            audioVideoMode = state.localParticipantState.audioVideoMode,
            capabilities = state.localParticipantState.capabilities,
            buttonViewDataState = state.buttonState,
            controlBarOptions = callScreenOptions?.controlBarOptions,
            deviceConfigurationState = state.deviceConfigurationState,
        )

        localParticipantViewModel.init(
            state.localParticipantState.displayName,
            state.localParticipantState.audioState.operation,
            state.localParticipantState.videoStreamID,
            remoteParticipantsForGridView.count(),
            state.callState.callingStatus,
            state.localParticipantState.cameraState.device,
            state.localParticipantState.cameraState.camerasCount,
            state.visibilityState.status,
            avMode,
            isOverlayDisplayedOverGrid(state),
            state.localParticipantState.raisedHandStatus
        )

        floatingHeaderViewModel.init(
            remoteParticipantsWithOutWhiteboard.count(),
            state.callScreenInfoHeaderState,
            state.buttonState,
            isOverlayDisplayedOverGrid(state),
            this::requestCallEndOnBackPressed,
            /* <CALL_START_TIME>
            state.callState.callStartTime,
            </CALL_START_TIME> */
        )

        audioDeviceListViewModel.init(
            state.localParticipantState.audioState,
            state.visibilityState
        )
        bannerViewModel.init(
            state.callState,
            isOverlayDisplayedOverGrid(state),
        )

        participantListViewModel.init(
            callType,
            remoteParticipantsWithOutWhiteboard,
            state.localParticipantState,
            shouldShowLobby(
                state.localParticipantState.capabilities,
                state.visibilityState
            ),
            displayParticipantMenuCallback = { id, _ -> openParticipantMenu(id) },
            state.remoteParticipantState.totalParticipantCount
        )

        waitingLobbyOverlayViewModel.init(shouldDisplayLobbyOverlay(state))

        connectingLobbyOverlayViewModel.init(
            state.callState,
            state.permissionState,
            networkManager,
            state.localParticipantState.cameraState,
            state.localParticipantState.audioState,
            state.localParticipantState.initialCallJoinState,
        )

        holdOverlayViewModel.init(state.callState.callingStatus, state.audioSessionState.audioFocusStatus)

        participantGridViewModel.init(
            state.rttState,
            isOverlayDisplayedOverGrid(state),
            state.deviceConfigurationState,
            state.captionsState,
            displayParticipantMenuCallback = { id -> openParticipantMenu(id) }
        )

        lobbyHeaderViewModel.init(
            state.callState.callingStatus,
            getLobbyParticipantsForHeader(state),
            shouldShowLobby(
                state.localParticipantState.capabilities,
                state.visibilityState
            )
        )

        lobbyErrorHeaderViewModel.init(
            state.callState.callingStatus,
            state.remoteParticipantState.lobbyErrorCode,
            shouldShowLobby(
                state.localParticipantState.capabilities,
                state.visibilityState,
            )
        )

        captionsListViewModel.init(
            state.captionsState,
            state.callState.callingStatus,
            state.visibilityState,
            state.buttonState,
            state.rttState,
            state.navigationState,
        )
        captionsLanguageSelectionListViewModel.init(state.captionsState, state.visibilityState, state.navigationState)
        isCaptionsVisibleMutableFlow.value =
            shouldShowCaptionsUI(state.visibilityState, state.captionsState.status, state.rttState)
        captionsLayoutViewModel.init(
            state.captionsState,
            state.rttState,
            isCaptionsVisibleMutableFlow.value,
            state.deviceConfigurationState,
        )

        moreCallOptionsListViewModel.init(
            state.visibilityState,
            state.buttonState,
            state.navigationState
        )

        toastNotificationViewModel.init(
            coroutineScope,
        )

        isCaptionsMaximized = state.rttState.isMaximized

        moreActionsListViewModel.init(
            callType = callType,
            cameraState = state.localParticipantState.cameraState,
            raisedHandStatus = state.localParticipantState.raisedHandStatus,
            navigationState = state.navigationState,
            buttonState = state.buttonState,
            shareScreenStatus = state.localParticipantState.shareScreenStatus,
            participantsCount = state.remoteParticipantState.totalParticipantCount,
            meetingViewMode = state.localParticipantState.meetingViewMode,
            displayParticipantList = { participantListViewModel.displayParticipantList() },
            displayMeetingViewList = { meetingViewListViewModel.displayMeetingViewSelectionMenu() }
        )

        meetingViewListViewModel.init(meetingViewMode = state.localParticipantState.meetingViewMode)

        super.init(coroutineScope)
    }

    override suspend fun onStateChange(state: ReduxState) {
        if (!state.callState.isDefaultParametersCallStarted &&
            state.localParticipantState.initialCallJoinState.skipSetupScreen &&
            state.permissionState.audioPermissionState == PermissionStatus.GRANTED &&
            !callStartRequested
        ) {
            callStartRequested = true
            store.dispatch(action = CallingAction.CallRequestedWithoutSetup())
        }

        if (state.lifecycleState.state == LifecycleStatus.BACKGROUND) {
            participantGridViewModel.clear()
            localParticipantViewModel.clear()
            return
        }

        val remoteParticipantsForGridView = remoteParticipantsForGridView(state.remoteParticipantState.participantMap)
        val remoteParticipantsWithOutWhiteboard = state.remoteParticipantState.participantMap.toMutableMap().apply { remove(whiteboardId) }
        val remoteParticipantsInAllStatesCount = state.remoteParticipantState.participantMap.count()
        val hiddenRemoteParticipantsCount = remoteParticipantsInAllStatesCount - remoteParticipantsForGridView.count()
        val totalParticipantCountExceptHidden = remoteParticipantsWithOutWhiteboard.count() - hiddenRemoteParticipantsCount

        controlBarViewModel.update(
            state.permissionState,
            state.localParticipantState.cameraState,
            state.localParticipantState.audioState,
            state.callState.callingStatus,
            state.visibilityState,
            state.localParticipantState.audioVideoMode,
            state.localParticipantState.capabilities,
            state.buttonState,
            deviceConfigurationState = state.deviceConfigurationState,
        )

        localParticipantViewModel.update(
            state.localParticipantState.displayName,
            state.localParticipantState.audioState.operation,
            state.localParticipantState.videoStreamID,
            remoteParticipantsForGridView.count(),
            state.callState.callingStatus,
            state.localParticipantState.cameraState.device,
            state.localParticipantState.cameraState.camerasCount,
            state.visibilityState.status,
            avMode,
            shouldDisplayLobbyOverlay(state),
            state.localParticipantState.raisedHandStatus,
            state.localParticipantState.reactionType
        )

        audioDeviceListViewModel.update(
            state.localParticipantState.audioState,
            state.visibilityState
        )

        waitingLobbyOverlayViewModel.update(shouldDisplayLobbyOverlay(state))
        connectingLobbyOverlayViewModel.update(
            state.callState,
            state.localParticipantState.cameraState.operation,
            state.permissionState,
            state.localParticipantState.audioState.operation,
            state.localParticipantState.initialCallJoinState
        )
        holdOverlayViewModel.update(state.callState.callingStatus, state.audioSessionState.audioFocusStatus)

        if (state.callState.callingStatus == CallingStatus.LOCAL_HOLD) {
            participantGridViewModel.update(
                remoteParticipantsMapUpdatedTimestamp = System.currentTimeMillis(),
                remoteParticipantsMap = mapOf(),
                dominantSpeakersInfo = listOf(),
                raisedHandInfo = listOf(),
                dominantSpeakersModifiedTimestamp = System.currentTimeMillis(),
                raisedHandModifiedTimestamp = System.currentTimeMillis(),
                visibilityStatus = state.visibilityState.status,
                rttState = state.rttState,
                isOverlayDisplayedOverGrid = isOverlayDisplayedOverGrid(state),
                deviceConfigurationState = state.deviceConfigurationState,
                captionsState = state.captionsState,
                reaction = state.remoteParticipantState.reactionInfo,
                reactionModifiedTimestamp = state.remoteParticipantState.reactionModifiedTimestamp,
                meetingViewMode = state.localParticipantState.meetingViewMode,
                meetingViewModeModifiedTimestamp = System.currentTimeMillis()
            )
            floatingHeaderViewModel.dismiss()
            lobbyHeaderViewModel.dismiss()
            lobbyErrorHeaderViewModel.dismiss()
            participantListViewModel.closeParticipantList()
            localParticipantViewModel.update(
                state.localParticipantState.displayName,
                state.localParticipantState.audioState.operation,
                state.localParticipantState.videoStreamID,
                0,
                state.callState.callingStatus,
                state.localParticipantState.cameraState.device,
                state.localParticipantState.cameraState.camerasCount,
                state.visibilityState.status,
                avMode,
                shouldDisplayLobbyOverlay(state),
                state.localParticipantState.raisedHandStatus,
                state.localParticipantState.reactionType
            )
        }

        if (shouldUpdateRemoteParticipantsViewModels(state)) {
            val updatedRemoteParticipantsForGridView = remoteParticipantsForGridView.mapValues { (id, participant) ->
                participant.copy(
                    isPinned = id == pinnedUserIdentifier,
                    isWhiteboard = id == state.callState.whiteboardId,
                    isVideoTurnOffForMe = turnOffVideoParticipantsIds.contains(id)
                )
            }

            isWhiteboardEnabled = updatedRemoteParticipantsForGridView.keys.contains(state.callState.whiteboardId)

            participantGridViewModel.update(
                remoteParticipantsMapUpdatedTimestamp = state.remoteParticipantState.participantMapModifiedTimestamp,
                remoteParticipantsMap = updatedRemoteParticipantsForGridView,
                dominantSpeakersInfo = state.remoteParticipantState.dominantSpeakersInfo,
                raisedHandInfo = state.remoteParticipantState.raisedHandsInfo,
                dominantSpeakersModifiedTimestamp = state.remoteParticipantState.dominantSpeakersModifiedTimestamp,
                raisedHandModifiedTimestamp = state.remoteParticipantState.raisedHandsModifiedTimestamp,
                visibilityStatus = state.visibilityState.status,
                rttState = state.rttState,
                isOverlayDisplayedOverGrid = isOverlayDisplayedOverGrid(state),
                deviceConfigurationState = state.deviceConfigurationState,
                captionsState = state.captionsState,
                reaction = state.remoteParticipantState.reactionInfo,
                reactionModifiedTimestamp = state.remoteParticipantState.reactionModifiedTimestamp,
                meetingViewMode = state.localParticipantState.meetingViewMode,
                meetingViewModeModifiedTimestamp = state.localParticipantState.meetingViewModeModifiedTimestamp
            )

            floatingHeaderViewModel.update(
                totalParticipantCountExceptHidden,
                state.callScreenInfoHeaderState,
                state.buttonState,
                isOverlayDisplayedOverGrid(state),
                /* <CALL_START_TIME>
                state.callState.callStartTime,
                </CALL_START_TIME> */
                state.visibilityState.status,
            )

            lobbyHeaderViewModel.update(
                state.callState.callingStatus,
                getLobbyParticipantsForHeader(state),
                shouldShowLobby(
                    state.localParticipantState.capabilities,
                    state.visibilityState
                )
            )

            lobbyErrorHeaderViewModel.update(
                state.callState.callingStatus,
                state.remoteParticipantState.lobbyErrorCode,
                shouldShowLobby(
                    state.localParticipantState.capabilities,
                    state.visibilityState
                )
            )

            upperMessageBarNotificationLayoutViewModel.update(
                state.callDiagnosticsState
            )

            toastNotificationViewModel.update(
                state.toastNotificationState
            )

            participantListViewModel.update(
                callType,
                remoteParticipantsWithOutWhiteboard,
                state.localParticipantState,
                state.visibilityState,
                shouldShowLobby(
                    state.localParticipantState.capabilities,
                    state.visibilityState
                ),
                totalParticipantCountExceptHidden
            )

            bannerViewModel.update(
                state.callState,
                state.visibilityState,
                isOverlayDisplayedOverGrid(state),
            )
        }

        confirmLeaveOverlayViewModel.update(state.visibilityState)

        moreCallOptionsListViewModel.update(
            state.visibilityState,
            state.buttonState,
            state.navigationState
        )

        state.localParticipantState.cameraState.error?.let {
            errorInfoViewModel.updateCallCompositeError(it)
        }

        captionsListViewModel.update(
            state.captionsState,
            state.callState.callingStatus,
            state.visibilityState,
            state.buttonState,
            state.rttState,
            state.navigationState,
        )
        captionsLanguageSelectionListViewModel.update(
            state.captionsState,
            state.visibilityState,
            state.navigationState
        )

        isCaptionsVisibleMutableFlow.value = shouldShowCaptionsUI(
            state.visibilityState,
            state.captionsState.status,
            state.rttState,
        )
        captionsLayoutViewModel.update(
            captionsState = state.captionsState,
            rttState = state.rttState,
            isVisible = isCaptionsVisibleMutableFlow.value,
            deviceConfigurationState = state.deviceConfigurationState,
        )
        isCaptionsMaximized = state.rttState.isMaximized

        moreActionsListViewModel.update(
            callType = callType,
            cameraState = state.localParticipantState.cameraState,
            raisedHandStatus = state.localParticipantState.raisedHandStatus,
            navigationState = state.navigationState,
            buttonState = state.buttonState,
            shareScreenStatus = state.localParticipantState.shareScreenStatus,
            participantsCount = state.remoteParticipantState.totalParticipantCount,
            meetingViewMode = state.localParticipantState.meetingViewMode
        )

        meetingViewListViewModel.update(meetingViewMode = state.localParticipantState.meetingViewMode)
    }

    private fun getLobbyParticipantsForHeader(state: ReduxState) =
        if (shouldShowLobby(state.localParticipantState.capabilities, state.visibilityState))
            state.remoteParticipantState.participantMap.filter { it.value.participantStatus == ParticipantStatus.IN_LOBBY }
        else mapOf()

    private fun shouldShowLobby(
        capabilities: Set<ParticipantCapabilityType>,
        visibilityState: VisibilityState,
    ): Boolean {
        if (visibilityState.status != VisibilityStatus.VISIBLE)
            return false

        return capabilitiesManager.hasCapability(capabilities, ParticipantCapabilityType.MANAGE_LOBBY)
    }

    private fun remoteParticipantsForGridView(participants: Map<String, ParticipantInfoModel>): Map<String, ParticipantInfoModel> =
        participants.filter {
            it.value.participantStatus != ParticipantStatus.DISCONNECTED &&
                it.value.participantStatus != ParticipantStatus.IN_LOBBY
        }

    private fun shouldUpdateRemoteParticipantsViewModels(state: ReduxState): Boolean {
        val isOutgoingCallInProgress = (
            state.callState.callingStatus == CallingStatus.RINGING ||
                state.callState.callingStatus == CallingStatus.CONNECTING
            ) &&
            callType == CallType.ONE_TO_N_OUTGOING
        val isOnRemoteHold = state.callState.callingStatus == CallingStatus.REMOTE_HOLD
        val isConnected = state.callState.callingStatus == CallingStatus.CONNECTED

        return isOutgoingCallInProgress || isOnRemoteHold || isConnected
    }

    private fun leaveCallWithoutConfirmation() {
        confirmLeaveOverlayViewModel.confirm()
    }

    fun shouldShowCaptionsUI(
        visibilityState: VisibilityState,
        captionsStatus: CaptionsStatus,
        rttState: RttState,
    ) =
        visibilityState.status == VisibilityStatus.VISIBLE && (
            rttState.isRttActive ||
                captionsStatus == CaptionsStatus.STARTED ||
                captionsStatus == CaptionsStatus.START_REQUESTED ||
                captionsStatus == CaptionsStatus.STOP_REQUESTED
            )

    fun minimizeCaptions() {
        dispatchAction(RttAction.UpdateMaximized(false))
    }

    fun onParticipantMenuClicked(id: String, type: ParticipantMenuType) {
        val currentState = store.getCurrentState()
        var currentParticipants = currentState.remoteParticipantState.participantMap.toMutableMap()

        if (type == ParticipantMenuType.PIN || type == ParticipantMenuType.UNPIN) {
            val oldPinnedParticipant = currentParticipants[pinnedUserIdentifier]

            if (oldPinnedParticipant != null) {
                currentParticipants[oldPinnedParticipant.userIdentifier] = oldPinnedParticipant.copy(isPinned = false, modifiedTimestamp = System.currentTimeMillis())
            }
        }

        // Find the participant and update their info
        val updatedParticipantInfo = currentParticipants[id]?.let { participantInfo ->
            when (type) {
                ParticipantMenuType.PIN -> {
                    this.pinnedUserIdentifier = id
                    participantInfo.copy(isPinned = true)
                }
                ParticipantMenuType.UNPIN -> {
                    this.pinnedUserIdentifier = null
                    participantInfo.copy(isPinned = false)
                }
                ParticipantMenuType.HIDE_VIDEO -> {
                    turnOffVideoParticipantsIds.add(id)
                    participantInfo.copy(isVideoTurnOffForMe = true)
                }
                ParticipantMenuType.SHOW_VIDEO -> {
                    turnOffVideoParticipantsIds.remove(id)
                    participantInfo.copy(isVideoTurnOffForMe = false)
                }
            }
        }

        if (updatedParticipantInfo != null) {
            // Create the updated map of participants
            val updatedMap = currentParticipants.toMutableMap()
            updatedMap[updatedParticipantInfo.userIdentifier] = updatedParticipantInfo.copy(modifiedTimestamp = System.currentTimeMillis())
            // Dispatch the action with the updated participant map
            dispatchAction(ParticipantAction.ListUpdated(updatedMap))
        } else {
            Log.e("CallingViewModel", "Participant with ID $id not found for menu action $type")
        }
    }

    private fun shouldDisplayLobbyOverlay(state: ReduxState) =
        state.callState.callingStatus == CallingStatus.IN_LOBBY

    private fun isOverlayDisplayedOverGrid(state: ReduxState): Boolean {
        return shouldDisplayLobbyOverlay(state) ||
            state.callState.callingStatus == CallingStatus.LOCAL_HOLD ||
            state.rttState.isMaximized
    }

    private fun openParticipantMenu(id: String) {
        val state = store.getCurrentState()
        state.remoteParticipantState.participantMap[id]?.let { participantInfoModel ->
            participantInfoModel.apply {
                isPinned = id == pinnedUserIdentifier
                isWhiteboard = id == state.callState.whiteboardId
                isVideoTurnOffForMe = turnOffVideoParticipantsIds.contains(id)
            }
            if (participantInfoModel.userIdentifier != whiteboardId) {
                participantMenuViewModel.displayParticipantMenu(isWhiteboardEnabled, participantInfoModel)
            }
        }
    }
}
