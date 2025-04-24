//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine
import SwiftUI

class IconWithLabelButtonViewModel<T: ButtonState>: ObservableObject {
    @Published var selectedButtonState: T
    @Published var localizationProvider: LocalizationProviderProtocol
    @Published var iconName: CompositeIcon
    @Published var buttonColor: Color
    @Published var buttonLabel: String?
    @Published var accessibilityLabel: String?
    @Published var accessibilityValue: String?
    @Published var accessibilityHint: String?
    @Published var isDisabled: Bool
    @Published var isVisible: Bool
    var action: (() -> Void)

    init(selectedButtonState: T,
         localizationProvider: LocalizationProviderProtocol,
         buttonColor: Color,
         isDisabled: Bool = false,
         isVisible: Bool = true,
         action: @escaping (() -> Void) = {}) {
        self.selectedButtonState = selectedButtonState
        self.localizationProvider = localizationProvider
        self.iconName = selectedButtonState.iconName
        self.buttonColor = buttonColor
        self.buttonLabel = localizationProvider.getLocalizedString(selectedButtonState.localizationKey)
        self.isDisabled = isDisabled
        self.isVisible = isVisible
        self.action = action
    }

    func update(selectedButtonState: T) {
        if self.selectedButtonState.localizationKey != selectedButtonState.localizationKey {
            self.selectedButtonState = selectedButtonState
            self.buttonLabel = localizationProvider.getLocalizedString(selectedButtonState.localizationKey)
            self.iconName = selectedButtonState.iconName
        }
    }

    func update(accessibilityLabel: String) {
        if self.accessibilityLabel != accessibilityLabel {
            self.accessibilityLabel = accessibilityLabel
        }
    }

    func update(accessibilityValue: String) {
        if self.accessibilityValue != accessibilityValue {
            self.accessibilityValue = accessibilityValue
        }
    }

    func update(accessibilityHint: String) {
        if self.accessibilityHint != accessibilityHint {
            self.accessibilityHint = accessibilityHint
        }
    }

    func update(isDisabled: Bool) {
        if self.isDisabled != isDisabled {
            self.isDisabled = isDisabled
        }
    }

    func update(buttonColor: Color) {
        if self.buttonColor != buttonColor {
            self.buttonColor = buttonColor
        }
    }
}
