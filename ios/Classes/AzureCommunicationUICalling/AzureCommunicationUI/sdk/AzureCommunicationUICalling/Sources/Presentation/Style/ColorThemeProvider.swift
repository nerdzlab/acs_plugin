//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import FluentUI
import UIKit

class ColorThemeProvider {
    let colorSchemeOverride: UIUserInterfaceStyle

    let primaryColor: UIColor
    let primaryColorTint10: UIColor
    let primaryColorTint20: UIColor
    let primaryColorTint30: UIColor
    /* <CUSTOM_COLOR_FEATURE> */
    let foregroundOnPrimaryColor: UIColor
    /* </CUSTOM_COLOR_FEATURE> */
    // MARK: Text Label Colours
    let textSecondary: UIColor = Colors.textSecondary

    let onWarning: UIColor = Colors.Palette.warningShade30.color
    let onHoldBackground = UIColor.compositeColor(.onHoldBackground)
    let onError: UIColor = Colors.surfacePrimary
    let onPrimary: UIColor = Colors.surfacePrimary
    let onSuccess: UIColor = Colors.surfacePrimary
    let onSurface: UIColor = Colors.Palette.gray950.color
    let onBackground: UIColor = Colors.Palette.gray950.color
    let onSurfaceColor: UIColor = Colors.Palette.gray950.color
    let onNavigationSecondary: UIColor = Colors.textSecondary

    // MARK: - Button Icon Colours
    let hangup = UIColor.compositeColor(.hangup)
    let disableColor: UIColor = Colors.iconDisabled
    let drawerIconDark: UIColor = Colors.iconSecondary

    // MARK: - View Background Colours
    let error: UIColor = Colors.error
    let success: UIColor = Colors.Palette.successPrimary.color
    let warning: UIColor = Colors.Palette.warningTint40.color
    let overlay = UIColor.compositeColor(.overlay)
    let gridLayoutBackground: UIColor = Colors.surfacePrimary
    let gradientColor = UIColor.black.withAlphaComponent(0.7)
    let surfaceDarkColor = UIColor.black.withAlphaComponent(0.6)
    let surfaceLightColor = UIColor.black.withAlphaComponent(0.3)
    let backgroundColor: UIColor = Colors.surfacePrimary
    let drawerColor: UIColor = Colors.surfacePrimary
    let popoverColor: UIColor = Colors.surfacePrimary
    let surface: UIColor = Colors.surfaceQuaternary
    
    init(themeOptions: ThemeOptions?) {
        self.colorSchemeOverride = themeOptions?.colorSchemeOverride ?? .light

        self.primaryColor = themeOptions?.primaryColor ?? Colors.Palette.communicationBlue.color
        self.primaryColorTint10 = themeOptions?.primaryColorTint10 ?? Colors.Palette.communicationBlueTint10.color
        self.primaryColorTint20 = themeOptions?.primaryColorTint20 ?? Colors.Palette.communicationBlueTint20.color
        self.primaryColorTint30 = themeOptions?.primaryColorTint30 ?? Colors.Palette.communicationBlueTint30.color
        /* <CUSTOM_COLOR_FEATURE> */
        self.foregroundOnPrimaryColor = themeOptions?.foregroundOnPrimaryColor ?? .orange
        /* </CUSTOM_COLOR_FEATURE> */
    }
}

extension ColorThemeProvider: ColorProviding {
    func primaryColor(for window: UIWindow) -> UIColor? {
        return primaryColor
    }
    /* <CUSTOM_COLOR_FEATURE> */
    func foregroundOnPrimaryColor(for window: UIWindow) -> UIColor? {
        return foregroundOnPrimaryColor
    }
    /* </CUSTOM_COLOR_FEATURE> */
    func primaryTint10Color(for window: UIWindow) -> UIColor? {
        return primaryColorTint10
    }

    func primaryTint20Color(for window: UIWindow) -> UIColor? {
        return primaryColorTint20
    }

    func primaryTint30Color(for window: UIWindow) -> UIColor? {
        return primaryColorTint30
    }

    func primaryTint40Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryShade10Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryShade20Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }

    func primaryShade30Color(for window: UIWindow) -> UIColor? {
        return primaryColor
    }
}
