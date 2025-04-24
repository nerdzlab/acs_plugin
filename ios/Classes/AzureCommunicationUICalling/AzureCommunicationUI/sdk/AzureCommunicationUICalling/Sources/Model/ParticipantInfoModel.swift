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

struct ReactionPayload: Codable {
    let reaction: ReactionType
    var receivedOn: Date?
}

typealias ReactionMessage = [String: ReactionPayload]

struct ParticipantInfoModel: Hashable, Equatable {
    let displayName: String
    let isSpeaking: Bool
    let isMuted: Bool
    let isHandRaised: Bool
    var selectedReaction: ReactionType?
    
    let isPinned: Bool
    let isVideoOnForMe: Bool
    let avatarColor: Color
    
    let isRemoteUser: Bool
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
        selectedReaction: ReactionType? = nil
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
            userIdentifier: userIdentifier ?? self.userIdentifier,
            status: status ?? self.status,
            screenShareVideoStreamModel: screenShareVideoStreamModel ?? self.screenShareVideoStreamModel,
            cameraVideoStreamModel: cameraVideoStreamModel ?? self.cameraVideoStreamModel
        )
    }
}
