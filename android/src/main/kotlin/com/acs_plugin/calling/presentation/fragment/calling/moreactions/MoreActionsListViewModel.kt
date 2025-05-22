package com.acs_plugin.calling.presentation.fragment.calling.moreactions

import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.MoreActionItem
import com.acs_plugin.calling.presentation.fragment.calling.moreactions.data.MoreActionType
import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.action.NavigationAction
import com.acs_plugin.calling.redux.state.BlurStatus
import com.acs_plugin.calling.redux.state.CameraOperationalStatus
import com.acs_plugin.calling.redux.state.CameraState
import com.acs_plugin.calling.redux.state.NavigationState
import com.acs_plugin.calling.redux.state.RaisedHandStatus
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
        displayParticipantList: () -> Unit
    ) {
        this.displayParticipantListCallback = displayParticipantList
        _displayStateFlow = MutableStateFlow(navigationState.showMoreMenu)
        _actionItemsFlow = MutableStateFlow(provideActionListItems(cameraState, raisedHandStatus))
    }

    fun update(
        cameraState: CameraState,
        raisedHandStatus: RaisedHandStatus,
        navigationState: NavigationState
    ) {
        _displayStateFlow.value = navigationState.showMoreMenu
        _actionItemsFlow.value = provideActionListItems(cameraState, raisedHandStatus)
    }

    fun close() {
        if (displayStateFlow.value)
            dispatch(NavigationAction.CloseMoreMenu())
    }

    fun onSendReaction() {} //TODO implement send reaction flow

    fun onActionClicked(actionType: MoreActionType) {
        when (actionType) {
            MoreActionType.PARTICIPANTS -> displayParticipantListCallback.invoke()
            MoreActionType.BLUR_ON -> dispatch(LocalParticipantAction.BlurPreviewOnTriggered())
            MoreActionType.BLUR_OFF -> dispatch(LocalParticipantAction.BlurPreviewOffTriggered())
            else -> {}
        }
    }

    private fun provideActionListItems(
        cameraState: CameraState,
        raisedHandStatus: RaisedHandStatus
    ): List<MoreActionItem> {
        val isCameraTurnOn = cameraState.operation == CameraOperationalStatus.ON

        return buildList {
            add(MoreActionType.CHAT.mapToMoreActionItem())
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
            add(MoreActionType.CHANGE_VIEW.mapToMoreActionItem())
            add(MoreActionType.SHARE_SCREEN.mapToMoreActionItem())
        }
    }
}