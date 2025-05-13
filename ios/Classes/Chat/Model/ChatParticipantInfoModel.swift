//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AzureCore
import AzureCommunicationCommon
import AzureCommunicationChat

struct ChatParticipantInfoModel: BaseInfoModel, Equatable {
    // String id work-around until rawId is implemented
    let id: String
    let identifier: CommunicationIdentifier
    let displayName: String
    let sharedHistoryTime: Iso8601Date?
    let isLocalParticipant: Bool

    init(identifier: CommunicationIdentifier,
         displayName: String,
         isLocalParticipant: Bool = false,
         sharedHistoryTime: Iso8601Date? = nil) {
        self.id = identifier.stringValue
        self.identifier = identifier
        self.displayName = displayName
        self.isLocalParticipant = isLocalParticipant
        self.sharedHistoryTime = sharedHistoryTime
    }

    static func == (lhs: ChatParticipantInfoModel, rhs: ChatParticipantInfoModel) -> Bool {
        return lhs.id == rhs.id
    }
}
