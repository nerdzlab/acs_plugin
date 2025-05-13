//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AzureCore
import AzureCommunicationChat

extension ChatParticipant {
    func toParticipantInfoModel(_ localParticipantId: String) -> ChatParticipantInfoModel {
        return ChatParticipantInfoModel(
            identifier: self.id,
            displayName: self.displayName ?? "Unknown user",
            isLocalParticipant: id.stringValue == localParticipantId,
            sharedHistoryTime: self.shareHistoryTime ?? Iso8601Date())
    }
}

extension SignalingChatParticipant {
    func toParticipantInfoModel(_ localParticipantId: String) -> ChatParticipantInfoModel {
        return ChatParticipantInfoModel(
            identifier: self.id!,
            displayName: self.displayName ?? "Unknown user",
            isLocalParticipant: id?.rawId == localParticipantId,
            sharedHistoryTime: self.shareHistoryTime ?? Iso8601Date())
    }
}
