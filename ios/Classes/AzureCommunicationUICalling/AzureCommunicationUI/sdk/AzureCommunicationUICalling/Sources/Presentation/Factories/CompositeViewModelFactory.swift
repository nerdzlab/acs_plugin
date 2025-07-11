//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import FluentUI
import Foundation
import SwiftUI

// swiftlint:disable file_length
class CompositeViewModelFactory: CompositeViewModelFactoryProtocol {
    private let logger: Logger
    private let store: Store<AppState, Action>
    private let networkManager: NetworkManager
    private let audioSessionManager: AudioSessionManagerProtocol
    private let accessibilityProvider: AccessibilityProviderProtocol
    private let localizationProvider: LocalizationProviderProtocol
    private let debugInfoManager: DebugInfoManagerProtocol
    private let captionsViewManager: CaptionsViewManager
    private let events: CallComposite.Events
    private let localOptions: LocalOptions?
    private let enableMultitasking: Bool
    private let enableSystemPipWhenMultitasking: Bool
    private let capabilitiesManager: CapabilitiesManager
    private let avatarManager: AvatarViewManagerProtocol
    private let retrieveLogFiles: () -> [URL]
    private weak var setupViewModel: SetupViewModel?
    private weak var callingViewModel: CallingViewModel?
    private let setupScreenOptions: SetupScreenOptions?
    private let callScreenOptions: CallScreenOptions?
    private let callType: CompositeCallType
    private let callConfiguration: CallConfiguration
    /* <CUSTOM_COLOR_FEATURE> */
    private let themeOptions: ThemeOptions
    /* </CUSTOM_COLOR_FEATURE> */
    private let updatableOptionsManager: UpdatableOptionsManagerProtocol
    
    init(logger: Logger,
         store: Store<AppState, Action>,
         networkManager: NetworkManager,
         audioSessionManager: AudioSessionManagerProtocol,
         localizationProvider: LocalizationProviderProtocol,
         accessibilityProvider: AccessibilityProviderProtocol,
         debugInfoManager: DebugInfoManagerProtocol,
         captionsViewManager: CaptionsViewManager,
         localOptions: LocalOptions? = nil,
         enableMultitasking: Bool,
         enableSystemPipWhenMultitasking: Bool,
         eventsHandler: CallComposite.Events,
         leaveCallConfirmationMode: LeaveCallConfirmationMode,
         callType: CompositeCallType,
         setupScreenOptions: SetupScreenOptions?,
         callScreenOptions: CallScreenOptions?,
         capabilitiesManager: CapabilitiesManager,
         avatarManager: AvatarViewManagerProtocol,
         /* <CUSTOM_COLOR_FEATURE> */
         themeOptions: ThemeOptions,
         /* </CUSTOM_COLOR_FEATURE> */
         updatableOptionsManager: UpdatableOptionsManagerProtocol,
         callConfiguration: CallConfiguration,
         retrieveLogFiles: @escaping () -> [URL]
    ) {
        self.logger = logger
        self.store = store
        self.networkManager = networkManager
        self.audioSessionManager = audioSessionManager
        self.accessibilityProvider = accessibilityProvider
        self.localizationProvider = localizationProvider
        self.debugInfoManager = debugInfoManager
        self.captionsViewManager = captionsViewManager
        self.events = eventsHandler
        self.localOptions = localOptions
        self.enableMultitasking = enableMultitasking
        self.enableSystemPipWhenMultitasking = enableSystemPipWhenMultitasking
        self.retrieveLogFiles = retrieveLogFiles
        self.setupScreenOptions = setupScreenOptions
        self.callScreenOptions = callScreenOptions
        self.capabilitiesManager = capabilitiesManager
        self.callType = callType
        /* <CUSTOM_COLOR_FEATURE> */
        self.themeOptions = themeOptions
        /* </CUSTOM_COLOR_FEATURE> */
        self.avatarManager = avatarManager
        self.callConfiguration = callConfiguration
        self.updatableOptionsManager = updatableOptionsManager
    }
    
