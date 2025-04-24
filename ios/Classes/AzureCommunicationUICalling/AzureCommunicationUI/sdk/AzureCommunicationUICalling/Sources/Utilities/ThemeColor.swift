//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import UIKit
import FluentUI

class ThemeColor: ThemeOptions {
    var colorSchemeOverride: UIUserInterfaceStyle {
        return .unspecified
    }
    var primaryColor: UIColor {
        return UIColor.compositeColor(.purpleBlue)
    }
    
    var primaryShadowColor: UIColor {
        return UIColor.compositeColor(.darkPurple)
    }
    
    var primaryColorTint10: UIColor {
        return Colors.Palette.communicationBlueTint10.color
    }
    var primaryColorTint20: UIColor {
        return Colors.Palette.communicationBlueTint20.color
    }
    var primaryColorTint30: UIColor {
        return Colors.Palette.communicationBlueTint30.color
    }
    /* <CUSTOM_COLOR_FEATURE> */
    var foregroundOnPrimaryColor: UIColor {
        return UIColor.init(dynamicColor: Colors.surfacePrimary.dynamicColor!)
    }
}
