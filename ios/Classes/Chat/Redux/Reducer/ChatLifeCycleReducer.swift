//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

extension Reducer where State == ChatLifeCycleState,
                        Actions == ActionChat {
    static var liveLifecycleReducer: Self = Reducer { appLifeCycleCurrentState, action in
        var currentStatus = appLifeCycleCurrentState.currentStatus
        switch action {
        case .lifecycleAction(.foregroundEntered):
            currentStatus = .foreground
        case .lifecycleAction(.backgroundEntered):
            currentStatus = .background
        default:
            break
        }
        return ChatLifeCycleState(currentStatus: currentStatus)
    }
}
