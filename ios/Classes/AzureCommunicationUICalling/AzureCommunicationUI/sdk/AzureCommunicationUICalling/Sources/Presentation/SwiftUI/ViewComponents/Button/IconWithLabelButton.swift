//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct IconWithLabelButton<T: ButtonState>: View {
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    @ObservedObject var viewModel: IconWithLabelButtonViewModel<T>

    let iconImageSize: CGFloat = 26
    let verticalSpacing: CGFloat = 8
    let width: CGFloat = 88
    let height: CGFloat = 78
    let buttonDisabledColor = Color(StyleProvider.color.disableColor)

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Button(action: viewModel.action) {
            VStack(alignment: .center, spacing: verticalSpacing) {
                Icon(name: viewModel.iconName, size: iconImageSize, renderAsOriginal: false)
                    .foregroundColor(viewModel.isDisabled ? buttonDisabledColor : viewModel.buttonColor)
                    .accessibilityHidden(true)
                if let buttonLabel = viewModel.buttonLabel {
                    if sizeCategory >= ContentSizeCategory.accessibilityMedium {
                        Text(buttonLabel)
                            .font(Fonts.button2Accessibility.font)
                            .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                    } else {
                        Text(buttonLabel)
                            .font(AppFont.CircularStd.book.font(size: 15))
                            .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                            .lineLimit(1)
                    }
                }
            }
        }
        .disabled(viewModel.isDisabled)
        .frame(width: width, height: height, alignment: .center)
        .accessibilityLabel(Text(viewModel.accessibilityLabel ?? ""))
        .accessibilityValue(Text(viewModel.accessibilityValue ?? ""))
        .accessibilityHint(Text(viewModel.accessibilityHint ?? ""))
    }
}
