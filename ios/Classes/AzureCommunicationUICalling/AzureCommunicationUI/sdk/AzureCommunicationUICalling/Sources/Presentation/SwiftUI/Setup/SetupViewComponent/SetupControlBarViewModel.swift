//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation

class SetupControlBarViewModel: ObservableObject {
    @Published var cameraPermission: AppPermission.Status = .unknown
    @Published var audioPermission: AppPermission.Status = .unknown
    @Published var isAudioDeviceSelectionDisplayed = false
    @Published var isCameraButtonVisible = true
    @Published var isMicButtonVisible = true
    @Published var isAudioDeviceButtonVisible = true

    private let logger: Logger
    private let dispatch: ActionDispatch
    private let localizationProvider: LocalizationProviderProtocol
    private let audioVideoMode: CallCompositeAudioVideoMode
    private var buttonViewDataState: ButtonViewDataState

    private var isJoinRequested = false
    private var isDefaultUserStateMapped = false
    private var callingStatus: CallingStatus = .none
    private var cameraStatus: LocalUserState.CameraOperationalStatus = .off
    private(set) var micStatus: LocalUserState.AudioOperationalStatus = .off
    private var localVideoStreamId: String?
    private(set) var cameraButtonViewModel: PrimaryIconButtonViewModel<CameraButtonState>!
    private(set) var micButtonViewModel: PrimaryIconButtonViewModel<MicButtonState>!
    private(set) var backgroundEffectButtonViewModel: PrimaryIconButtonViewModel<BackgroundEffectButtonState>!
    private(set) var switchCameraButtonViewModel: PrimaryIconButtonViewModel<SwitchCameraButtonState>!
    private(set) var audioDeviceButtonViewModel: PrimaryIconButtonViewModel<AudioButtonState>!

    init(compositeViewModelFactory: CompositeViewModelFactoryProtocol,
         logger: Logger,
         dispatchAction: @escaping ActionDispatch,
         updatableOptionsManager: UpdatableOptionsManagerProtocol,
         localUserState: LocalUserState,
         localizationProvider: LocalizationProviderProtocol,
         audioVideoMode: CallCompositeAudioVideoMode,
         setupScreenOptions: SetupScreenOptions?,
         buttonViewDataState: ButtonViewDataState
    ) {
        self.logger = logger
        self.dispatch = dispatchAction
        self.localizationProvider = localizationProvider
        self.audioVideoMode = audioVideoMode
        self.buttonViewDataState = buttonViewDataState

        cameraButtonViewModel = compositeViewModelFactory.makePrimaryIconButtonViewModel(
            selectedButtonState: CameraButtonState.videoOff,
            localizationProvider: self.localizationProvider,
            isDisabled: isCameraDisabled()) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.callCustomOnClickHandler(updatableOptionsManager.setupScreenOptions?.cameraButton)
                self.logger.debug("Toggle camera button tapped")
                self.videoButtonTapped()
        }

        cameraButtonViewModel.accessibilityLabel = self.localizationProvider.getLocalizedString(
            .videoOffAccessibilityLabel)

        micButtonViewModel = compositeViewModelFactory.makePrimaryIconButtonViewModel(
            selectedButtonState: MicButtonState.micOff,
            localizationProvider: self.localizationProvider,
            isDisabled: isMicButtonDisabled()) { [weak self] in
                guard let self = self else {
                    return
                }
                self.callCustomOnClickHandler(updatableOptionsManager.setupScreenOptions?.microphoneButton)
                self.logger.debug("Toggle microphone button tapped")
                self.microphoneButtonTapped()
        }
        micButtonViewModel.accessibilityLabel = self.localizationProvider.getLocalizedString(.micOffAccessibilityLabel)

