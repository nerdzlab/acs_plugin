//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import Foundation
import SwiftUI

protocol CompositeViewModelFactoryProtocol {
    // MARK: CompositeViewModels
    func getSetupViewModel() -> SetupViewModel
    func getCallingViewModel(rendererViewManager: RendererViewManager) -> CallingViewModel
    // MARK: ComponentViewModels
    func makeIconButtonViewModel(iconName: CompositeIcon,
                                 buttonType: IconButtonViewModel.ButtonType,
                                 isDisabled: Bool,
                                 renderAsOriginal: Bool,
                                 isVisible: Bool,
                                 action: @escaping (() -> Void)) -> IconButtonViewModel
    /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
    func makeIconButtonViewModel(icon: UIImage,
                                 buttonType: IconButtonViewModel.ButtonType,
                                 isDisabled: Bool,
                                 isVisible: Bool,
                                 action: @escaping (() -> Void)) -> IconButtonViewModel
    /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
    func makeIconWithLabelButtonViewModel<ButtonStateType>(
        selectedButtonState: ButtonStateType,
        localizationProvider: LocalizationProviderProtocol,
        buttonColor: Color,
        isDisabled: Bool,
        action: @escaping (() -> Void)) -> IconWithLabelButtonViewModel<ButtonStateType>
    
    func makePrimaryIconButtonViewModel<ButtonStateType>(
        selectedButtonState: ButtonStateType,
        localizationProvider: LocalizationProviderProtocol,
        isDisabled: Bool,
        action: @escaping (() -> Void)) -> PrimaryIconButtonViewModel<ButtonStateType>
    
    func makeLocalVideoViewModel(dispatchAction: @escaping ActionDispatch, isPreviewEnable: Bool) -> LocalVideoViewModel
    func makePrimaryButtonViewModel(buttonStyle: FluentUI.ButtonStyle,
                                    buttonLabel: String,
                                    iconName: CompositeIcon?,
                                    isDisabled: Bool,
                                    paddings: CompositeButton.Paddings?,
                                    action: @escaping (() -> Void)) -> PrimaryButtonViewModel
    func makeAudioDevicesListViewModel(dispatchAction: @escaping ActionDispatch,
                                       localUserState: LocalUserState,
                                       isPreviewSettings: Bool) -> AudioDevicesListViewModel
    func makeCaptionsLanguageListViewModel (dispatchAction: @escaping ActionDispatch,
                                            state: AppState) -> CaptionsLanguageListViewModel
    func makeCaptionsInfoViewModel (state: AppState) -> CaptionsInfoViewModel
    func makeCaptionsErrorViewModel (dispatchAction: @escaping ActionDispatch) -> CaptionsErrorViewModel
    func makeErrorInfoViewModel(title: String,
                                subtitle: String) -> ErrorInfoViewModel
    // MARK: CallingViewModels
    func makeLobbyOverlayViewModel() -> LobbyOverlayViewModel
    func makeLoadingOverlayViewModel() -> LoadingOverlayViewModel
    func makeOnHoldOverlayViewModel(resumeAction: @escaping (() -> Void)) -> OnHoldOverlayViewModel
    func makeControlBarViewModel(dispatchAction: @escaping ActionDispatch,
                                 onEndCallTapped: @escaping (() -> Void),
                                 localUserState: LocalUserState,
                                 capabilitiesManager: CapabilitiesManager,
                                 buttonViewDataState: ButtonViewDataState) -> ControlBarViewModel
    func makeInfoHeaderViewModel(dispatchAction: @escaping ActionDispatch,
                                 localUserState: LocalUserState,
                                 callScreenInfoHeaderState: CallScreenInfoHeaderState,
                                 isChatEnable: Bool,
                                 /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
                                 buttonViewDataState: ButtonViewDataState,
                                 controlHeaderViewData: CallScreenHeaderViewData?
                                 /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
    ) -> InfoHeaderViewModel
    func makeLobbyWaitingHeaderViewModel(localUserState: LocalUserState,
                                         dispatchAction: @escaping ActionDispatch) -> LobbyWaitingHeaderViewModel
    func makeLobbyActionErrorViewModel(localUserState: LocalUserState,
                                       dispatchAction: @escaping ActionDispatch) -> LobbyErrorHeaderViewModel
    func makeParticipantGridsViewModel(isIpadInterface: Bool, rendererViewManager: RendererViewManager) -> ParticipantGridViewModel
    
    func makeParticipantCellViewModel(participantModel: ParticipantInfoModel) -> ParticipantGridCellViewModel
    
    func makeParticipantsListViewModel(localUserState: LocalUserState,
                                       isDisplayed: Bool,
                                       showSharingViewAction: @escaping () -> Void,
                                       dispatchAction: @escaping ActionDispatch) -> ParticipantsListViewModel
    
    func makeParticipantOptionsViewModel(localUserState: LocalUserState,
                                         isDisplayed: Bool,
                                         dispatchAction: @escaping ActionDispatch,
                                         isPinEnable: Bool
    ) -> ParticipantOptionsViewModel
    
    func makeParticipantMenuViewModel(localUserState: LocalUserState,
                                      isDisplayed: Bool,
                                      dispatchAction: @escaping ActionDispatch) -> ParticipantMenuViewModel
    
