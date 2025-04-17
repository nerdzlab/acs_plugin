//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct IconWithLabelButton<T: ButtonState>: View {
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    @ObservedObject var viewModel: IconWithLabelButtonViewModel<T>

    let iconImageSize: CGFloat = 25
    let verticalSpacing: CGFloat = 8
    let width: CGFloat = 85
    let height: CGFloat = 85
    let buttonDisabledColor = Color(StyleProvider.color.disableColor)

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Button(action: viewModel.action) {
            VStack(alignment: .center, spacing: verticalSpacing) {
                Icon(name: viewModel.iconName, size: iconImageSize, renderAsOriginal: false)
                    .accessibilityHidden(true)
                if let buttonLabel = viewModel.buttonLabel {
                    if sizeCategory >= ContentSizeCategory.accessibilityMedium {
                        Text(buttonLabel)
                            .font(Fonts.button2Accessibility.font)
                    } else {
                        Text(buttonLabel)
                            .font(Fonts.button2.font)
                    }
                }
            }
        }
        .disabled(viewModel.isDisabled)
        .foregroundColor(viewModel.isDisabled ? buttonDisabledColor : viewModel.buttonColor)
        .frame(width: width, height: height, alignment: .top)
        .accessibilityLabel(Text(viewModel.accessibilityLabel ?? ""))
        .accessibilityValue(Text(viewModel.accessibilityValue ?? ""))
        .accessibilityHint(Text(viewModel.accessibilityHint ?? ""))
    }
}
