//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine

class ErrorInfoViewModel: ObservableObject {
    @Published private(set) var isDisplayed = false
    @Published private(set) var title: String
    @Published private(set) var subtitle: String

    private let localizationProvider: LocalizationProviderProtocol
    private var previousErrorType: CallCompositeInternalError?

    init(localizationProvider: LocalizationProviderProtocol,
         title: String = "",
         subtitle: String = "") {
        self.localizationProvider = localizationProvider
        self.title = title
        self.subtitle = subtitle
    }

    var dismissContent: String {
        localizationProvider.getLocalizedString(.snackBarDismiss)
    }
    var dismissAccessibilitylabel: String {
        localizationProvider.getLocalizedString(.snackBarDismissAccessibilityLabel)
    }
    var dismissAccessibilityHint: String {
        localizationProvider.getLocalizedString(.snackBarDismissAccessibilityHint)
    }

    func dismiss() {
        isDisplayed = false
    }

    func show() {
        isDisplayed = true
    }

    func update(errorState: ErrorState) {
        let errorType = errorState.internalError

        if  errorType == .captionsNotActive ||
                errorType == .captionsStartFailedCallNotConnected ||
                errorType == .captionsStartFailedSpokenLanguageNotSupported {
            return
        }
        guard let errorType = errorType else {
            // if no error, hide banner
            isDisplayed = false
            return
        }

        guard errorType != previousErrorType else {
            // if new error is the same as the previous one
            // do nothing
            return
        }

        previousErrorType = errorType

        isDisplayed = true
        switch errorType {
        case .callJoinFailed:
            title = localizationProvider.getLocalizedString(.snackBarErrorJoinCall)
        case .callEndFailed:
            title = localizationProvider.getLocalizedString(.snackBarErrorCallEnd)
        case .callEvicted:
            title = localizationProvider.getLocalizedString(.snackBarErrorCallEvicted)
        case .callDenied:
            title = localizationProvider.getLocalizedString(.snackBarErrorCallDenied)
        case .cameraOnFailed:
            title = localizationProvider.getLocalizedString(.snackBarErrorCameraOnFailed)
        case .callJoinConnectionFailed:
            title = localizationProvider.getLocalizedString(.snackBarErrorConnectionError)
        case .micNotAvailable:
            title = localizationProvider.getLocalizedString(.snackBarErrorOnHoldTitle) + "\n" +
            localizationProvider.getLocalizedString(.snackBarErrorOnHoldSubtitle) + "."
        case .raiseHandFailed:
            //MTODO
            title = "Error during raise hand"
//            title = localizationProvider.getLocalizedString() + "\n" +
        case .lowerHandFailed:
            title = "Error during lower hand"
        case .setVideoEffectFailed:
            title = "Set video effect failed"
        default:
            title = localizationProvider.getLocalizedString(.snackBarError)
        }
    }
}
