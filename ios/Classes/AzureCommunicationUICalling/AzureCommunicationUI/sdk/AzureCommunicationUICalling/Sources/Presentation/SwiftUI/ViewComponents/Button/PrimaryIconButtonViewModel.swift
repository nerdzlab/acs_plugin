//
//  IconWithLabelButtonViewModel 2.swift
//  Pods
//
//  Created by Yriy Malyts on 08.04.2025.
//


//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine

class PrimaryIconButtonViewModel<T: PrimaryButtonState>: ObservableObject {
    @Published var selectedButtonState: T
    @Published var localizationProvider: LocalizationProviderProtocol
    @Published var iconName: CompositeIcon
    @Published var accessibilityLabel: String?
    @Published var accessibilityValue: String?
    @Published var accessibilityHint: String?
    @Published var isDisabled: Bool
    @Published var isVisible: Bool
    var action: (() -> Void)
    
    init(selectedButtonState: T,
         localizationProvider: LocalizationProviderProtocol,
         isDisabled: Bool = false,
         isVisible: Bool = true,
         action: @escaping (() -> Void) = {}) {
        self.selectedButtonState = selectedButtonState
        self.localizationProvider = localizationProvider
        self.iconName = selectedButtonState.iconName
        self.isDisabled = isDisabled
        self.isVisible = isVisible
        self.action = action
    }
    
    func update(selectedButtonState: T) {
        self.selectedButtonState = selectedButtonState
        self.iconName = selectedButtonState.iconName
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
}
