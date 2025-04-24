//
//  DebugInfoSharingActivityViewModel 2.swift
//  Pods
//
//  Created by Yriy Malyts on 15.04.2025.
//


class ShareMeetingInfoActivityViewModel: InfoSharingAccessible {
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
        return "www.google.com"
    }
}
