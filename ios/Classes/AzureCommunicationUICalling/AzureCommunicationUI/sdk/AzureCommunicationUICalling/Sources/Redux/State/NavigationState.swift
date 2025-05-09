//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum NavigationStatus {
    case setup
    case inCall
    case exit
}

struct NavigationState: Equatable {
    
    let status: NavigationStatus
    let supportFormVisible: Bool
    let captionsViewVisible: Bool
    let captionsLanguageViewVisible: Bool
    let spokenLanguageViewVisible: Bool
    let endCallConfirmationVisible: Bool
    let audioSelectionVisible: Bool
    let moreOptionsVisible: Bool
    let supportShareSheetVisible: Bool
    let participantsVisible: Bool
    let participantActionsVisible: Bool
    let participantOptionsVisible: Bool
    let shareMeetingLinkVisible: Bool
    let layoutOptionsVisible: Bool
    let meetignOptionsVisible: Bool
    
    // When showing Participant Menu, this provides
    // context on who we are shoing it for
    let selectedParticipant: ParticipantInfoModel?
    init(status: NavigationStatus = .setup,
         supportFormVisible: Bool = false,
         captionsViewVisible: Bool = false,
         captionsLanguageViewVisible: Bool = false,
         spokenLanguageViewVisible: Bool = false,
         endCallConfirmationVisible: Bool = false,
         audioSelectionVisible: Bool = false,
         moreOptionsVisible: Bool = false,
         supportShareSheetVisible: Bool = false,
         participantsVisible: Bool = false,
         participantActionsVisible: Bool = false,
         participantOptionsVisible: Bool = false,
         shareMeetingLinkVisible: Bool = false,
         layoutOptionsVisible: Bool = false,
         meetignOptionsVisible: Bool = false,
         selectedParticipant: ParticipantInfoModel? = nil
    ) {
        self.status = status
        self.supportFormVisible = supportFormVisible
        self.captionsViewVisible = captionsViewVisible
        self.captionsLanguageViewVisible = captionsLanguageViewVisible
        self.spokenLanguageViewVisible = spokenLanguageViewVisible
        self.endCallConfirmationVisible = endCallConfirmationVisible
        self.audioSelectionVisible = audioSelectionVisible
        self.moreOptionsVisible = moreOptionsVisible
        self.supportShareSheetVisible = supportShareSheetVisible
        self.participantsVisible = participantsVisible
        self.participantActionsVisible = participantActionsVisible
        self.selectedParticipant = selectedParticipant
        self.participantOptionsVisible = participantOptionsVisible
        self.layoutOptionsVisible = layoutOptionsVisible
        self.meetignOptionsVisible = meetignOptionsVisible
        self.shareMeetingLinkVisible = shareMeetingLinkVisible
    }
    
    static func == (lhs: NavigationState, rhs: NavigationState) -> Bool {
        return lhs.status == rhs.status
        && lhs.supportFormVisible == rhs.supportFormVisible
        && lhs.captionsLanguageViewVisible == rhs.captionsLanguageViewVisible
        && lhs.spokenLanguageViewVisible == rhs.spokenLanguageViewVisible
        && lhs.captionsViewVisible == rhs.captionsViewVisible
        && lhs.endCallConfirmationVisible == rhs.endCallConfirmationVisible
        && lhs.audioSelectionVisible == rhs.audioSelectionVisible
        && lhs.moreOptionsVisible == rhs.moreOptionsVisible
        && lhs.supportShareSheetVisible == rhs.supportShareSheetVisible
        && lhs.participantsVisible == rhs.participantsVisible
        && lhs.participantActionsVisible == rhs.participantActionsVisible
        && lhs.selectedParticipant == rhs.selectedParticipant
        && lhs.participantOptionsVisible == rhs.participantOptionsVisible
        && lhs.layoutOptionsVisible == rhs.layoutOptionsVisible
        && lhs.meetignOptionsVisible == rhs.meetignOptionsVisible
        && lhs.shareMeetingLinkVisible == rhs.shareMeetingLinkVisible
    }
}
