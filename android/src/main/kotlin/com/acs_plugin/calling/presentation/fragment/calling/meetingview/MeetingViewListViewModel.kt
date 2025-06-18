package com.acs_plugin.calling.presentation.fragment.calling.meetingview

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.state.MeetingViewMode
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class MeetingViewListViewModel(private val dispatch: (Action) -> Unit) {

    private val displayMeetingViewSelectionMutableStateFlow = MutableStateFlow(false)
    val displayMeetingViewSelectionStateFlow = displayMeetingViewSelectionMutableStateFlow as StateFlow<Boolean>

    private lateinit var meetingViewModeMutableStateFlow: MutableStateFlow<MeetingViewMode>
    val meetingViewModeStateFlow get() = meetingViewModeMutableStateFlow as StateFlow<MeetingViewMode>

    fun init(meetingViewMode: MeetingViewMode) {
        meetingViewModeMutableStateFlow = MutableStateFlow(meetingViewMode)
    }

    fun update(meetingViewMode: MeetingViewMode) {
        meetingViewModeMutableStateFlow.value = meetingViewMode
    }

    fun switchMeetingView(meetingViewMode: MeetingViewMode) {
        when (meetingViewMode) {
            MeetingViewMode.GALLERY -> dispatch(LocalParticipantAction.GalleryViewTriggered())
            MeetingViewMode.SPEAKER -> dispatch(LocalParticipantAction.SpeakerViewTriggered())
        }
    }

    fun displayMeetingViewSelectionMenu() {
        displayMeetingViewSelectionMutableStateFlow.value = true
    }

    fun closeMeetingViewSelectionMenu() {
        displayMeetingViewSelectionMutableStateFlow.value = false
    }
}