    func makeLeaveCallConfirmationViewModel(
        endCall: @escaping (() -> Void),
        dismissConfirmation: @escaping (() -> Void)) -> LeaveCallConfirmationViewModel {
            return LeaveCallConfirmationViewModel(
                state: store.state,
                localizationProvider: localizationProvider,
                endCall: endCall,
                dismissConfirmation: dismissConfirmation)
        }
    
    func makeSupportFormViewModel() -> SupportFormViewModel {
        return SupportFormViewModel(
            isDisplayed: store.state.navigationState.supportFormVisible
            && store.state.visibilityState.currentStatus == .visible,
            dispatchAction: store.dispatch,
            events: events,
            localizationProvider: localizationProvider,
            getDebugInfo: { [self] in self.debugInfoManager.getDebugInfo() })
    }
    
    // MARK: CompositeViewModels
    func getSetupViewModel() -> SetupViewModel {
        guard let viewModel = self.setupViewModel else {
            let viewModel = SetupViewModel(compositeViewModelFactory: self,
                                           logger: logger,
                                           store: store,
                                           networkManager: networkManager,
                                           audioSessionManager: audioSessionManager,
                                           localizationProvider: localizationProvider,
                                           setupScreenViewData: localOptions?.setupScreenViewData,
                                           callType: callType)
            self.setupViewModel = viewModel
            self.callingViewModel = nil
            return viewModel
        }
        return viewModel
    }
    
    func getCallingViewModel(rendererViewManager: RendererViewManager) -> CallingViewModel {
        guard let viewModel = self.callingViewModel else {
            let viewModel = CallingViewModel(compositeViewModelFactory: self,
                                             store: store,
                                             localizationProvider: localizationProvider,
                                             accessibilityProvider: accessibilityProvider,
                                             isIpadInterface: UIDevice.current.userInterfaceIdiom == .pad,
                                             allowLocalCameraPreview: localOptions?.audioVideoMode
                                             != CallCompositeAudioVideoMode.audioOnly,
                                             callType: callType,
                                             captionsOptions: localOptions?.captionsOptions ?? CaptionsOptions(),
                                             capabilitiesManager: self.capabilitiesManager,
                                             callScreenOptions: callScreenOptions ?? CallScreenOptions(),
                                             rendererViewManager: rendererViewManager,
                                             isChatEnable: localOptions?.isChatEnabled ?? true,
                                             whiteBoardId: localOptions?.whiteBoardId,
                                             azureCorrelationId: localOptions?.azureCorrelationId)
            self.setupViewModel = nil
            self.callingViewModel = viewModel
            return viewModel
        }
        return viewModel
    }
    
    // MARK: ComponentViewModels
    func makeIconButtonViewModel(iconName: CompositeIcon,
                                 buttonType: IconButtonViewModel.ButtonType,
                                 isDisabled: Bool,
                                 renderAsOriginal: Bool,
                                 isVisible: Bool,
                                 action: @escaping (() -> Void)) -> IconButtonViewModel {
        IconButtonViewModel(iconName: iconName,
                            buttonType: buttonType,
                            isDisabled: isDisabled,
                            renderAsOriginal: renderAsOriginal,
                            action: action)
    }
    
    /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
    func makeIconButtonViewModel(icon: UIImage,
                                 buttonType: IconButtonViewModel.ButtonType = .controlButton,
                                 isDisabled: Bool,
                                 isVisible: Bool,
                                 action: @escaping (() -> Void)) -> IconButtonViewModel {
        IconButtonViewModel(icon: icon,
                            buttonType: buttonType,
                            isDisabled: isDisabled,
                            isVisible: isVisible,
                            action: action)
    }
    /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
    
    func makeIconWithLabelButtonViewModel<T: ButtonState>(
        selectedButtonState: T,
        localizationProvider: LocalizationProviderProtocol,
        buttonColor: Color,
        isDisabled: Bool,
        action: @escaping (() -> Void)) -> IconWithLabelButtonViewModel<T> {
            IconWithLabelButtonViewModel(
                selectedButtonState: selectedButtonState,
                localizationProvider: localizationProvider,
                buttonColor: buttonColor,
                isDisabled: isDisabled,
                action: action)
        }
    
