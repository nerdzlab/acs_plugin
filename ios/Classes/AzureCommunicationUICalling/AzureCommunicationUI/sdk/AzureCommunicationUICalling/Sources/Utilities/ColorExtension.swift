//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import UIKit

enum CompositeColor: String {
    case hangup = "hangupColor"
    case overlay = "overlayColor"
    case onHoldBackground = "onHoldBackground"
    case textPrimary = "#393939"
    case purpleBlue = "purpleBlue"
    case lightPurple = "lightPurple"
    case darkPurple = "darkPurple"
    case filledFill = "filledFill"
    case filledBorder = "filledBorder"
    case errorColor = "errorColor"
}

extension UIColor {
    static func compositeColor(_ name: CompositeColor) -> UIColor {
        return getAssetsColor(named: name.rawValue)
    }

    private static func getAssetsColor(named: String) -> UIColor {
        if let assetsColor = UIColor(named: "Color/" + named,
                                     in: Bundle(for: CallComposite.self),
                                     compatibleWith: nil) {
            return assetsColor
        } else {
            preconditionFailure("invalid asset color")
        }
    }
}
