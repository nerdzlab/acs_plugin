//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

extension Reducer where State == RemoteParticipantsState,
                        Actions == Action {
    static var liveRemoteParticipantsReducer: Self = Reducer { remoteParticipantsState, action in
        var participantInfoList = remoteParticipantsState.participantInfoList
        var lastUpdateTimeStamp = remoteParticipantsState.lastUpdateTimeStamp
        var dominantSpeakers = remoteParticipantsState.dominantSpeakers
        var dominantSpeakersModifiedTimestamp
        = remoteParticipantsState.dominantSpeakersModifiedTimestamp
        var lobbyError = remoteParticipantsState.lobbyError
        var totalParticipantCount = remoteParticipantsState.totalParticipantCount
        var pinnedParticipantId = remoteParticipantsState.pinnedParticipantId
        var listOfDisabledVideoParticipants = remoteParticipantsState.listOfDisabledVideoParticipants
        let whiteBoardId = remoteParticipantsState.whiteBoardId
        
        switch action {
        case .remoteParticipantsAction(.dominantSpeakersUpdated(speakers: let newSpeakers)):
            dominantSpeakers = newSpeakers
            dominantSpeakersModifiedTimestamp = Date()
        case .remoteParticipantsAction(.participantListUpdated(participants: let newParticipants)):
            lastUpdateTimeStamp = Date()
                        
            let currentIDs = Set(participantInfoList.map { $0.userIdentifier })
            
            // Check if the new participants list includes the whiteboard participant.
            // If so, pin the whiteboard participant by default.
            if newParticipants.contains(where: { $0.userIdentifier == whiteBoardId }) {
                pinnedParticipantId = remoteParticipantsState.whiteBoardId
            } else {
                // If the currently pinned participant is no longer in the list of current IDs,
                // remove the pinned participantId.
                if let pinnedId = pinnedParticipantId, !currentIDs.contains(pinnedId) {
                    pinnedParticipantId = nil
                }
            }
            
            // 🔍 2. Clear listOfDisabledVideoParticipants from not valid users
            listOfDisabledVideoParticipants = listOfDisabledVideoParticipants.filter {
                currentIDs.contains($0)
            }
            
            participantInfoList = updateDerivedParticipantFields(
                updatedList: newParticipants,
                currentList: participantInfoList,
                pinnedParticipantId: pinnedParticipantId,
                listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                whiteBoardId: whiteBoardId
            )
            
        case .errorAction(.statusErrorAndCallReset):
            participantInfoList = []
            pinnedParticipantId = nil
            listOfDisabledVideoParticipants = []
            lastUpdateTimeStamp = Date()
        case .remoteParticipantsAction(.lobbyError(errorCode: let lobbyErrorCode)):
            if let lobbyErrorCode {
                lobbyError = LobbyError(lobbyErrorCode: lobbyErrorCode, errorTimeStamp: Date())
            } else {
                lobbyError = nil
            }
        case .remoteParticipantsAction(.setTotalParticipantCount(participantCount: let participantCount)):
            totalParticipantCount = participantCount
            lastUpdateTimeStamp = Date()
            
        case .remoteParticipantsAction(.pinParticipant(participantId: let participantId)):
            pinnedParticipantId = participantId
            lastUpdateTimeStamp = Date()
            
            participantInfoList = updateDerivedParticipantFields(
                updatedList: participantInfoList,
                currentList: participantInfoList,
                pinnedParticipantId: pinnedParticipantId,
                listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                whiteBoardId: whiteBoardId
            )
            
        case .remoteParticipantsAction(.unpinParticipant(participantId: let participantId)):
            pinnedParticipantId = nil
            lastUpdateTimeStamp = Date()
            
            participantInfoList = updateDerivedParticipantFields(
                updatedList: participantInfoList,
                currentList: participantInfoList,
                pinnedParticipantId: pinnedParticipantId,
                listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                whiteBoardId: whiteBoardId
            )
            
        case .remoteParticipantsAction(.showParticipantVideo(participantId: let participantId)):
            listOfDisabledVideoParticipants.remove(participantId)
            lastUpdateTimeStamp = Date()
            
            participantInfoList = updateDerivedParticipantFields(
                updatedList: participantInfoList,
                currentList: participantInfoList,
                pinnedParticipantId: pinnedParticipantId,
                listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                whiteBoardId: whiteBoardId
            )
            
        case .remoteParticipantsAction(.hideParticipantVideo(participantId: let participantId)):
            listOfDisabledVideoParticipants.insert(participantId)
            lastUpdateTimeStamp = Date()
            
            participantInfoList = updateDerivedParticipantFields(
                updatedList: participantInfoList,
                currentList: participantInfoList,
                pinnedParticipantId: pinnedParticipantId,
                listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                whiteBoardId: whiteBoardId
            )
        case .remoteParticipantsAction(.resetParticipantReaction(let participantId)):
            lastUpdateTimeStamp = Date()
            
            participantInfoList = updateDerivedParticipantFields(
                updatedList: participantInfoList.map { participant in
                    if participant.userIdentifier == participantId {
                        var updated = participant
                        updated = ParticipantInfoModel(
                            displayName: participant.displayName,
                            isSpeaking: participant.isSpeaking,
                            isMuted: participant.isMuted,
                            isHandRaised: participant.isHandRaised,
                            selectedReaction: nil,
                            isPinned: participant.isPinned,
                            isVideoOnForMe: participant.isVideoOnForMe,
                            avatarColor: participant.avatarColor,
                            isRemoteUser: participant.isRemoteUser,
                            isWhiteBoard: participant.isWhiteBoard,
                            userIdentifier: participant.userIdentifier,
                            status: participant.status,
                            
                            screenShareVideoStreamModel: participant.screenShareVideoStreamModel,
                            cameraVideoStreamModel: participant.cameraVideoStreamModel
                        )
                        
                        return updated
                    }
                    return participant
                },
                currentList: participantInfoList,
                pinnedParticipantId: pinnedParticipantId,
                listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                whiteBoardId: whiteBoardId
            )
            
        default:
            break
        }
        return RemoteParticipantsState(participantInfoList: participantInfoList,
                                       lastUpdateTimeStamp: lastUpdateTimeStamp,
                                       dominantSpeakers: dominantSpeakers,
                                       dominantSpeakersModifiedTimestamp: dominantSpeakersModifiedTimestamp,
                                       lobbyError: lobbyError,
                                       totalParticipantCount: totalParticipantCount,
                                       pinnedParticipantId: pinnedParticipantId,
                                       listOfDisabledVideoParticipants: listOfDisabledVideoParticipants,
                                       whiteBoardId: whiteBoardId
        )
    }
}

