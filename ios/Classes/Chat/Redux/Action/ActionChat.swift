//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

///
/// Action for the entire library. All actions are defined here as a heirarchy of enum types
///
enum ActionChat: Equatable {
    case lifecycleAction(ChatLifecycleAction)
    case chatAction(ChatAction)
    case participantsAction(ParticipantsAction)
    case repositoryAction(ChatRepositoryAction)
    case errorAction(ChatErrorAction)

    case compositeExitAction
    case chatViewLaunched
    case chatViewHeadless
}