    func makeMeetingOptionsViewModel(localUserState: LocalUserState,
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
                                     isRemoteParticipantsPresent: Bool,
                                     isDisplayed: Bool,
                                     isReactionEnable: Bool,
                                     isRaiseHandAvailable: Bool,
                                     isLayoutOptionsEnable: Bool,
                                     isChatEnable: Bool
    ) -> MeetingOptionsViewModel
    
    func makeLayoutOptionsViewModel(
        localUserState: LocalUserState,
        isDisplayed: Bool,
        onGridSelect: @escaping () -> Void,
        onSpeakerSelect: @escaping () -> Void
    ) -> LayoutOptionsViewModel
    
    func makeBannerViewModel(dispatchAction: @escaping ActionDispatch) -> BannerViewModel
    func makeBannerTextViewModel() -> BannerTextViewModel
    func makeMoreCallOptionsListViewModel(
        isCaptionsAvailable: Bool,
        controlBarOptions: CallScreenControlBarOptions?,
        showSharingViewAction: @escaping () -> Void,
        showSupportFormAction: @escaping () -> Void,
        showCaptionsViewAction: @escaping () -> Void,
        buttonViewDataState: ButtonViewDataState,
        dispatchAction: @escaping ActionDispatch) -> MoreCallOptionsListViewModel
    
    func makeCaptionsListViewModel(state: AppState,
                                   captionsOptions: CaptionsOptions,
                                   dispatchAction: @escaping ActionDispatch,
                                   showSpokenLanguage: @escaping () -> Void,
                                   showCaptionsLanguage: @escaping () -> Void,
                                   isDisplayed: Bool) -> CaptionsListViewModel
    
    func makeDebugInfoSharingActivityViewModel() -> DebugInfoSharingActivityViewModel
    
    func makeShareMeetingInfoActivityViewModel() -> ShareMeetingInfoActivityViewModel
    
    func makeToggleListItemViewModel(title: String,
                                     isToggleOn: Binding<Bool>,
                                     showToggle: Bool,
                                     accessibilityIdentifier: String,
                                     startIcon: CompositeIcon,
                                     isEnabled: Bool,
                                     action: @escaping (() -> Void)) -> DrawerGenericItemViewModel
    
    func makeLanguageListItemViewModel(title: String,
                                       subtitle: String?,
                                       accessibilityIdentifier: String,
                                       startIcon: CompositeIcon,
                                       endIcon: CompositeIcon?,
                                       isEnabled: Bool,
                                       action: @escaping (() -> Void)) -> DrawerGenericItemViewModel
    func makeCaptionsLangaugeCellViewModel(title: String,
                                           isSelected: Bool,
                                           accessibilityLabel: String,
                                           onSelectedAction: @escaping (() -> Void)) -> DrawerSelectableItemViewModel
    func makeLeaveCallConfirmationViewModel(
        endCall: @escaping (() -> Void),
        dismissConfirmation: @escaping (() -> Void)) -> LeaveCallConfirmationViewModel
    
    func makeSupportFormViewModel() -> SupportFormViewModel
    func makeCallDiagnosticsViewModel(dispatchAction: @escaping ActionDispatch) -> CallDiagnosticsViewModel
    func makeBottomToastViewModel(toastNotificationState: ToastNotificationState,
                                  dispatchAction: @escaping ActionDispatch) -> BottomToastViewModel
    // MARK: SetupViewModels
    func makePreviewAreaViewModel(dispatchAction: @escaping ActionDispatch) -> PreviewAreaViewModel
    func makeSetupControlBarViewModel(dispatchAction: @escaping ActionDispatch,
                                      localUserState: LocalUserState,
                                      buttonViewDataState: ButtonViewDataState) -> SetupControlBarViewModel
    func makeJoiningCallActivityViewModel(title: String) -> JoiningCallActivityViewModel
    
    func makeAppPrimaryButtonViewModel(buttonStyle: AppCompositeButton.ButtonStyleType,
                                       buttonLabel: String,
                                       iconName: CompositeIcon?,
                                       isDisabled: Bool,
                                       paddings: AppCompositeButton.Paddings?,
                                       action: @escaping (() -> Void)) -> AppPrimaryButtonViewModel
    func userTriggerEndCall()
}

extension CompositeViewModelFactoryProtocol {
    func makePrimaryButtonViewModel(buttonStyle: FluentUI.ButtonStyle,
                                    buttonLabel: String,
                                    iconName: CompositeIcon? = CompositeIcon.none,
                                    isDisabled: Bool = false,
                                    action: @escaping (() -> Void)) -> PrimaryButtonViewModel {
        return makePrimaryButtonViewModel(buttonStyle: buttonStyle,
                                          buttonLabel: buttonLabel,
                                          iconName: iconName,
                                          isDisabled: isDisabled,
                                          paddings: nil,
                                          action: action)
    }
    
    func makeAppPrimaryButtonViewModel(buttonStyle: AppCompositeButton.ButtonStyleType,
                                       buttonLabel: String,
                                       iconName: CompositeIcon? = CompositeIcon.none,
                                       isDisabled: Bool,
                                       action: @escaping (() -> Void)) -> AppPrimaryButtonViewModel {
        return makeAppPrimaryButtonViewModel(buttonStyle: buttonStyle,
                                             buttonLabel: buttonLabel,
                                             iconName: iconName,
                                             isDisabled: isDisabled,
                                             paddings: nil,
                                             action: action)
    }
    
    func makeJoiningCallActivityViewModel(title: String) -> JoiningCallActivityViewModel {
        return JoiningCallActivityViewModel(title: title)
    }
}