private func updateDerivedParticipantFields(
    updatedList: [ParticipantInfoModel],
    currentList: [ParticipantInfoModel],
    pinnedParticipantId: String?,
    listOfDisabledVideoParticipants: Set<String>,
    whiteBoardId: String?
) -> [ParticipantInfoModel] {
    updatedList.map { participant in
        // Find existing participant in current list
        let existingParticipant = currentList.first(where: { $0.userIdentifier == participant.userIdentifier })

        // Use existing color or assign new random one
        let avatarColor = existingParticipant?.avatarColor ?? Color(UIColor.avatarColors.randomElement() ?? UIColor.compositeColor(.purpleBlue))
        
        let timeRemaining = existingParticipant?.selectedReaction?.receivedOn?.addingTimeInterval(3.0).timeIntervalSince(Date())
        
        var selectedReaction: ReactionPayload?
        
        if (timeRemaining ?? 0) > 0 {
            if (participant.selectedReaction != nil && participant.selectedReaction != existingParticipant?.selectedReaction) {
                selectedReaction = participant.selectedReaction
            } else {
                selectedReaction = existingParticipant?.selectedReaction
            }
        } else {
            selectedReaction = participant.selectedReaction
        }
        
        let isWhiteBoard = participant.userIdentifier == whiteBoardId

        return ParticipantInfoModel(
            displayName: participant.displayName,
            isSpeaking: participant.isSpeaking,
            isMuted: participant.isMuted,
            isHandRaised: participant.isHandRaised,
            selectedReaction: selectedReaction,
            isPinned: participant.userIdentifier == pinnedParticipantId,
            isVideoOnForMe: !listOfDisabledVideoParticipants.contains(participant.userIdentifier),
            avatarColor: avatarColor,
            isRemoteUser: participant.isRemoteUser,
            isWhiteBoard: isWhiteBoard,
            userIdentifier: participant.userIdentifier,
            status: participant.status,
            screenShareVideoStreamModel: participant.screenShareVideoStreamModel,
            cameraVideoStreamModel: participant.cameraVideoStreamModel
        )
    }
}
