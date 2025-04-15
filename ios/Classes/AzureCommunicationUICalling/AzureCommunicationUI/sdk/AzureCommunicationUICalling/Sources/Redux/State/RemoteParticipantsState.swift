//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

import AzureCommunicationCalling

struct RemoteParticipantsState {
    let participantInfoList: [ParticipantInfoModel]
    let lastUpdateTimeStamp: Date
    let dominantSpeakers: [String]
    let dominantSpeakersModifiedTimestamp: Date
    let lobbyError: LobbyError?
    let totalParticipantCount: Int
    let pinnedParticipantId: String?
    let listOfDisabledVideoParticipants: Set<String> // 🆕

    init(participantInfoList: [ParticipantInfoModel] = [],
         lastUpdateTimeStamp: Date = Date(),
         dominantSpeakers: [String] = [],
         dominantSpeakersModifiedTimestamp: Date = Date(),
         lobbyError: LobbyError? = nil,
         totalParticipantCount: Int,
         pinnedParticipantId: String? = nil,
         listOfDisabledVideoParticipants: Set<String> = []
    ) {
        self.participantInfoList = participantInfoList
        self.lastUpdateTimeStamp = lastUpdateTimeStamp
        self.dominantSpeakers = dominantSpeakers
        self.dominantSpeakersModifiedTimestamp = dominantSpeakersModifiedTimestamp
        self.lobbyError = lobbyError
        self.totalParticipantCount = totalParticipantCount
        self.pinnedParticipantId = pinnedParticipantId
        self.listOfDisabledVideoParticipants = listOfDisabledVideoParticipants
    }
}

struct LobbyError {
    let lobbyErrorCode: LobbyErrorCode
    let errorTimeStamp: Date
}

enum LobbyErrorCode {
    case lobbyDisabledByConfigurations
    case lobbyConversationTypeNotSupported
    case lobbyMeetingRoleNotAllowed
    case removeParticipantOperationFailure
    case unknownError

    static func convertToLobbyErrorCode(_ error: NSError) -> LobbyErrorCode {
        switch CallingCommunicationErrors(rawValue: error.code) {
        case .lobbyDisabledByConfigurations:
            return .lobbyDisabledByConfigurations
        case .lobbyMeetingRoleNotAllowed:
            return .lobbyMeetingRoleNotAllowed
        case .lobbyConversationTypeNotSupported:
            return .lobbyConversationTypeNotSupported
        case .removeParticipantOperationFailure:
            return .removeParticipantOperationFailure
        default:
            return .unknownError
        }
    }
}