    func makePrimaryIconButtonViewModel<T: PrimaryButtonState>(
        selectedButtonState: T,
        localizationProvider: LocalizationProviderProtocol,
        isDisabled: Bool,
        action: @escaping (() -> Void)) -> PrimaryIconButtonViewModel<T> {
            PrimaryIconButtonViewModel(
                selectedButtonState: selectedButtonState,
                localizationProvider: localizationProvider,
                isDisabled: isDisabled,
                action: action)
        }
    
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
    ) -> MeetingOptionsViewModel {
        MeetingOptionsViewModel(
            localUserState: localUserState,
            localizationProvider: localizationProvider,
            onShareScreen: onShareScreen,
            onStopShareScreen: onStopShareScreen,
            onChat: onChat,
            onParticipants: onParticipants,
            onRaiseHand: onRaiseHand,
            onLowerHand: onLowerHand,
            onEffects: onEffects,
            onLayoutOptions: onLayoutOptions,
            onReaction: onReaction,
            isDisplayed: isDisplayed,
            isRemoteParticipantsPresent: isRemoteParticipantsPresent,
            isReactionEnable: isReactionEnable,
            isRaiseHandAvailable: isRaiseHandAvailable,
            isLayoutOptionsEnable: isLayoutOptionsEnable,
            isChatEnable: isChatEnable
        )
    }
    
    func makeLocalVideoViewModel(dispatchAction: @escaping ActionDispatch, isPreviewEnable: Bool) -> LocalVideoViewModel {
        LocalVideoViewModel(compositeViewModelFactory: self,
                            logger: logger, isPreviewEnable: isPreviewEnable,
                            localizationProvider: localizationProvider,
                            dispatchAction: dispatchAction)
    }
    
    func makePrimaryButtonViewModel(buttonStyle: FluentUI.ButtonStyle,
                                    buttonLabel: String,
                                    iconName: CompositeIcon?,
                                    isDisabled: Bool = false,
                                    paddings: CompositeButton.Paddings? = nil,
                                    action: @escaping (() -> Void)) -> PrimaryButtonViewModel {
        PrimaryButtonViewModel(buttonStyle: buttonStyle,
                               buttonLabel: buttonLabel,
                               iconName: iconName,
                               isDisabled: isDisabled,
                               paddings: paddings,
                               themeOptions: themeOptions,
                               action: action)
    }
    
    func makeAppPrimaryButtonViewModel(buttonStyle: AppCompositeButton.ButtonStyleType,
                                       buttonLabel: String,
                                       iconName: CompositeIcon?,
                                       isDisabled: Bool,
                                       paddings: AppCompositeButton.Paddings? = nil,
                                       action: @escaping (() -> Void)) -> AppPrimaryButtonViewModel {
        AppPrimaryButtonViewModel(buttonStyle: buttonStyle,
                                  buttonLabel: buttonLabel,
                                  iconName: iconName,
                                  isDisabled: isDisabled,
                                  paddings: paddings,
                                  themeOptions: themeOptions,
                                  action: action)
    }
    
    func makeAudioDevicesListViewModel(dispatchAction: @escaping ActionDispatch,
                                       localUserState: LocalUserState,
                                       isPreviewSettings: Bool) -> AudioDevicesListViewModel {
        AudioDevicesListViewModel(compositeViewModelFactory: self,
                                  dispatchAction: dispatchAction,
                                  localUserState: localUserState,
                                  localizationProvider: localizationProvider,
                                  isPreviewSettings: isPreviewSettings
        )
    }
    
    func makeLayoutOptionsViewModel(
        localUserState: LocalUserState,
        isDisplayed: Bool,
        onGridSelect: @escaping () -> Void,
        onSpeakerSelect: @escaping () -> Void
    ) -> LayoutOptionsViewModel {
        LayoutOptionsViewModel(localUserState: localUserState,
                               localizationProvider: localizationProvider,
                               onGridSelected: onGridSelect,
                               onSpeakerSelected: onSpeakerSelect,
                               isDisplayed: isDisplayed)
    }
    
    func makeCaptionsLanguageListViewModel(dispatchAction: @escaping ActionDispatch,
                                           state: AppState
    ) -> CaptionsLanguageListViewModel {
        CaptionsLanguageListViewModel(compositeViewModelFactory: self,
                                      dispatchAction: dispatchAction,
                                      state: state,
                                      localizationProvider: localizationProvider)
    }
    
    func makeCaptionsListViewModel(state: AppState,
                                   captionsOptions: CaptionsOptions,
                                   dispatchAction: @escaping ActionDispatch,
                                   showSpokenLanguage: @escaping () -> Void,
                                   showCaptionsLanguage: @escaping () -> Void,
                                   isDisplayed: Bool) -> CaptionsListViewModel {
        
        return CaptionsListViewModel(compositeViewModelFactory: self,
                                     localizationProvider: localizationProvider,
                                     captionsOptions: captionsOptions,
                                     state: state,
                                     dispatchAction: dispatchAction,
                                     showSpokenLanguage: showSpokenLanguage,
                                     showCaptionsLanguage: showCaptionsLanguage,
                                     isDisplayed: store.state.navigationState.captionsViewVisible
                                     && store.state.visibilityState.currentStatus == .visible)
    }
    
    func makeCaptionsInfoViewModel(state: AppState) -> CaptionsInfoViewModel {
        return CaptionsInfoViewModel(state: state,
                                     captionsManager: captionsViewManager,
                                     localizationProvider: localizationProvider)
    }
    
    func makeCaptionsErrorViewModel(dispatchAction: @escaping ActionDispatch)
    -> CaptionsErrorViewModel {
        return CaptionsErrorViewModel(compositeViewModelFactory: self,
                                      logger: logger,
                                      localizationProvider: localizationProvider,
                                      accessibilityProvider: accessibilityProvider,
                                      dispatchAction: dispatchAction)
    }
    
    func makeCaptionsLangaugeCellViewModel(title: String,
                                           isSelected: Bool,
                                           accessibilityLabel: String,
                                           onSelectedAction: @escaping (() -> Void)) -> DrawerSelectableItemViewModel {
        return DrawerSelectableItemViewModel(icon: nil,
                                             title: title,
                                             accessibilityIdentifier: "",
                                             accessibilityLabel: accessibilityLabel,
                                             isSelected: isSelected,
                                             action: onSelectedAction)
    }
    
    func makeErrorInfoViewModel(title: String,
                                subtitle: String) -> ErrorInfoViewModel {
        ErrorInfoViewModel(localizationProvider: localizationProvider,
                           title: title,
                           subtitle: subtitle)
    }
}

