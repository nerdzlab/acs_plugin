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
    
    private let onDismiss: () -> Void
    
    private(set) var dismissButtonViewModel: IconButtonViewModel!
    
    @Published private(set) var selectedEffect: LocalUserState.BackgroundEffectType
    
    let effects = LocalUserState.BackgroundEffectType.allCases
    var isDisplayed: Bool
    
    init(
        localUserState: LocalUserState,
        localizationProvider: LocalizationProviderProtocol,
        onDismiss: @escaping () -> Void,
        onEffects: @escaping (LocalUserState.BackgroundEffectType) -> Void,
        isDisplayed: Bool
    ) {
        self.localizationProvider = localizationProvider
        self.onDismiss = onDismiss
        self.isDisplayed = false
        self.onEffects = onEffects
        self.title = localizationProvider.getLocalizedString(.effectsTitle)
        self.selectedEffect = localUserState.backgroundEffectsState.effect
        
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
        
//        let previousState = raiseHandButtonViewModel.selectedButtonState
//        let operation = localUserState.raiseHandState.operation
//        let error = localUserState.raiseHandState.error
//        let selectedState: RaiseHandButtonState
//
//        if error != nil || operation == .panding {
//            selectedState = previousState
//        } else {
//            selectedState = (operation == .handIsLower ? .raiseHand : .lowerHand)
//        }
//                
//        raiseHandButtonViewModel = IconWithLabelButtonViewModel(
//            selectedButtonState: selectedState,
//            localizationProvider: localizationProvider,
//            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
//            isVisible: true,
//            action: { [weak self] in
//                if operation == .handIsLower {
//                    self?.onRaiseHand()
//                } else {
//                    self?.onLowerHand()
//                }
//            })
//        
//        shareScreenViewModel = IconWithLabelButtonViewModel(
//            selectedButtonState: localUserState.shareScreenState.operation == .screenIsSharing ? ShareScreenButtonState.shareOn : ShareScreenButtonState.shareOff,
//            localizationProvider: localizationProvider,
//            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
//            isDisabled: false,
//            isVisible: true,
//            action: { [weak self] in
//                if localUserState.shareScreenState.operation == .screenIsSharing {
//                    self?.onStopShareScreen()
//                } else {
//                    self?.onShareScreen()
//                }
//            })
//        
//        layoutOptionsButtonViewModel = IconWithLabelButtonViewModel(
//            selectedButtonState: localUserState.meetingLayoutState.operation == .speaker ? LayoutOptionsButtonState.speakerLayout : LayoutOptionsButtonState.gridLayout,
//            localizationProvider: localizationProvider,
//            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
//            isDisabled: false,
//            isVisible: true,
//            action: { [weak self] in
//                self?.onLayoutOptions()
//            })
//        
//        chatButtonViewModel = IconWithLabelButtonViewModel(
//            selectedButtonState: ChatButtonState.default,
//            localizationProvider: localizationProvider,
//            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
//            isDisabled: false,
//            isVisible: true,
//            action: { [weak self] in
//                self?.onChat()
//            })
//        
//        participantsButtonViewModel = IconWithLabelButtonViewModel(
//            selectedButtonState: ParticipantsButtonState.default,
//            localizationProvider: localizationProvider,
//            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
//            isDisabled: false,
//            isVisible: true,
//            action: { [weak self] in
//                self?.onParticipants()
//            })
//        
//        effectsButtonViewModel = IconWithLabelButtonViewModel(
//            selectedButtonState: EffectsButtonState.default,
//            localizationProvider: localizationProvider,
//            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
//            isDisabled: false,
//            isVisible: true,
//            action: { [weak self] in
//                self?.onEffects()
//            })
    }
}
