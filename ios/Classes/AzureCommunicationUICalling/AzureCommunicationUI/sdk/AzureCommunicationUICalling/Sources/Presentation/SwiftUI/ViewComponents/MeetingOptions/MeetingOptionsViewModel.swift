//
//  MeetingOptionsViewModel.swift
//  Pods
//
//  Created by Yriy Malyts on 16.04.2025.
//
import SwiftUI
import SwiftUI

internal class MeetingOptionsViewModel: ObservableObject {
    private let localizationProvider: LocalizationProviderProtocol
    private let onShareScreen: () -> Void
    private let onStopShareScreen: () -> Void
    private let onChat: () -> Void
    private let onParticipants: () -> Void
    private let onRaiseHand: () -> Void
    private let onLowerHand: () -> Void
    private let onEffects: (LocalUserState.BackgroundEffectType) -> Void
    private let onLayoutOptions: () -> Void
    private let onReaction: (ReactionType) -> Void
    
    private(set) var chatButtonViewModel: IconWithLabelButtonViewModel<ChatButtonState>!
    private(set) var participantsButtonViewModel: IconWithLabelButtonViewModel<ParticipantsButtonState>!
    private(set) var effectsButtonViewModel: IconWithLabelButtonViewModel<EffectsButtonState>!
    
    private var isRemoteParticipantsPresent: Bool
    
    @Published private(set) var raiseHandButtonViewModel: IconWithLabelButtonViewModel<RaiseHandButtonState>!
    @Published private(set) var shareScreenViewModel: IconWithLabelButtonViewModel<ShareScreenButtonState>!
    @Published private(set) var layoutOptionsButtonViewModel: IconWithLabelButtonViewModel<LayoutOptionsButtonState>!
    
    let isReactionEnable: Bool
    var isDisplayed: Bool
    var isLayoutOptionsEnable: Bool
    
    init(
        localUserState: LocalUserState,
        localizationProvider: LocalizationProviderProtocol,
        onShareScreen: @escaping () -> Void,
        onStopShareScreen: @escaping () -> Void,
        onChat: @escaping () -> Void,
        onParticipants: @escaping () -> Void,
        onRaiseHand: @escaping () -> Void,
        onLowerHand: @escaping () -> Void,
        onEffects: @escaping (LocalUserState.BackgroundEffectType) -> Void,
        onLayoutOptions: @escaping () -> Void,
        onReaction: @escaping (ReactionType) -> Void,
        isDisplayed: Bool,
        isRemoteParticipantsPresent: Bool,
        isReactionEnable: Bool,
        isRaiseHandAvailable: Bool,
        isLayoutOptionsEnable: Bool
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
        self.onReaction = onReaction
        self.isRemoteParticipantsPresent = isRemoteParticipantsPresent
        self.isReactionEnable = isReactionEnable
        self.isLayoutOptionsEnable = isLayoutOptionsEnable
        
        raiseHandButtonViewModel = IconWithLabelButtonViewModel(
            selectedButtonState: localUserState.raiseHandState.operation == .handIsLower ? RaiseHandButtonState.raiseHand : RaiseHandButtonState.lowerHand,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: !isRaiseHandAvailable,
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
            isDisabled: !isRemoteParticipantsPresent,
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
            isDisabled: !isLayoutOptionsEnable,
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
            selectedButtonState: localUserState.backgroundEffectsState.operation == .off ? EffectsButtonState.off : EffectsButtonState.on,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: localUserState.cameraState.operation != .on,
            isVisible: true,
            action: { [weak self] in
                if (localUserState.backgroundEffectsState.operation == .off) {
                    self?.onEffects(LocalUserState.BackgroundEffectType.blur)
                } else {
                    self?.onEffects(LocalUserState.BackgroundEffectType.none)
                }
            })
    }
    
    func update(localUserState: LocalUserState, isDisplayed: Bool, isRemoteParticipantsPresent: Bool, isRaiseHandAvailable: Bool, isLayoutOptionsEnable: Bool) {
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
            isDisabled: !isRaiseHandAvailable,
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
            isDisabled: !isRemoteParticipantsPresent,
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
            isDisabled: !isLayoutOptionsEnable,
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
            selectedButtonState: localUserState.backgroundEffectsState.operation == .off ? EffectsButtonState.off : EffectsButtonState.on,
            localizationProvider: localizationProvider,
            buttonColor: Color(UIColor.compositeColor(.purpleBlue)),
            isDisabled: localUserState.cameraState.operation != .on,
            isVisible: true,
            action: { [weak self] in
                if (localUserState.backgroundEffectsState.operation == .off) {
                    self?.onEffects(LocalUserState.BackgroundEffectType.blur)
                } else {
                    self?.onEffects(LocalUserState.BackgroundEffectType.none)
                }
            })
    }
    
    func sendReaction(_ reaction: ReactionType) {
        onReaction(reaction)
    }
}
