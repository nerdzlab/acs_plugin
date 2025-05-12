//
//  ShareButton.swift
//  Pods
//
//  Created by Yriy Malyts on 09.05.2025.
//
import SwiftUI
import UIKit

struct ShareScreenIndicator: UIViewRepresentable {
    struct Paddings {
        let horizontal: CGFloat
        let vertical: CGFloat
    }
    
    let buttonLabel: String
    let iconName: CompositeIcon?
    let paddings: Paddings?
    let themeOptions: ThemeOptions
    let onTap: (() -> Void)
    
    init(
        buttonLabel: String,
        iconName: CompositeIcon? = nil,
        paddings: Paddings? = nil,
        themeOptions: ThemeOptions,
        onTap: @escaping (() -> Void)
    ) {
        self.buttonLabel = buttonLabel
        self.iconName = iconName
        self.paddings = paddings
        self.themeOptions = themeOptions
        self.onTap = onTap
    }
    
    func makeUIView(context: Context) -> UIButton {
        let button = createButton(label: buttonLabel,
                                  paddings: paddings,
                                  themeOptions: themeOptions,
                                  iconName: iconName)
        button.addTarget(context.coordinator, action: #selector(Coordinator.handleTap), for: .touchUpInside)
        return button
    }
    
    func updateUIView(_ button: UIButton, context: Context) {
    }
    
    func createButton(
        label: String,
        paddings: Paddings?,
        themeOptions: ThemeOptions,
        iconName: CompositeIcon? = nil
    ) -> UIButton {
        let button = UIButton(type: .system)
        
        // Set title
        button.setTitle(label, for: .normal)
        button.setTitleColor(themeOptions.primaryColor, for: .normal)
        button.titleLabel?.font = AppFont.CircularStd.bold.uiFont(size: 16)
        
        // Background and border
        button.backgroundColor = .white
        button.layer.borderColor = themeOptions.primaryColor.cgColor
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 9
        
        // Shadow
        button.layer.shadowColor = themeOptions.primaryShadowColor.cgColor
        button.layer.shadowOpacity = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 0
        button.layer.masksToBounds = false
        
        // Add icon if provided
        if let iconName = iconName,
           let originalImage = StyleProvider.icon.getUIImage(for: iconName)?.withRenderingMode(.alwaysTemplate) {
            
            // Resize image
            let targetSize = CGSize(width: 20, height: 20)
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
            originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            button.setImage(resizedImage, for: .normal)
            button.tintColor = themeOptions.primaryColor
            
            // Position image on the right
            button.semanticContentAttribute = .forceLeftToRight
            button.contentHorizontalAlignment = .center
            
            button.imageEdgeInsets = UIEdgeInsets(
                top: 1,
                left: (button.titleLabel?.intrinsicContentSize.width ?? 0) + 4,
                bottom: 1,
                right: -((button.titleLabel?.intrinsicContentSize.width ?? 0) + 8)
            )
            
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -25, bottom: 0, right: 20)
        }
        
        // Padding
        if let paddings = paddings {
            button.contentEdgeInsets = UIEdgeInsets(top: paddings.vertical, left: paddings.horizontal, bottom: paddings.vertical, right: paddings.horizontal)
        }
        
        return button
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onTap: onTap)
    }
    
    class Coordinator {
        let onTap: (() -> Void)?
        
        init(onTap: (() -> Void)?) {
            self.onTap = onTap
        }
        
        @objc func handleTap() {
            onTap?()
        }
    }
}



