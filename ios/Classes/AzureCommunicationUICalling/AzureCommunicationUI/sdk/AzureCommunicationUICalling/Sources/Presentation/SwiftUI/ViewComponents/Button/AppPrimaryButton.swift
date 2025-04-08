//
//  PrimaryButton 2.swift
//  Pods
//
//  Created by Yriy Malyts on 08.04.2025.
//
import SwiftUI

struct AppPrimaryButton: View {
    @ObservedObject var viewModel: AppPrimaryButtonViewModel
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        let action = Action()
        // accessibilityElement(children: .combine) is required because
        // the CompositeButton is represented as a superview with subviews
        AppCompositeButton(buttonStyle: viewModel.buttonStyle, buttonLabel: viewModel.buttonLabel, iconName: viewModel.iconName, paddings: viewModel.paddings, themeOptions: viewModel.themeOptions) {
            $0.addTarget(action, action: #selector(Action.perform(sender:)), for: .touchUpInside)
            action.action = {
                viewModel.action()
            }
        }
        .onTapGesture(perform: viewModel.action)
        .disabled(viewModel.isDisabled)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(viewModel.accessibilityLabel ?? viewModel.buttonLabel))
        .accessibilityAddTraits(.isButton)
    }
    
    class Action: NSObject {
        var action: (() -> Void)?
        @objc func perform(sender: Any?) {
            action?()
        }
    }
}
