//
//  MeetingOptionsViewModel.swift
//  Pods
//
//  Created by Yriy Malyts on 16.04.2025.
//
import SwiftUI
import SwiftUICore

internal class MeetingOptionsViewModel: ObservableObject {
    private let localizationProvider: LocalizationProviderProtocol
    private let onShareScreen: () -> Void
    private let onStopShareScreen: () -> Void
    private let onChat: () -> Void
    private let onParticipants: () -> Void
    private let onRaiseHand: () -> Void
    private let onLowerHand: () -> Void
    private let onEffects: () -> Void
    private let onLayoutOptions: () -> Void
    
    private(set) var chatButtonViewModel: IconWithLabelButtonViewModel<ChatButtonState>!
    private(set) var participantsButtonViewModel: IconWithLabelButtonViewModel<ParticipantsButtonState>!
    private(set) var effectsButtonViewModel: IconWithLabelButtonViewModel<EffectsButtonState>!
    
    @Published private(set) var raiseHandButtonViewModel: IconWithLabelButtonViewModel<RaiseHandButtonState>!
    @Published private(set) var shareScreenViewModel: IconWithLabelButtonViewModel<ShareScreenButtonState>!
    @Published private(set) var layoutOptionsButtonViewModel: IconWithLabelButtonViewModel<LayoutOptionsButtonState>!
    
    var isDisplayed: Bool
    
    init(
        localUserState: LocalUserState,
        localizationProvider: LocalizationProviderProtocol,
        onShareScreen: @escaping () -> Void,
        onStopShareScreen: @escaping () -> Void,
        onChat: @escaping () -> Void,
        onParticipants: @escaping () -> Void,
        onRaiseHand: @escaping () -> Void,
        onLowerHand: @escaping () -> Void,
        onEffects: @escaping () -> Void,
        onLayoutOptions: @escaping () -> Void,
        isDisplayed: Bool
    ) {
        self.localizationProvider = localizationProvider
        self.isDisplayed = false
        self.onShareScreen = onShareScreen
        self.onStopShareScreen = onStopShareScreen
        self.onChat = onChat
        self.onParticipants = onParticipants
        self.onRaiseHand = onRaiseHand
        self.onLowerHand = onLowerHand
        self.onEffects = onEffects
        self.onLayoutOptions = onLayoutOptions
        
        raiseHandButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: localUserState.raiseHandState.operation == .handIsLower ? RaiseHandButtonState.raiseHand : RaiseHandButtonState.lowerHand,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: localUserState.cameraState.operation == .off,
            isVisible: true,
            action: { [weak self] in
                if localUserState.raiseHandState.operation == .handIsLower {
                    self?.onRaiseHand()
                } else {
                    self?.onLowerHand()
                }
            })
        
        shareScreenViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: localUserState.shareScreenState.operation == .screenIsSharing ? ShareScreenButtonState.shareOn : ShareScreenButtonState.shareOff,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                if localUserState.shareScreenState.operation == .screenIsSharing {
                    self?.onStopShareScreen()
                } else {
                    self?.onShareScreen()
                }
            })
        
        layoutOptionsButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: localUserState.meetingLayoutState.operation == .speaker ? LayoutOptionsButtonState.speakerLayout : LayoutOptionsButtonState.gridLayout,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onLayoutOptions()
            })
        
        chatButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: ChatButtonState.default,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onChat()
            })
        
        participantsButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: ParticipantsButtonState.default,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onParticipants()
            })
        
        effectsButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: EffectsButtonState.default,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onEffects()
            })
    }
    
    func update(localUserState: LocalUserState, isDisplayed: Bool) {
        self.isDisplayed = isDisplayed
        
        let previousState = raiseHandButtonViewModel.selectedButtonState
        let operation = localUserState.raiseHandState.operation
        let error = localUserState.raiseHandState.error
        let selectedState: RaiseHandButtonState

        if error != nil || operation == .panding {
            selectedState = previousState
        } else {
            selectedState = (operation == .handIsLower ? .raiseHand : .lowerHand)
        }
                
        raiseHandButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: selectedState,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: localUserState.cameraState.operation == .off,
            isVisible: true,
            action: { [weak self] in
                if operation == .handIsLower {
                    self?.onRaiseHand()
                } else {
                    self?.onLowerHand()
                }
            })
        
        shareScreenViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: localUserState.shareScreenState.operation == .screenIsSharing ? ShareScreenButtonState.shareOn : ShareScreenButtonState.shareOff,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                if localUserState.shareScreenState.operation == .screenIsSharing {
                    self?.onStopShareScreen()
                } else {
                    self?.onShareScreen()
                }
            })
        
        layoutOptionsButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: localUserState.meetingLayoutState.operation == .speaker ? LayoutOptionsButtonState.speakerLayout : LayoutOptionsButtonState.gridLayout,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onLayoutOptions()
            })
        
        chatButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: ChatButtonState.default,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onChat()
            })
        
        participantsButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: ParticipantsButtonState.default,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onParticipants()
            })
        
        effectsButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: EffectsButtonState.default,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: false,
            isVisible: true,
            action: { [weak self] in
                self?.onEffects()
            })
    }
    
//    private func get(localUserState: LocalUserState) -> RaiseHandButtonState {
//        switch localUserState.raiseHandState.operation {
//        case .panding
//        }
//        localUserState.raiseHandState.operation == .handIsLower ? RaiseHandButtonState.raiseHand : RaiseHandButtonState.lowerHand,
//    }
}
