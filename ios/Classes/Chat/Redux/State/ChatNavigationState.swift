//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum ChatNavigationStatus {
    case inChat
    case headless
    case exit
}

struct ChatNavigationState: Equatable {

    let status: ChatNavigationStatus

    init(status: ChatNavigationStatus = .inChat) {
        self.status = status
    }

    static func == (lhs: ChatNavigationState, rhs: ChatNavigationState) -> Bool {
        return lhs.status == rhs.status
    }
}
