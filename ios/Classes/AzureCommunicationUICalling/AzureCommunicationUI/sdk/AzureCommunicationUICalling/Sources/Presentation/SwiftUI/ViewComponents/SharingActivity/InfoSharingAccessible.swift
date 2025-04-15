//
//  InfoSharingAccessible.swift
//  Pods
//
//  Created by Yriy Malyts on 15.04.2025.
//

protocol InfoSharingAccessible {
    var accessibilityProvider: AccessibilityProviderProtocol { get }
    var dismissDrawer: () -> Void { get }
    
    func getShareInfo() -> String
}
