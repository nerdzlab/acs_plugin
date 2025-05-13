// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

package com.acs_plugin.calling.presentation.fragment.setup

import com.acs_plugin.calling.models.CallCompositeSetupScreenOptions
import com.acs_plugin.calling.presentation.fragment.BaseViewModel
import com.acs_plugin.calling.presentation.fragment.factories.SetupViewModelFactory
import com.acs_plugin.calling.presentation.manager.NetworkManager
import com.acs_plugin.calling.redux.Store
import com.acs_plugin.calling.redux.action.CallingAction
import com.acs_plugin.calling.redux.action.LocalParticipantAction
import com.acs_plugin.calling.redux.action.NavigationAction
import com.acs_plugin.calling.redux.state.AudioFocusStatus
import com.acs_plugin.calling.redux.state.ReduxState
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow

internal class SetupViewModel(
    store: Store<ReduxState>,
    setupViewModelProvider: SetupViewModelFactory,
    private val networkManager: NetworkManager,
    private val setupScreenOptions: CallCompositeSetupScreenOptions?,
) :
    BaseViewModel(store) {

    val warningsViewModel = setupViewModelProvider.warningsViewModel
    val setupControlBarViewModel = setupViewModelProvider.setupControlBarViewModel
    val localParticipantRendererViewModel = setupViewModelProvider.previewAreaViewModel
    val audioDeviceListViewModel = setupViewModelProvider.audioDeviceListViewModel
    val errorInfoViewModel = setupViewModelProvider.errorInfoViewModel
    val participantAvatarViewModel = setupViewModelProvider.participantAvatarViewModel
    val joinCallButtonHolderViewModel = setupViewModelProvider.joinCallButtonHolderViewModel

    val displayName: String?
        get() = store.getCurrentState().localParticipantState.displayName

    private var hideUserNameInputFlow = MutableStateFlow(false)
    fun getHideUserNameInputFlow(): StateFlow<Boolean> = hideUserNameInputFlow


    fun setupCall() {
        dispatchAction(action = CallingAction.SetupCall())
    }

    fun exitComposite() {
        // double check here if we need both the action to execute
        dispatchAction(action = CallingAction.CallEndRequested())
        dispatchAction(action = NavigationAction.Exit())
    }

    override fun init(coroutineScope: CoroutineScope) {
        val state = store.getCurrentState()
        if (store.getCurrentState().localParticipantState.initialCallJoinState.startWithMicrophoneOn) {
            store.dispatch(action = LocalParticipantAction.MicPreviewOnTriggered())
        }
        if (store.getCurrentState().localParticipantState.initialCallJoinState.startWithCameraOn) {
            store.dispatch(action = LocalParticipantAction.CameraPreviewOnRequested())
        }

        warningsViewModel.init(state.permissionState)
        localParticipantRendererViewModel.init(
            state.localParticipantState.videoStreamID,
        )
        setupControlBarViewModel.init(
            state.permissionState,
            state.localParticipantState.cameraState,
            state.localParticipantState.audioVideoMode,
            state.localParticipantState.audioState,
            state.callState,
            audioDeviceListViewModel::displayAudioDeviceSelectionMenu,
            setupScreenOptions,
            state.buttonState,
        )
        audioDeviceListViewModel.init(
            state.localParticipantState.audioState,
            state.visibilityState
        )
        participantAvatarViewModel.init(
            state.localParticipantState.displayName,
            state.localParticipantState.videoStreamID,
            state.permissionState,
        )
        joinCallButtonHolderViewModel.init(
            state.permissionState.audioPermissionState,
            state.permissionState.cameraPermissionState,
            state.localParticipantState.cameraState.operation,
            state.localParticipantState.cameraState.camerasCount,
            networkManager,
            onStartCallBtnClicked = { hideUserNameInputFlow.value = true }
        )

        super.init(coroutineScope)
    }

    override suspend fun onStateChange(state: ReduxState) {

        setupControlBarViewModel.update(
            state.permissionState,
            state.localParticipantState.cameraState,
            state.localParticipantState.audioVideoMode,
            state.localParticipantState.audioState,
            state.callState,
            state.buttonState,
        )
        warningsViewModel.update(state.permissionState)
        localParticipantRendererViewModel.update(
            state.localParticipantState.videoStreamID,
        )
        audioDeviceListViewModel.update(
            state.localParticipantState.audioState,
            state.visibilityState
        )
        errorInfoViewModel.updateCallStateError(state.errorState)
        errorInfoViewModel.updateAudioFocusRejectedState(
            state.audioSessionState.audioFocusStatus == AudioFocusStatus.REJECTED
        )
        state.localParticipantState.cameraState.error?.let {
            errorInfoViewModel.updateCallCompositeError(it)
        }
        participantAvatarViewModel.update(
            state.localParticipantState.videoStreamID,
            state.permissionState
        )
        joinCallButtonHolderViewModel.update(
            state.permissionState.audioPermissionState,
            state.callState,
            state.permissionState.cameraPermissionState,
            state.localParticipantState.cameraState.operation,
            state.localParticipantState.cameraState.camerasCount
        )
    }

    fun onUserNameChanged(name: String) {} //TODO Implement logic with user name updates
}
