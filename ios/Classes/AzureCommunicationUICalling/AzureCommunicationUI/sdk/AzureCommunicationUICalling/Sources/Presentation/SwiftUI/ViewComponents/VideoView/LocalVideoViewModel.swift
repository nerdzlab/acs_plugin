//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation

class LocalVideoViewModel: ObservableObject {
    private let logger: Logger
    private let dispatch: ActionDispatch

    @Published var isPreviewEnable: Bool
    @Published var localVideoStreamId: String?
    @Published var displayName: String?
    @Published var isMuted = false
    @Published var cameraOperationalStatus: LocalUserState.CameraOperationalStatus = .off
    @Published var isInPip = false
    
    let localizationProvider: LocalizationProviderProtocol

    var cameraSwitchButtonPipViewModel: IconButtonViewModel!
    var cameraSwitchButtonFullViewModel: IconButtonViewModel!

    init(compositeViewModelFactory: CompositeViewModelFactoryProtocol,
         logger: Logger,
         isPreviewEnable: Bool,
         localizationProvider: LocalizationProviderProtocol,
         dispatchAction: @escaping ActionDispatch) {
        self.logger = logger
        self.localizationProvider = localizationProvider
        self.dispatch = dispatchAction
        self.isPreviewEnable = isPreviewEnable

        cameraSwitchButtonPipViewModel = compositeViewModelFactory.makeIconButtonViewModel(
            iconName: .switchCameraFilled,
            buttonType: .cameraSwitchButtonPip,
            isDisabled: false, renderAsOriginal: true) { [weak self] in
                guard let self = self else {
                    return
                }
                self.toggleCameraSwitchTapped()
        }
        cameraSwitchButtonFullViewModel = compositeViewModelFactory.makeIconButtonViewModel(
            iconName: .switchCameraFilled,
            buttonType: .cameraSwitchButtonFull,
            isDisabled: false, renderAsOriginal: true) { [weak self] in
                guard let self = self else {
                    return
                }
                self.toggleCameraSwitchTapped()
        }
    }

    func toggleCameraSwitchTapped() {
        dispatch(.localUserAction(.cameraSwitchTriggered))
    }

    func update(localUserState: LocalUserState, visibilityState: VisibilityState, isPreviewEnabled: Bool) {
        if localVideoStreamId != localUserState.localVideoStreamIdentifier {
            localVideoStreamId = localUserState.localVideoStreamIdentifier
        }
        
        if self.isPreviewEnable != isPreviewEnabled {
            self.isPreviewEnable = isPreviewEnabled
        }

        if displayName != localUserState.initialDisplayName {
            displayName = localUserState.initialDisplayName
        }

        if cameraOperationalStatus != localUserState.cameraState.operation {
            cameraOperationalStatus = localUserState.cameraState.operation
        }

        cameraSwitchButtonPipViewModel.update(isDisabled: localUserState.cameraState.device == .switching)
        cameraSwitchButtonPipViewModel.update(accessibilityLabel: localUserState.cameraState.device == .front
                                              ? localizationProvider.getLocalizedString(.frontCamera)
                                              : localizationProvider.getLocalizedString(.backCamera))

        cameraSwitchButtonFullViewModel.update(isDisabled: localUserState.cameraState.device == .switching)
        cameraSwitchButtonFullViewModel.update(accessibilityLabel: localUserState.cameraState.device == .front
                                               ? localizationProvider.getLocalizedString(.frontCamera)
                                               : localizationProvider.getLocalizedString(.backCamera))

        let showMuted = localUserState.audioState.operation != .on
        if isMuted != showMuted {
            isMuted = showMuted
        }

        isInPip = visibilityState.currentStatus == .pipModeEntered
    }
}
