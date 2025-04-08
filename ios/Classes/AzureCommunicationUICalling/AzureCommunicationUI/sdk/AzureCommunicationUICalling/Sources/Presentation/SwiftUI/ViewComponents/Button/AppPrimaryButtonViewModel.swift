//
//  PrimaryButtonViewModel 2.swift
//  Pods
//
//  Created by Yriy Malyts on 08.04.2025.
//


import Foundation
import FluentUI
import Combine

class AppPrimaryButtonViewModel: ObservableObject {
    @Published var isDisabled: Bool
    @Published var accessibilityLabel: String?
    let buttonStyle: AppCompositeButton.ButtonStyleType
    let buttonLabel: String
    let iconName: CompositeIcon?
    let paddings: AppCompositeButton.Paddings?
    let themeOptions: ThemeOptions
    var action: (() -> Void)

    init(buttonStyle: AppCompositeButton.ButtonStyleType,
         buttonLabel: String,
         iconName: CompositeIcon? = nil,
         isDisabled: Bool = false,
         paddings: AppCompositeButton.Paddings? = nil,
         themeOptions: ThemeOptions,
         action: @escaping (() -> Void) = {}) {
        self.buttonStyle = buttonStyle
        self.buttonLabel = buttonLabel
        self.iconName = iconName
        self.isDisabled = isDisabled
        self.action = action
        self.paddings = paddings
        self.themeOptions = themeOptions
    }

    func update(isDisabled: Bool) {
        if self.isDisabled != isDisabled {
            self.isDisabled = isDisabled
        }
    }

    func update(accessibilityLabel: String?) {
        if self.accessibilityLabel != accessibilityLabel {
            self.accessibilityLabel = accessibilityLabel
        }
    }
}
