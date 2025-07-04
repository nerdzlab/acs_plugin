//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine

extension Reducer where State == NavigationState,
                        Actions == Action {
    static var liveNavigationReducer: Self = Reducer { state, action in
        var navigationStatus = state.status
        var drawerVisibility = getDrawerVisibility(state: state)
        var selectedParticipant = state.selectedParticipant

        switch action {
        case .visibilityAction(.pipModeEntered):
            drawerVisibility = .hidden
        case .callingViewLaunched:
            navigationStatus = .inCall
            drawerVisibility = .hidden
        case .errorAction(.fatalErrorUpdated):
            navigationStatus = .inCall
        case .compositeExitAction:
            navigationStatus = .exit
        case .errorAction(.statusErrorAndCallReset):
            navigationStatus = .setup
        case .hideDrawer:
            selectedParticipant = nil
            drawerVisibility = .hidden
        case .showSupportForm:
            drawerVisibility = .supportFormVisible
        case .showEndCallConfirmation:
            drawerVisibility = .endCallConfirmationVisible
        case .showMoreOptions:
            drawerVisibility = .moreOptionsVisible
        case .showAudioSelection:
            drawerVisibility = .audioSelectionVisible
        case .showSupportShare:
            drawerVisibility = .supportShareSheetVisible
        case .showShareSheetMeetingLink:
            drawerVisibility = .shareMeetingLinkVisible
        case .showLayoutOptions:
            drawerVisibility = .layoutOptionsVisible
        case .showMeetingOptions:
            drawerVisibility = .meetingOptionsVisible
        case .showParticipants:
            drawerVisibility = .participantsVisible
        case .showParticipantActions(let participant):
            drawerVisibility = .participantActionsVisible
            selectedParticipant = participant
        case .showParticipantOptions(let participant):
            drawerVisibility = .participantOptionsVisible
            selectedParticipant = participant
        case .showCaptionsListView:
            drawerVisibility = .captionsViewVisible
        case .showSpokenLanguageView:
            drawerVisibility = .spokenLanguageViewVisible
        case .showCaptionsLanguageView:
            drawerVisibility = .captionsLangaugeViewVisible
        case .localUserAction(.audioDeviceChangeRequested):
            drawerVisibility = .hidden
        case .localUserAction(.muteIncomingAudioRequested):
            drawerVisibility = .hidden
        case .localUserAction(.gridLayoutSelected):
            drawerVisibility = .hidden
        case .localUserAction(.speakerLayoutSelected):
            drawerVisibility = .hidden
        case .localUserAction(.raiseHandFailed):
            drawerVisibility = .hidden
        case .localUserAction(.lowerHandFailed):
            drawerVisibility = .hidden
        case .captionsAction(.setSpokenLanguageRequested(language: let language)),
                .captionsAction(.setCaptionLanguageRequested(language: let language)):
            drawerVisibility = .hidden
        case .showBackgroundEffectsView:
            drawerVisibility = .backgroundEffectsViewVisible
        case .localUserAction(.screenShareOnRequested):
            drawerVisibility = .hidden
        case .localUserAction(.screenShareOffRequested):
            drawerVisibility = .hidden
        case .localUserAction(.raiseHandRequested):
            drawerVisibility = .hidden
        case .localUserAction(.lowerHandRequested):
            drawerVisibility = .hidden
        case .localUserAction(.backgroundEffectRequested(_)):
            drawerVisibility = .hidden
        case .localUserAction(.sendReaction(_)):
            drawerVisibility = .hidden
        case .localUserAction(.showChat):
            drawerVisibility = .hidden
        case .audioSessionAction,
                .callingAction(.callIdUpdated),
                .callingAction(.callStartRequested),
                .callingAction(.callEndRequested),
                .callingAction(.callEnded),
                .callingAction(.requestFailed),
                .callingAction(.stateUpdated),
                .callingAction(.setupCall),
                .callingAction(.recordingStateUpdated),
                .callingAction(.transcriptionStateUpdated),
                .callingAction(.resumeRequested),
                .callingAction(.holdRequested),
                .callingAction(.recordingUpdated),
                .callingAction(.transcriptionUpdated),
                .callingAction(.dismissRecordingTranscriptionBannedUpdated),
            /* <CALL_START_TIME>
                .callingAction(.callStartTimeUpdated),
            </CALL_START_TIME> */
                .captionsAction,
                .lifecycleAction,
                .localUserAction,
                .remoteParticipantsAction,
                .permissionAction,
                .visibilityAction,
                .callDiagnosticAction,
                .toastNotificationAction,
                .callScreenInfoHeaderAction,
                .setTotalParticipantCount,
                .buttonViewDataAction:
            return state
        }
        return NavigationState(status: navigationStatus,
                               supportFormVisible: drawerVisibility.isSupportFormVisible,
                               captionsViewVisible: drawerVisibility.isCaptionsViewVisible,
                               captionsLanguageViewVisible: drawerVisibility.isCaptionsLangauageViewVisible,
                               spokenLanguageViewVisible: drawerVisibility.isSpokenLanguageViewVisible,
                               endCallConfirmationVisible: drawerVisibility.isEndCallConfirmationVisible,
                               audioSelectionVisible: drawerVisibility.isAudioSelectionVisible,
                               moreOptionsVisible: drawerVisibility.isMoreOptionsVisible,
                               supportShareSheetVisible: drawerVisibility.isSupportShareSheetVisible,
                               participantsVisible: drawerVisibility.isParticipantsVisible,
                               participantActionsVisible: drawerVisibility.isParticipantActionsVisible,
                               participantOptionsVisible: drawerVisibility.isParticipantOptionsVisible, shareMeetingLinkVisible: drawerVisibility.isShareSheetMeetingLinkVisible, layoutOptionsVisible: drawerVisibility.isLayoutOptionsVisible, meetignOptionsVisible: drawerVisibility.isMeetingOptionsVisible,  selectedParticipant: selectedParticipant
        )
    }
    enum DrawerVisibility {
        case hidden
        case supportFormVisible
        case supportShareSheetVisible
        case endCallConfirmationVisible
        case audioSelectionVisible
        case moreOptionsVisible
        case participantsVisible
        case participantActionsVisible
        case captionsViewVisible
        case captionsLangaugeViewVisible
        case spokenLanguageViewVisible
        case participantOptionsVisible
        case shareMeetingLinkVisible
        case layoutOptionsVisible
        case meetingOptionsVisible
        case backgroundEffectsViewVisible

        var isSupportFormVisible: Bool { self == .supportFormVisible }
        var isSupportShareSheetVisible: Bool { self == .supportShareSheetVisible }
        var isEndCallConfirmationVisible: Bool { self == .endCallConfirmationVisible }
        var isAudioSelectionVisible: Bool { self == .audioSelectionVisible }
        var isMoreOptionsVisible: Bool { self == .moreOptionsVisible }
        var isParticipantsVisible: Bool { self == .participantsVisible }
        var isParticipantActionsVisible: Bool { self == .participantActionsVisible }
        var isCaptionsViewVisible: Bool { self == .captionsViewVisible }
        var isCaptionsLangauageViewVisible: Bool { self == .captionsLangaugeViewVisible }
        var isSpokenLanguageViewVisible: Bool { self == .spokenLanguageViewVisible}
        var isParticipantOptionsVisible: Bool { self == .participantOptionsVisible}
        var isShareSheetMeetingLinkVisible: Bool { self == .shareMeetingLinkVisible }
        var isLayoutOptionsVisible: Bool { self == .layoutOptionsVisible }
        var isMeetingOptionsVisible: Bool { self == .meetingOptionsVisible }
        var isBackgroundEffectsViewVisible: Bool { self == .backgroundEffectsViewVisible }
    }

    static func getDrawerVisibility(state: NavigationState) -> DrawerVisibility {
        return state.supportFormVisible ? .supportFormVisible :
        state.supportShareSheetVisible ? .supportShareSheetVisible :
        state.endCallConfirmationVisible ? .endCallConfirmationVisible :
        state.audioSelectionVisible ? .audioSelectionVisible :
        state.participantsVisible ? .participantsVisible :
        state.participantActionsVisible ? .participantActionsVisible :
        state.captionsViewVisible ? .captionsViewVisible :
        state.captionsLanguageViewVisible ? .captionsLangaugeViewVisible :
        state.spokenLanguageViewVisible ? .spokenLanguageViewVisible :
        state.participantOptionsVisible ? .participantOptionsVisible :
        state.shareMeetingLinkVisible ? .shareMeetingLinkVisible :
        state.layoutOptionsVisible ? .layoutOptionsVisible :
        state.meetignOptionsVisible ? .meetingOptionsVisible :
        state.moreOptionsVisible ? .moreOptionsVisible : .hidden
    }

}