extension CompositeViewModelFactory {
    func makeCallDiagnosticsViewModel(dispatchAction: @escaping ActionDispatch) -> CallDiagnosticsViewModel {
        CallDiagnosticsViewModel(localizationProvider: localizationProvider,
                                 accessibilityProvider: accessibilityProvider,
                                 dispatchAction: dispatchAction)
    }
    // MARK: CallingViewModels
    func makeLobbyOverlayViewModel() -> LobbyOverlayViewModel {
        LobbyOverlayViewModel(localizationProvider: localizationProvider,
                              accessibilityProvider: accessibilityProvider)
    }
    func makeLoadingOverlayViewModel() -> LoadingOverlayViewModel {
        LoadingOverlayViewModel(localizationProvider: localizationProvider,
                                accessibilityProvider: accessibilityProvider,
                                networkManager: networkManager,
                                audioSessionManager: audioSessionManager,
                                themeOptions: themeOptions,
                                store: store,
                                callType: callType)
    }
    func makeOnHoldOverlayViewModel(resumeAction: @escaping (() -> Void)) -> OnHoldOverlayViewModel {
        OnHoldOverlayViewModel(localizationProvider: localizationProvider,
                               compositeViewModelFactory: self,
                               logger: logger,
                               accessibilityProvider: accessibilityProvider,
                               audioSessionManager: audioSessionManager,
                               resumeAction: resumeAction)
    }
    func makeControlBarViewModel(dispatchAction: @escaping ActionDispatch,
                                 onEndCallTapped: @escaping (() -> Void),
                                 localUserState: LocalUserState,
                                 capabilitiesManager: CapabilitiesManager,
                                 buttonViewDataState: ButtonViewDataState)
    -> ControlBarViewModel {
        ControlBarViewModel(compositeViewModelFactory: self,
                            logger: logger,
                            localizationProvider: localizationProvider,
                            dispatchAction: dispatchAction,
                            onEndCallTapped: onEndCallTapped,
                            localUserState: localUserState,
                            accessibilityProvider: accessibilityProvider,
                            audioVideoMode: localOptions?.audioVideoMode ?? .audioAndVideo,
                            capabilitiesManager: capabilitiesManager,
                            controlBarOptions: callScreenOptions?.controlBarOptions,
                            buttonViewDataState: buttonViewDataState)
    }
    
