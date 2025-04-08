//
//  PrimaryCompositeButton.swift
//  Pods
//
//  Created by Yriy Malyts on 08.04.2025.
//

import SwiftUI
import UIKit

struct AppCompositeButton: UIViewRepresentable {
    struct Paddings {
        let horizontal: CGFloat
        let vertical: CGFloat
    }
    
    enum ButtonStyleType {
        case primaryFilled
        case primaryOutline
        case borderless
        // Add other style types as needed
    }
    
    let buttonStyle: ButtonStyleType
    let buttonLabel: String
    let iconName: CompositeIcon?
    let paddings: Paddings?
    let themeOptions: ThemeOptions
    var update: (UIButton, Context) -> Void
    
    init(
    buttonStyle: ButtonStyleType,
    buttonLabel: String,
    iconName: CompositeIcon? = nil,
    paddings: Paddings? = nil,
    themeOptions: ThemeOptions,
    updater update: @escaping (UIButton) -> Void)
    {
        self.buttonStyle = buttonStyle
        self.buttonLabel = buttonLabel
        self.iconName = iconName
        self.paddings = paddings
        self.themeOptions = themeOptions
        self.update = { view, _ in update(view) }
    }
    
    private func getBackgroundColor() -> Color {
        switch buttonStyle {
        case .primaryFilled:
            return Color(uiColor: themeOptions.primaryColor)
        case .primaryOutline, .borderless:
            return Color.clear
        }
    }
    
    private func getForegroundColor() -> Color {
        switch buttonStyle {
        case .primaryFilled:
            return Color(uiColor: themeOptions.foregroundOnPrimaryColor)
        case .primaryOutline, .borderless:
            return Color(uiColor:  themeOptions.primaryColor)
        }
    }
    
    private func getBorderColor() -> Color {
        switch buttonStyle {
        case .primaryOutline:
            return Color(uiColor: themeOptions.primaryColor)
        case .primaryFilled, .borderless:
            return Color.clear
        }
    }
    
    private func getBorderWidth() -> CGFloat {
        switch buttonStyle {
        case .primaryOutline:
            return 1
        case .primaryFilled, .borderless:
            return 0
        }
    }
    
    func makeUIView(context: Context) -> UIButton {
        return createButton(style: buttonStyle,
                            label: buttonLabel,
                            paddings: paddings,
                            themeOptions: themeOptions,
                            iconName: iconName)
    }
    
    func updateUIView(_ button: UIButton, context: Context) {
        update(button, context)
    }
    
    func createButton(
        style: ButtonStyleType,
        label: String,
        paddings: Paddings?,
        themeOptions: ThemeOptions,
        iconName: CompositeIcon? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        
        // Set button title
        button.setTitle(label, for: .normal)
        
        // Set background color
        switch style {
        case .primaryFilled:
            button.backgroundColor = themeOptions.primaryColor
            button.setTitleColor(themeOptions.foregroundOnPrimaryColor, for: .normal)
            // Add bottom-only, no-blur shadow
            button.layer.shadowColor = themeOptions.primaryShadowColor.cgColor
            button.layer.shadowOpacity = 1
            button.layer.shadowOffset = CGSize(width: 0, height: 4) // Pushes shadow down
            button.layer.shadowRadius = 0 // No blur
            button.layer.masksToBounds = false
        case .primaryOutline:
            button.backgroundColor = .clear
            button.setTitleColor(themeOptions.primaryColor, for: .normal)
            button.layer.borderColor = themeOptions.primaryColor.cgColor
            button.layer.borderWidth = 1.0
        case .borderless:
            button.backgroundColor = .clear
            button.setTitleColor(themeOptions.primaryColor, for: .normal)
        }
        
        // Set corner radius
        button.layer.cornerRadius = 9
        
        if let paddings = paddings {
            var configuration = button.configuration ?? UIButton.Configuration.plain() // Or any other style you are using
            configuration.contentInsets = NSDirectionalEdgeInsets(top: paddings.vertical,
                                                                  leading: paddings.horizontal,
                                                                  bottom: paddings.vertical,
                                                                  trailing: paddings.horizontal)
            button.configuration = configuration
        }
        
        if let iconName = iconName {
            /* <CUSTOM_COLOR_FEATURE> */
            let icon = StyleProvider.icon.getUIImage(for: iconName)?.withRenderingMode(.alwaysTemplate)
            button.setImage(icon, for: .normal)
            button.tintColor = themeOptions.foregroundOnPrimaryColor
            /* </CUSTOM_COLOR_FEATURE> */
        }
        
        return button
    }
}

