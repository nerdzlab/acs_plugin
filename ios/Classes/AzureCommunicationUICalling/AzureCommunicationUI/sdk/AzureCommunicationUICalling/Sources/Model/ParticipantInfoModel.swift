//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

enum ParticipantStatus: Int {
    case idle
    case earlyMedia
    case connecting
    case connected
    case hold
    case inLobby
    case disconnected
    case ringing
}

enum ReactionType: String, Codable, CaseIterable {
    case like
    case heart
    case laugh
    case surprised
    case applause
    
    var emoji: String {
        switch self {
        case .like: return "👍"
        case .heart: return "❤️"
        case .applause: return "👏"
        case .laugh: return "😆"
        case .surprised: return "😲"
        }
    }
}

struct ReactionPayload: Codable, Equatable, Hashable {
    let reaction: ReactionType
    var receivedOn: Date?
    
    static func == (lhs: ReactionPayload, rhs: ReactionPayload) -> Bool {
        return lhs.reaction == rhs.reaction &&
        lhs.receivedOn == rhs.receivedOn
    }
}

typealias ReactionMessage = [String: ReactionPayload]

struct ParticipantInfoModel: Hashable, Equatable {
    let displayName: String
    let isSpeaking: Bool
    let isMuted: Bool
    let isHandRaised: Bool
    var selectedReaction: ReactionPayload?
    
    let isPinned: Bool
    let isVideoOnForMe: Bool
    let avatarColor: Color
    
    let isRemoteUser: Bool
    let isWhiteBoard: Bool
    let userIdentifier: String
    let status: ParticipantStatus
    
    let screenShareVideoStreamModel: VideoStreamInfoModel?
    let cameraVideoStreamModel: VideoStreamInfoModel?
}

extension ParticipantInfoModel {
    func copy(
        displayName: String? = nil,
        isSpeaking: Bool? = nil,
        isMuted: Bool? = nil,
        isHandRaised: Bool? = nil,
        isPinned: Bool? = nil,
        isVideoOnForMe: Bool? = nil,
        avatarColor: Color? = nil,
        isRemoteUser: Bool? = nil,
        userIdentifier: String? = nil,
        status: ParticipantStatus? = nil,
        screenShareVideoStreamModel: VideoStreamInfoModel? = nil,
        cameraVideoStreamModel: VideoStreamInfoModel? = nil,
        selectedReaction: ReactionPayload? = nil,
        isWhiteBoard: Bool? = nil
    ) -> ParticipantInfoModel {
        return ParticipantInfoModel(
            displayName: displayName ?? self.displayName,
            isSpeaking: isSpeaking ?? self.isSpeaking,
            isMuted: isMuted ?? self.isMuted,
            isHandRaised: isHandRaised ?? self.isHandRaised,
            selectedReaction: selectedReaction ?? self.selectedReaction,
            isPinned: isPinned ?? self.isPinned,
            isVideoOnForMe: isVideoOnForMe ?? self.isVideoOnForMe,
            avatarColor: avatarColor ?? self.avatarColor,
            isRemoteUser: isRemoteUser ?? self.isRemoteUser,
            isWhiteBoard: isWhiteBoard ?? self.isWhiteBoard,
            userIdentifier: userIdentifier ?? self.userIdentifier,
            status: status ?? self.status,
            screenShareVideoStreamModel: screenShareVideoStreamModel ?? self.screenShareVideoStreamModel,
            cameraVideoStreamModel: cameraVideoStreamModel ?? self.cameraVideoStreamModel
        )
    }
    
    static func == (lhs: ParticipantInfoModel, rhs: ParticipantInfoModel) -> Bool {
        return lhs.displayName == rhs.displayName &&
        lhs.isSpeaking == rhs.isSpeaking &&
        lhs.isMuted == rhs.isMuted &&
        lhs.isHandRaised == rhs.isHandRaised &&
        lhs.selectedReaction == rhs.selectedReaction &&
        lhs.isPinned == rhs.isPinned &&
        lhs.isVideoOnForMe == rhs.isVideoOnForMe &&
        lhs.avatarColor == rhs.avatarColor &&  // Ensure Color is comparable
        lhs.isRemoteUser == rhs.isRemoteUser &&
        lhs.userIdentifier == rhs.userIdentifier &&
        lhs.status == rhs.status &&
        lhs.screenShareVideoStreamModel == rhs.screenShareVideoStreamModel &&
        lhs.cameraVideoStreamModel == rhs.cameraVideoStreamModel &&
        lhs.isWhiteBoard == rhs.isWhiteBoard
    }
}