    func makeInfoHeaderViewModel(dispatchAction: @escaping ActionDispatch,
                                 localUserState: LocalUserState,
                                 callScreenInfoHeaderState: CallScreenInfoHeaderState,
                                 isChatEnable: Bool,
                                 /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
                                
                                 buttonViewDataState: ButtonViewDataState,
                                 controlHeaderViewData: CallScreenHeaderViewData?
                                 /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
    ) -> InfoHeaderViewModel {
        InfoHeaderViewModel(compositeViewModelFactory: self,
                            logger: logger,
                            localUserState: localUserState,
                            localizationProvider: localizationProvider,
                            accessibilityProvider: accessibilityProvider,
                            dispatchAction: dispatchAction,
                            enableMultitasking: enableMultitasking,
                            enableSystemPipWhenMultitasking: enableSystemPipWhenMultitasking,
                            callScreenInfoHeaderState: callScreenInfoHeaderState,
                            isChatEnable: isChatEnable,
                            /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
                            
                            buttonViewDataState: buttonViewDataState,
                            controlHeaderViewData: controlHeaderViewData,
                            azureCorrelationId: localOptions?.azureCorrelationId
                            /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
        )
    }
    
    func makeLobbyWaitingHeaderViewModel(localUserState: LocalUserState,
                                         dispatchAction: @escaping ActionDispatch) -> LobbyWaitingHeaderViewModel {
        LobbyWaitingHeaderViewModel(compositeViewModelFactory: self,
                                    logger: logger,
                                    localUserState: localUserState,
                                    localizationProvider: localizationProvider,
                                    accessibilityProvider: accessibilityProvider,
                                    dispatchAction: dispatchAction)
    }
    
    func makeLobbyActionErrorViewModel(localUserState: LocalUserState,
                                       dispatchAction: @escaping ActionDispatch) -> LobbyErrorHeaderViewModel {
        LobbyErrorHeaderViewModel(compositeViewModelFactory: self,
                                  logger: logger,
                                  localUserState: localUserState,
                                  localizationProvider: localizationProvider,
                                  accessibilityProvider: accessibilityProvider,
                                  dispatchAction: dispatchAction)
    }
    
    func makeParticipantCellViewModel(participantModel: ParticipantInfoModel) -> ParticipantGridCellViewModel {
        ParticipantGridCellViewModel(localizationProvider: localizationProvider,
                                     accessibilityProvider: accessibilityProvider,
                                     participantModel: participantModel,
                                     isCameraEnabled: localOptions?.audioVideoMode != .audioOnly,
                                     onUserClicked: { [weak self] in
            self?.store.dispatch(action: Action.showParticipantOptions(participantModel))
        },
                                     onResetReaction: { [weak self] in
            self?.store.dispatch(action: .remoteParticipantsAction(.resetParticipantReaction(participantModel.userIdentifier)))
        },
                                     callType: callType,
                                     isWhiteBoard: participantModel.isWhiteBoard)
    }
    
    func makeParticipantGridsViewModel(isIpadInterface: Bool, rendererViewManager: RendererViewManager) -> ParticipantGridViewModel {
        ParticipantGridViewModel(compositeViewModelFactory: self,
                                 localizationProvider: localizationProvider,
                                 accessibilityProvider: accessibilityProvider,
                                 isIpadInterface: isIpadInterface,
                                 remoteParticipantsState: store.state.remoteParticipantsState,
                                 callType: callType,
                                 rendererViewManager: rendererViewManager, whiteBoardId: localOptions?.whiteBoardId ?? "")
    }
    
