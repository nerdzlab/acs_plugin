//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum RemoteParticipantsAction: Equatable {
    case dominantSpeakersUpdated(speakers: [String])
    case participantListUpdated(participants: [ParticipantInfoModel])
    case pinParticipant(participantId: String)
    case unpinParticipant(participantId: String)
    //Only for local user
    case showParticipantVideo(participantId: String)
    case hideParticipantVideo(participantId: String)
    case admitAll
    case declineAll
    case resetParticipantReaction(String)
    case admit(participantId: String)
    case decline(participantId: String)
    case lobbyError(errorCode: LobbyErrorCode?)
    case remove(participantId: String)
    case removeParticipantError
    case setTotalParticipantCount(participantCount: Int)
}
