//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation

class LocalVideoViewModel: ObservableObject {
    private let logger: Logger
    private let dispatch: ActionDispatch

    @Published var localVideoStreamId: String?
    @Published var selectedReaction: ReactionPayload?
    @Published var displayName: String?
    @Published var isMuted = false
    @Published var cameraOperationalStatus: LocalUserState.CameraOperationalStatus = .off
    @Published var isInPip = false
    
    // A single timer for reaction removal
    private var reactionTimer: Timer?
    
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

    func update(localUserState: LocalUserState, visibilityState: VisibilityState) {
        if localVideoStreamId != localUserState.localVideoStreamIdentifier {
            localVideoStreamId = localUserState.localVideoStreamIdentifier
        }

        if displayName != localUserState.initialDisplayName {
            displayName = localUserState.initialDisplayName
        }

        if cameraOperationalStatus != localUserState.cameraState.operation {
            cameraOperationalStatus = localUserState.cameraState.operation
        }
        
        if selectedReaction != localUserState.selectedReaction {
            selectedReaction = localUserState.selectedReaction
            
            updateReactionTimer(reactionPayload: selectedReaction)
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
    
    func updateReactionTimer(reactionPayload: ReactionPayload?) {
        // If a reaction exists, invalidate the previous timer
        reactionTimer?.invalidate()
        
        guard let reactionPayload = reactionPayload else {
            return
        }
        
        guard let receivedOn = reactionPayload.receivedOn else {
            return
        }
        
        // Calculate the remaining time until the reaction should end
        let currentTime = Date()
        
        // Calculate the duration between receivedOn and the current time
        let timeRemaining = receivedOn.addingTimeInterval(3.0).timeIntervalSince(currentTime)
        
        // If the timeRemaining is positive, start the timer; otherwise, clear the reaction immediately
        if timeRemaining > 0 {
            // Start a new timer with dynamic duration
            reactionTimer = Timer.scheduledTimer(withTimeInterval: timeRemaining, repeats: false) { [weak self] _ in
                self?.dispatch(.localUserAction(.resetLocalUserReaction))
            }
        } else {
            dispatch(.localUserAction(.resetLocalUserReaction))
            
            ///Need send event to update participant list to set reaction to nill
        }
    }
}
