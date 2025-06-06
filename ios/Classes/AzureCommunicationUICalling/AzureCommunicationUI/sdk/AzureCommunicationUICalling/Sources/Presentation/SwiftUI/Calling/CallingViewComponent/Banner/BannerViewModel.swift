//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine
import SwiftUI

class BannerViewModel: ObservableObject {

    @Published var isBannerDisplayed = false
    var bannerTextViewModel: BannerTextViewModel
    var bannerBackgroundColor: Color

    private let dispatch: ActionDispatch

    var dismissButtonViewModel: IconButtonViewModel!

    init(compositeViewModelFactory: CompositeViewModelFactoryProtocol, dispatchAction: @escaping ActionDispatch) {
        self.bannerBackgroundColor = .white
        self.dispatch = dispatchAction
        self.bannerTextViewModel = compositeViewModelFactory.makeBannerTextViewModel()
        self.dismissButtonViewModel = compositeViewModelFactory.makeIconButtonViewModel(
            iconName: .whiteClose,
            buttonType: .dismissButton,
            isDisabled: false, renderAsOriginal: true, isVisible: true) { [weak self] in
                guard let self = self else {
                    return
                }
                self.dismissBanner()
        }
        self.dismissButtonViewModel.update(accessibilityLabel: "Dismiss Banner")
        self.dismissButtonViewModel.update(accessibilityHint: "Dismisses this notification")
    }

    func update(callingState: CallingState, visibilityState: VisibilityState) {
        let recordingState = callingState.recordingStatus
        let transcriptionState = callingState.transcriptionStatus

        var toDisplayBanner = true
        switch(recordingState, transcriptionState) {
        case (.on, .on):
            bannerTextViewModel.update(bannerInfoType: .recordingAndTranscriptionStarted)
            bannerBackgroundColor = Color(UIColor.compositeColor(.green))
        case (.on, .off):
            bannerTextViewModel.update(bannerInfoType: .recordingStarted)
            bannerBackgroundColor = Color(UIColor.compositeColor(.green))
        case (.on, .stopped):
            bannerTextViewModel.update(bannerInfoType: .transcriptionStoppedStillRecording)
            bannerBackgroundColor = Color(UIColor.compositeColor(.green))
        case (.off, .on):
            bannerTextViewModel.update(bannerInfoType: .transcriptionStarted)
            bannerBackgroundColor = Color(UIColor.compositeColor(.green))
        case (.off, .off):
            bannerTextViewModel.update(bannerInfoType: nil)
            toDisplayBanner = false
        case (.off, .stopped):
            bannerTextViewModel.update(bannerInfoType: .transcriptionStoppedAndSaved)
            bannerBackgroundColor = Color(UIColor.compositeColor(.errorColor))
        case (.stopped, .on):
            bannerTextViewModel.update(bannerInfoType: .recordingStoppedStillTranscribing)
            bannerBackgroundColor = Color(UIColor.compositeColor(.errorColor))
        case (.stopped, .off):
            bannerTextViewModel.update(bannerInfoType: .recordingStopped)
            bannerBackgroundColor = Color(UIColor.compositeColor(.errorColor))
        case (.stopped, .stopped):
            bannerTextViewModel.update(bannerInfoType: .recordingAndTranscriptionStopped)
            bannerBackgroundColor = Color(UIColor.compositeColor(.errorColor))
        }
        isBannerDisplayed = toDisplayBanner
        && !callingState.isRecorcingTranscriptionBannedDismissed
        && visibilityState.currentStatus == VisibilityStatus.visible
    }

    private func dismissBanner() {
        dispatch(.callingAction(.dismissRecordingTranscriptionBannedUpdated(isDismissed: true)))
    }
}
