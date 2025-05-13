//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum ChatAppStatus {
    case foreground
    case background
}

struct ChatLifeCycleState {

    let currentStatus: ChatAppStatus

    init(currentStatus: ChatAppStatus = .foreground) {
        self.currentStatus = currentStatus
    }
}
