package com.acs_plugin.calling.presentation.fragment.calling.moreactions

import com.acs_plugin.Constants
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.MoreActionItem
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.MoreActionType
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.ReactionType
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.action.NavigationAction
import com.acs_plugin.calling.redux.state.BlurStatus
import com.acs_plugin.calling.redux.state.ButtonState
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.redux.state.CameraState
import com.acs_plugin.calling.redux.state.NavigationState
import com.acs_plugin.calling.redux.state.RaisedHandStatus
import com.acs_plugin.calling.redux.state.ShareScreenStatus
import com.acs_plugin.extension.falseIfNull
import com.acs_plugin.utils.FlutterEventDispatcher
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class MoreActionsListViewModel(
    private val dispatch: (Action) -> Unit
) {

    private lateinit var _displayStateFlow: MutableStateFlow<Boolean>
    val displayStateFlow: StateFlow<Boolean> get() = _displayStateFlow

    private lateinit var _actionItemsFlow: MutableStateFlow<List<MoreActionItem>>
    val actionItemsFlow: StateFlow<List<MoreActionItem>> get() = _actionItemsFlow

    private lateinit var displayParticipantListCallback: () -> Unit

    fun init(
        cameraState: CameraState,
        raisedHandStatus: RaisedHandStatus,
        navigationState: NavigationState,
        buttonState: ButtonState,
        shareScreenStatus: ShareScreenStatus,
        displayParticipantList: () -> Unit
    ) {
        this.displayParticipantListCallback = displayParticipantList
        _displayStateFlow = MutableStateFlow(navigationState.showMoreMenu)
        _actionItemsFlow = MutableStateFlow(provideActionListItems(cameraState, raisedHandStatus, buttonState, shareScreenStatus))
    }

    fun update(
        cameraState: CameraState,
        raisedHandStatus: RaisedHandStatus,
        navigationState: NavigationState,
        buttonState: ButtonState,
        shareScreenStatus: ShareScreenStatus
    ) {
        _displayStateFlow.value = navigationState.showMoreMenu
        _actionItemsFlow.value = provideActionListItems(cameraState, raisedHandStatus, buttonState, shareScreenStatus)
    }

    fun close() {
        if (displayStateFlow.value)
            dispatch(NavigationAction.CloseMoreMenu())
    }

    fun onSendReaction(reactionType: ReactionType) {
        dispatch(LocalParticipantAction.SendReactionTriggered(reactionType))
    }

    fun onActionClicked(actionType: MoreActionType) {
        when (actionType) {
            MoreActionType.CHAT -> FlutterEventDispatcher.sendEvent(Constants.FlutterEvents.ON_SHOW_CHAT)
            MoreActionType.PARTICIPANTS -> displayParticipantListCallback.invoke()
            MoreActionType.BLUR_ON -> dispatch(LocalParticipantAction.BlurPreviewOnTriggered())
            MoreActionType.BLUR_OFF -> dispatch(LocalParticipantAction.BlurPreviewOffTriggered())
            MoreActionType.RAISE_HAND -> dispatch(LocalParticipantAction.RaiseHandTriggered())
            MoreActionType.LOWER_HAND -> dispatch(LocalParticipantAction.LowerHandTriggered())
            MoreActionType.SHARE_SCREEN -> dispatch(LocalParticipantAction.ShareScreenTriggered())
            MoreActionType.STOP_SHARE_SCREEN -> dispatch(LocalParticipantAction.StopShareScreenTriggered())
            else -> {}
        }
    }

    private fun provideActionListItems(
        cameraState: CameraState,
        raisedHandStatus: RaisedHandStatus,
        buttonState: ButtonState,
        shareScreenStatus: ShareScreenStatus
    ): List<MoreActionItem> {
        val isCameraTurnOn = cameraState.operation == CameraOperationalStatus.ON

        return buildList {
            add(MoreActionType.CHAT.mapToMoreActionItem().apply {
                isEnabled = buttonState.callScreenHeaderChatButtonsState?.isEnabled.falseIfNull()
            })
            add(MoreActionType.PARTICIPANTS.mapToMoreActionItem())
            if (cameraState.blurStatus == BlurStatus.ON) {
                add(MoreActionType.BLUR_OFF.mapToMoreActionItem().apply { isEnabled = isCameraTurnOn })
            } else {
                add(MoreActionType.BLUR_ON.mapToMoreActionItem().apply { isEnabled = isCameraTurnOn })
            }
            if (raisedHandStatus == RaisedHandStatus.RAISED) {
                add(MoreActionType.LOWER_HAND.mapToMoreActionItem())
            } else {
                add(MoreActionType.RAISE_HAND.mapToMoreActionItem())
            }
            add(MoreActionType.CHANGE_VIEW.mapToMoreActionItem().apply { isEnabled = false }) //TODO Enabled after feature implementation
            if (shareScreenStatus == ShareScreenStatus.ON) {
                add(MoreActionType.STOP_SHARE_SCREEN.mapToMoreActionItem())
            } else {
                add(MoreActionType.SHARE_SCREEN.mapToMoreActionItem().apply { isEnabled = false }) //TODO Enabled after feature implementation
            }
        }
    }
}