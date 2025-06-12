package com.acs_plugin.calling.presentation.fragment.common.audiodevicelist

import com.acs_plugin.calling.redux.action.Action
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.state.AudioDeviceSelectionStatus
import com.acs_plugin.calling.redux.state.AudioState
import com.acs_plugin.calling.redux.state.VisibilityState
import com.acs_plugin.calling.redux.state.VisibilityStatus
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class AudioDeviceListViewModel(private val dispatch: (Action) -> Unit) {

    private val displayAudioDeviceSelectionMenuMutableStateFlow = MutableStateFlow(false)
    val displayAudioDeviceSelectionMenuStateFlow = displayAudioDeviceSelectionMenuMutableStateFlow as StateFlow<Boolean>

    private lateinit var audioStateMutableStateFlow: MutableStateFlow<AudioState>
    val audioStateFlow get() = audioStateMutableStateFlow as StateFlow<AudioState>

    fun init(
        audioState: AudioState,
        visibilityState: VisibilityState
    ) {
        audioStateMutableStateFlow = MutableStateFlow(audioState)
        if (visibilityState.status != VisibilityStatus.VISIBLE)
            closeAudioDeviceSelectionMenu()
    }

    fun update(
        audioState: AudioState,
        visibilityState: VisibilityState
    ) {
        audioStateMutableStateFlow.value = audioState
        if (visibilityState.status != VisibilityStatus.VISIBLE)
            closeAudioDeviceSelectionMenu()
    }

    fun switchAudioDevice(audioDeviceSelectionStatus: AudioDeviceSelectionStatus) {
        dispatch(
            LocalParticipantAction.AudioDeviceChangeRequested(
                audioDeviceSelectionStatus
            )
        )
    }

    fun displayAudioDeviceSelectionMenu() {
        displayAudioDeviceSelectionMenuMutableStateFlow.value = true
    }

    fun closeAudioDeviceSelectionMenu() {
        displayAudioDeviceSelectionMenuMutableStateFlow.value = false
    }
}
