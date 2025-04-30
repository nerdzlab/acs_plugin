//
//  EffectsPickerView.swift
//  Pods
//
//  Created by Yriy Malyts on 18.04.2025.
//

import SwiftUI
import SwiftUICore

public class EffectsPickerViewModel: ObservableObject {
    private let localizationProvider: LocalizationProviderProtocol
    
    let title: String
    let onEffects: (LocalUserState.BackgroundEffectType) -> Void
    let videoEffectsPreviewViewModel: VideoEffectsPreviewViewModel
    
    private let onDismiss: () -> Void
    
    private(set) var dismissButtonViewModel: IconButtonViewModel!
    
    @Published private(set) var selectedEffect: LocalUserState.BackgroundEffectType
    
    let effects = LocalUserState.BackgroundEffectType.allCases
    var isDisplayed: Bool
    
    init(
        localUserState: LocalUserState,
        localizationProvider: LocalizationProviderProtocol,
        videoEffectsPreviewViewModel: VideoEffectsPreviewViewModel,
        onDismiss: @escaping () -> Void,
        onEffects: @escaping (LocalUserState.BackgroundEffectType) -> Void,
        isDisplayed: Bool
    ) {
        self.localizationProvider = localizationProvider
        self.onDismiss = onDismiss
        self.isDisplayed = false
        self.onEffects = onEffects
        self.title = localizationProvider.getLocalizedString(.onHold)
        self.selectedEffect = localUserState.backgroundEffectsState.effect
        self.videoEffectsPreviewViewModel = videoEffectsPreviewViewModel
        
        dismissButtonViewModel = IconButtonViewModel(
            iconName: .closeEffects,
            buttonType: .closeButton,
            isDisabled: false,
            isVisible: true,
            renderAsOriginal: true,
            action: { [weak self] in
                self?.onDismiss()
            })
    }
    
    func update(localUserState: LocalUserState, isDisplayed: Bool) {
        self.isDisplayed = isDisplayed
        self.selectedEffect = localUserState.backgroundEffectsState.effect
    }
}