    func makeParticipantsListViewModel(localUserState: LocalUserState,
                                       isDisplayed: Bool,
                                       showSharingViewAction: @escaping () -> Void,
                                       dispatchAction: @escaping ActionDispatch) -> ParticipantsListViewModel {
        ParticipantsListViewModel(compositeViewModelFactory: self,
                                  localUserState: localUserState,
                                  dispatchAction: dispatchAction,
                                  localizationProvider: localizationProvider,
                                  onUserClicked: { participant in
            dispatchAction(Action.showParticipantOptions(participant))
        },
                                  onShowShareSheetMeetingLink: showSharingViewAction,
                                  avatarManager: avatarManager,
                                  callType: callType
        )
    }
    
    func makeParticipantOptionsViewModel(
        localUserState: LocalUserState,
        isDisplayed: Bool,
        dispatchAction: @escaping ActionDispatch,
        isPinEnable: Bool
    ) -> ParticipantOptionsViewModel {
        ParticipantOptionsViewModel(
            localUserState: localUserState,
            localizationProvider: localizationProvider,
            onPinUser: { participant in
                dispatchAction(.hideDrawer)
                dispatchAction(.remoteParticipantsAction(.pinParticipant(participantId: participant.userIdentifier)))
            },
            onUnpinUser: { participant in
                dispatchAction(.hideDrawer)
                dispatchAction(.remoteParticipantsAction(.unpinParticipant(participantId: participant.userIdentifier)))
            },
            onShowVieo: { participant in
                dispatchAction(.hideDrawer)
                dispatchAction(.remoteParticipantsAction(.showParticipantVideo(participantId: participant.userIdentifier)))
            },
            onHideVideo: { participant in
                dispatchAction(.hideDrawer)
                dispatchAction(.remoteParticipantsAction(.hideParticipantVideo(participantId: participant.userIdentifier)))
            },
            isPinEnable: isPinEnable,
            isDisplayed: isDisplayed)
    }
    
    func makeParticipantMenuViewModel(localUserState: LocalUserState,
                                      isDisplayed: Bool,
                                      dispatchAction: @escaping ActionDispatch) -> ParticipantMenuViewModel {
        ParticipantMenuViewModel(compositeViewModelFactory: self,
                                 localUserState: localUserState,
                                 localizationProvider: localizationProvider,
                                 capabilitiesManager: capabilitiesManager,
                                 onRemoveUser: { user in
            dispatchAction(.remoteParticipantsAction(.remove(participantId: user.userIdentifier)))
            dispatchAction(.hideDrawer)
        },
                                 isDisplayed: isDisplayed)
    }
    
    func makeBannerViewModel(dispatchAction: @escaping ActionDispatch) -> BannerViewModel {
        BannerViewModel(compositeViewModelFactory: self, dispatchAction: dispatchAction)
    }
    
    func makeBannerTextViewModel() -> BannerTextViewModel {
        BannerTextViewModel(accessibilityProvider: accessibilityProvider,
                            localizationProvider: localizationProvider)
    }
    
    func makeMoreCallOptionsListViewModel(
        isCaptionsAvailable: Bool,
        controlBarOptions: CallScreenControlBarOptions?,
        showSharingViewAction: @escaping () -> Void,
        showSupportFormAction: @escaping () -> Void,
        showCaptionsViewAction: @escaping () -> Void,
        buttonViewDataState: ButtonViewDataState,
        dispatchAction: @escaping ActionDispatch) -> MoreCallOptionsListViewModel {
            
            // events.onUserReportedIssue
            return MoreCallOptionsListViewModel(compositeViewModelFactory: self,
                                                localizationProvider: localizationProvider,
                                                showSharingViewAction: showSharingViewAction,
                                                showSupportFormAction: showSupportFormAction,
                                                showCaptionsViewAction: showCaptionsViewAction,
                                                controlBarOptions: controlBarOptions,
                                                isCaptionsAvailable: isCaptionsAvailable,
                                                isSupportFormAvailable: events.onUserReportedIssue != nil,
                                                buttonViewDataState: buttonViewDataState,
                                                dispatchAction: dispatchAction)
        }
    
