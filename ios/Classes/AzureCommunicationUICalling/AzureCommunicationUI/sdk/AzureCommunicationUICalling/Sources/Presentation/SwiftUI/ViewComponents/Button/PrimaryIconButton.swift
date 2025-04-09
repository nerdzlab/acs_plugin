//
//  IconWithLabelButton 2.swift
//  Pods
//
//  Created by Yriy Malyts on 08.04.2025.
//


//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct PrimaryIconButton<T: PrimaryButtonState>: View {
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    @ObservedObject var viewModel: PrimaryIconButtonViewModel<T>

    let iconImageSize: CGFloat = 32
    let verticalSpacing: CGFloat = 8
    let width: CGFloat = 32
    let height: CGFloat = 32
    var buttonDisabledColor = Color(UIColor.compositeColor(.purpleBlue).withAlphaComponent(0.3))

    var buttonForegroundColor: Color {
        return Color(UIColor.compositeColor(.purpleBlue))
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Button(action: viewModel.action) {
            VStack(alignment: .center) {
                Icon(name: viewModel.iconName, size: iconImageSize, renderAsOriginal: false)
                    .accessibilityHidden(true)
            }
        }
        .disabled(viewModel.isDisabled)
        .foregroundColor(viewModel.isDisabled ? buttonDisabledColor : buttonForegroundColor)
        .frame(width: width, height: height, alignment: .top)
        .accessibilityLabel(Text(viewModel.accessibilityLabel ?? ""))
        .accessibilityValue(Text(viewModel.accessibilityValue ?? ""))
        .accessibilityHint(Text(viewModel.accessibilityHint ?? ""))
    }
}
