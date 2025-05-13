//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

extension ChatIconButtonViewModel.ButtonType {
    var iconImageSize: CGFloat {
        switch self {
        default:
            return 24
        }
    }

    var width: CGFloat {
        switch self {
        case .controlButton,
                .sendButton:
            return 40
        }
    }

    var height: CGFloat {
        switch self {
        case .controlButton,
                .sendButton:
            return 40
        }
    }

    var buttonBackgroundColor: Color {
        switch self {
        case .controlButton,
                .sendButton:
            return .clear
        }
    }

    var buttonForegroundColor: Color {
        switch self {
        case .controlButton:
            return Color(ChatStyleProvider.color.textDominant)
        case .sendButton:
            return Color(ChatStyleProvider.color.primaryColor)
        }
    }

    var tappableWidth: CGFloat {
        switch self {
        default:
            return width
        }
    }

    var tappableHeight: CGFloat {
        switch self {
        default:
            return height
        }
    }

    var shapeCornerRadius: CGFloat {
        switch self {
        default:
            return 8
        }
    }

    var roundedCorners: UIRectCorner {
        switch self {
        default:
            return [.allCorners]
        }
    }
}

struct ChatIconButton: View {
    @ObservedObject var viewModel: ChatIconButtonViewModel

    private let buttonDisabledColor = Color(ChatStyleProvider.color.iconDisabled)

    var body: some View {
        let buttonType = viewModel.buttonType
        Group {
            Button(action: viewModel.action) {
                ChatIcon(name: viewModel.iconName, size: buttonType.iconImageSize)
                    .contentShape(Rectangle())
            }
            .disabled(viewModel.isDisabled)
            .foregroundColor(viewModel.isDisabled ? buttonDisabledColor : buttonType.buttonForegroundColor)
            .frame(width: buttonType.width, height: buttonType.height, alignment: .center)
            .background(buttonType.buttonBackgroundColor)
            .clipShape(RoundedCornersShape(radius: buttonType.shapeCornerRadius, corners: buttonType.roundedCorners))
            .accessibilityLabel(Text(viewModel.accessibilityLabel ?? ""))
            .accessibilityValue(Text(viewModel.accessibilityValue ?? ""))
            .accessibilityHint(Text(viewModel.accessibilityHint ?? ""))
        }
        .frame(width: buttonType.tappableWidth,
               height: buttonType.tappableHeight,
               alignment: .center)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.action()
        }
        .disabled(viewModel.isDisabled)
    }
}