    func makeLanguageListItemViewModel(title: String,
                                       subtitle: String?,
                                       accessibilityIdentifier: String,
                                       startIcon: CompositeIcon,
                                       endIcon: CompositeIcon?,
                                       isEnabled: Bool,
                                       action: @escaping (() -> Void)) -> DrawerGenericItemViewModel {
        DrawerGenericItemViewModel(title: title,
                                   subtitle: subtitle,
                                   accessibilityIdentifier: accessibilityIdentifier,
                                   accessibilityTraits: .isButton,
                                   action: action,
                                   startCompositeIcon: startIcon,
                                   endIcon: endIcon,
                                   isEnabled: isEnabled)
    }
    
    func makeToggleListItemViewModel(title: String,
                                     isToggleOn: Binding<Bool>,
                                     showToggle: Bool,
                                     accessibilityIdentifier: String,
                                     startIcon: CompositeIcon,
                                     isEnabled: Bool,
                                     action: @escaping (() -> Void)) -> DrawerGenericItemViewModel {
        DrawerGenericItemViewModel(title: title,
                                   accessibilityIdentifier: accessibilityIdentifier,
                                   action: action,
                                   startCompositeIcon: startIcon,
                                   showToggle: showToggle,
                                   isToggleOn: isToggleOn,
                                   isEnabled: isEnabled)
    }
    
    func makeDrawerListItemViewModel(icon: CompositeIcon,
                                     title: String,
                                     accessibilityIdentifier: String) -> DrawerGenericItemViewModel {
        DrawerGenericItemViewModel(title: title,
                                   accessibilityIdentifier: accessibilityIdentifier,
                                   action: nil,
                                   startCompositeIcon: icon)
    }
    
    func makeDebugInfoSharingActivityViewModel() -> DebugInfoSharingActivityViewModel {
        DebugInfoSharingActivityViewModel(accessibilityProvider: accessibilityProvider,
                                          debugInfoManager: debugInfoManager) {
            self.store.dispatch(action: .hideDrawer)
        }
    }
    
    //MTDOD need proper way to construct link
    func makeShareMeetingInfoActivityViewModel() -> ShareMeetingInfoActivityViewModel {
        ShareMeetingInfoActivityViewModel(accessibilityProvider: accessibilityProvider,
                                          debugInfoManager: debugInfoManager, shareLink: "https://msteam.desktop.superbrains.nl/meeting?roomId=\(localOptions?.callId ?? "")") {
            self.store.dispatch(action: .hideDrawer)
        }
    }
    
    func makeBottomToastViewModel(toastNotificationState: ToastNotificationState,
                                  dispatchAction: @escaping ActionDispatch) -> BottomToastViewModel {
        BottomToastViewModel(dispatchAction: dispatchAction,
                             localizationProvider: localizationProvider,
                             accessibilityProvider: accessibilityProvider,
                             toastNotificationState: toastNotificationState)
    }
    
    // MARK: SetupViewModels
    func makePreviewAreaViewModel(dispatchAction: @escaping ActionDispatch) -> PreviewAreaViewModel {
        PreviewAreaViewModel(compositeViewModelFactory: self,
                             dispatchAction: dispatchAction,
                             localizationProvider: localizationProvider)
    }
    
    func makeSetupControlBarViewModel(dispatchAction: @escaping ActionDispatch,
                                      localUserState: LocalUserState,
                                      buttonViewDataState: ButtonViewDataState) -> SetupControlBarViewModel {
        let audioVideoMode = localOptions?.audioVideoMode ?? CallCompositeAudioVideoMode.audioAndVideo
        
        return SetupControlBarViewModel(compositeViewModelFactory: self,
                                        logger: logger,
                                        dispatchAction: dispatchAction,
                                        updatableOptionsManager: updatableOptionsManager,
                                        localUserState: localUserState,
                                        localizationProvider: localizationProvider,
                                        audioVideoMode: audioVideoMode,
                                        setupScreenOptions: setupScreenOptions,
                                        buttonViewDataState: buttonViewDataState)
    }
    
    func makeJoiningCallActivityViewModel() -> JoiningCallActivityViewModel {
        JoiningCallActivityViewModel(title: self.localizationProvider.getLocalizedString(LocalizationKey.joiningCall))
    }
    
    func userTriggerEndCall() {
        if callType == .roomsCall || callType == .teamsMeeting {
            events.onUserCallEnded?()
        } else {
            events.onOneOnOneCallEnded?()
        }
    }
}
