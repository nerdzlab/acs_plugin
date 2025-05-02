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
    let shareLink: String

    init(accessibilityProvider: AccessibilityProviderProtocol,
         debugInfoManager: DebugInfoManagerProtocol,
         shareLink: String,
         dismissDrawer: @escaping () -> Void) {
        self.accessibilityProvider = accessibilityProvider
        self.debugInfoManager = debugInfoManager
        self.shareLink = shareLink
        self.dismissDrawer = dismissDrawer
    }

    func getShareInfo() -> String {
        return shareLink
    }
}
