//
//  Locale+resolve.swift
//  acs_plugin
//
//  Created by Yriy Malyts on 03.06.2025.
//

import Foundation

extension Locale {
    static func resolveLocale(from langCode: String) -> Locale {
        switch langCode.lowercased() {
        case "nl":
            return Locale(identifier: "nl-NL")
        default:
            return Locale(identifier: langCode)
        }
    }
}