        audioDeviceButtonViewModel = compositeViewModelFactory.makePrimaryIconButtonViewModel(
            selectedButtonState: AudioButtonState.speaker,
            localizationProvider: self.localizationProvider,
            isDisabled: isAudioDeviceButtonDisabled()) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.endEditing()
                self.callCustomOnClickHandler(updatableOptionsManager.setupScreenOptions?.audioDeviceButton)
                self.logger.debug("Select audio device button tapped")
                self.selectAudioDeviceButtonTapped()
        }
        audioDeviceButtonViewModel.accessibilityLabel = self.localizationProvider.getLocalizedString(
            .deviceAccesibiiltyLabel)
        
        backgroundEffectButtonViewModel = compositeViewModelFactory.makePrimaryIconButtonViewModel(
            selectedButtonState: BackgroundEffectButtonState.off,
            localizationProvider: self.localizationProvider,
            isDisabled: cameraStatus == LocalUserState.CameraOperationalStatus.off) { [weak self] in
                guard let self = self else {
                    return
                }
        
                self.endEditing()
                self.logger.debug("Background effect button tapped")
                self.backgroundEffectButtonTapped()
        }
        
        switchCameraButtonViewModel = compositeViewModelFactory.makePrimaryIconButtonViewModel(
            selectedButtonState: SwitchCameraButtonState.default,
            localizationProvider: self.localizationProvider,
            isDisabled: cameraStatus == LocalUserState.CameraOperationalStatus.off) { [weak self] in
                guard let self = self else {
                    return
                }
        
                self.logger.debug("Switch camera button tapped")
                self.switchCameraButtonTapped()
        }

        isCameraButtonVisible = shouldCameraButtonBeVisible(audioVideoMode, buttonViewDataState)
        isMicButtonVisible = shouldMicButtonBeVisible(buttonViewDataState)
        isAudioDeviceButtonVisible = shouldsAudioDeviceButtonBeVisible(buttonViewDataState)
    }

    private func callCustomOnClickHandler(_ button: ButtonViewData?) {
        guard let button = button else {
            return
        }
        button.onClick?(button)
    }

    func videoButtonTapped() {
        let isPreview = callingStatus == .none
        let isCameraOn = cameraStatus == .on
        switch (isCameraOn, isPreview) {
        case (false, true):
            dispatch(.localUserAction(.cameraPreviewOnTriggered))
        case (false, false):
            dispatch(.localUserAction(.cameraOnTriggered))
        case (true, _):
            dispatch(.localUserAction(.cameraOffTriggered))
        }
    }
    
    func backgroundEffectButtonTapped() {
        dispatch(.showBackgroundEffectsView)
    }
    
    func switchCameraButtonTapped() {
        dispatch(.localUserAction(.cameraSwitchTriggered))
    }

    func microphoneButtonTapped() {
        let isPreview = callingStatus == .none
        let isMicOn = micStatus == .on
        switch (isMicOn, isPreview) {
        case (false, true):
            dispatch(.localUserAction(.microphonePreviewOn))
        case (false, false):
            dispatch(.localUserAction(.microphoneOnTriggered))
        case (true, true):
            dispatch(.localUserAction(.microphonePreviewOff))
        case (true, false):
            dispatch(.localUserAction(.microphoneOffTriggered))
        }
    }

    func selectAudioDeviceButtonTapped() {
        dispatch(.showAudioSelection)
        isAudioDeviceSelectionDisplayed = true
    }

    func isCameraDisabled() -> Bool {
        return buttonViewDataState.setupScreenCameraButtonState?.enabled == false ||
        isJoinRequested ||
        cameraPermission == .denied
    }

    func isMicButtonDisabled() -> Bool {
        return buttonViewDataState.setupScreenMicButtonState?.enabled == false ||
        isJoinRequested ||
        audioPermission == .denied
    }

    func isAudioDeviceButtonDisabled() -> Bool {
        return buttonViewDataState.setupScreenAudioDeviceButtonState?.enabled == false ||
        isJoinRequested
    }

    func isControlBarHidden() -> Bool {
        return audioPermission == .denied
    }

    func update(localUserState: LocalUserState,
                permissionState: PermissionState,
                callingState: CallingState,
                buttonViewDataState: ButtonViewDataState) {
        self.buttonViewDataState = buttonViewDataState
        if cameraPermission != permissionState.cameraPermission {
            cameraPermission = permissionState.cameraPermission
        }
        if audioPermission != permissionState.audioPermission {
            audioPermission = permissionState.audioPermission
        }
        callingStatus = callingState.status
        cameraStatus = localUserState.cameraState.operation
        micStatus = localUserState.audioState.operation
        updateButtonViewModel(localUserState: localUserState, buttonViewDataState: buttonViewDataState)
        if localVideoStreamId != localUserState.localVideoStreamIdentifier {
            localVideoStreamId = localUserState.localVideoStreamIdentifier
        }
        isCameraButtonVisible = shouldCameraButtonBeVisible(audioVideoMode, buttonViewDataState)
        isMicButtonVisible = shouldMicButtonBeVisible(buttonViewDataState)
        isAudioDeviceButtonVisible = shouldsAudioDeviceButtonBeVisible(buttonViewDataState)
    }

    func update(isJoinRequested: Bool) {
        self.isJoinRequested = isJoinRequested
        cameraButtonViewModel.update(isDisabled: isCameraDisabled())
        micButtonViewModel.update(isDisabled: isMicButtonDisabled())
    }

    private func updateButtonViewModel(localUserState: LocalUserState,
                                       buttonViewDataState: ButtonViewDataState) {
        cameraButtonViewModel.update(
            selectedButtonState: cameraStatus == .on ? CameraButtonState.videoOn : CameraButtonState.videoOff)
        
        backgroundEffectButtonViewModel.update(
            isDisabled: cameraStatus == .off)
        
        switchCameraButtonViewModel.update(isDisabled: cameraStatus == .off)
        
        cameraButtonViewModel.update(accessibilityLabel: cameraStatus == .on
                                     ? localizationProvider.getLocalizedString(.videoOnAccessibilityLabel)
                                     : localizationProvider.getLocalizedString(.videoOffAccessibilityLabel))
        cameraButtonViewModel.update(isDisabled: isCameraDisabled())

        micButtonViewModel.update(
            selectedButtonState: micStatus == .on ? MicButtonState.micOn : MicButtonState.micOff)
        micButtonViewModel.update(accessibilityLabel: micStatus == .on
                                     ? localizationProvider.getLocalizedString(.micOnAccessibilityLabel)
                                     : localizationProvider.getLocalizedString(.micOffAccessibilityLabel))
        micButtonViewModel.update(isDisabled: isMicButtonDisabled())

        let audioDeviceStatus = localUserState.audioState.device
        audioDeviceButtonViewModel.update(isDisabled: isAudioDeviceButtonDisabled())
        audioDeviceButtonViewModel.update(
            selectedButtonState: getAudioButtonState(localUserState: localUserState))
        audioDeviceButtonViewModel.update(
            accessibilityValue: audioDeviceStatus.getLabel(localizationProvider: localizationProvider))
    }
    
    private func getAudioButtonState(localUserState: LocalUserState) -> AudioButtonState {
        
        if localUserState.incomingAudioState.operation == .muted {
            return AudioButtonState.incomingAudioMuted
        } else {
            let audioDeviceStatus = localUserState.audioState.device
           return AudioButtonState.getButtonState(from: audioDeviceStatus)
        }
    }

    private func shouldCameraButtonBeVisible(
        _ audioVideoMode: CallCompositeAudioVideoMode,
        _ buttonViewDataState: ButtonViewDataState) -> Bool {
            return buttonViewDataState.setupScreenCameraButtonState?.visible ?? true && audioVideoMode != .audioOnly
    }

    private func shouldMicButtonBeVisible(
        _ buttonViewDataState: ButtonViewDataState) -> Bool {
            return buttonViewDataState.setupScreenMicButtonState?.visible ?? true
    }

    private func shouldsAudioDeviceButtonBeVisible(
        _ buttonViewDataState: ButtonViewDataState) -> Bool {
            return buttonViewDataState.setupScreenAudioDeviceButtonState?.visible ?? true
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
}
