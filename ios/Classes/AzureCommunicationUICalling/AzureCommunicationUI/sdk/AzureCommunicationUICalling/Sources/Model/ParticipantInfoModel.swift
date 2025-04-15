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

struct ParticipantInfoModel: Hashable, Equatable {
    let displayName: String
    let isSpeaking: Bool
    let isMuted: Bool
    let isPinned: Bool
    let isVideoOnForMe: Bool
    let avatarColor: Color

    let isRemoteUser: Bool
    let userIdentifier: String
    let status: ParticipantStatus

    let screenShareVideoStreamModel: VideoStreamInfoModel?
    let cameraVideoStreamModel: VideoStreamInfoModel?
}
