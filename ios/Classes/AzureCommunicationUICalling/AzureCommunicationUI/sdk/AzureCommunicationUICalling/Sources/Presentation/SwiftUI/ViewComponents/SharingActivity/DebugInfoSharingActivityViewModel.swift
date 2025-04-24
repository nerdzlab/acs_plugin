//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

class DebugInfoSharingActivityViewModel: InfoSharingAccessible {
    let accessibilityProvider: AccessibilityProviderProtocol
    let debugInfoManager: DebugInfoManagerProtocol
    let dismissDrawer: () -> Void

    init(accessibilityProvider: AccessibilityProviderProtocol,
         debugInfoManager: DebugInfoManagerProtocol,
         dismissDrawer: @escaping () -> Void) {
        self.accessibilityProvider = accessibilityProvider
        self.debugInfoManager = debugInfoManager
        self.dismissDrawer = dismissDrawer
    }

    func getShareInfo() -> String {
        let debugInfo = debugInfoManager.getDebugInfo()
        let callId = debugInfo.callHistoryRecords.last?.callIds.last ??
            StringConstants.defaultCallIdDebugInfoValue
        return "\(StringConstants.callIdDebugInfoTitle) \"\(callId)\""
    }
}
