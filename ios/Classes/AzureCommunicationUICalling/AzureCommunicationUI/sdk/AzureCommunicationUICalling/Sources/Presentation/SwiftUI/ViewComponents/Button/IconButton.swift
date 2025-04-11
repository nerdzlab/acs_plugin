//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct IconButton: View {
    @ObservedObject var viewModel: IconButtonViewModel
    
    private let buttonDisabledColor = Color(StyleProvider.color.disableColor)
    private var iconImageSize: CGFloat {
        switch viewModel.buttonType {
        case .dismissButton:
            return 16
        case .roundedRectButton:
            return 24
        case .cameraSwitchButtonPip:
            return 28
        default:
            return 32
        }
    }
    var width: CGFloat {
        switch viewModel.buttonType {
        case  .roundedRectButton:
            return 59
        case .controlButton,
                .backNavigation:
            return 60
        case .infoButton:
            return iconImageSize
        case .dismissButton:
            return 32
        case .cameraSwitchButtonFull:
            return 32
        case .cameraSwitchButtonPip:
            return 28
        }
    }
    var height: CGFloat {
        switch viewModel.buttonType {
        case  .roundedRectButton:
            return 56
        case .controlButton,
                .backNavigation:
            return 60
        case .infoButton:
            return iconImageSize
        case .dismissButton:
            return 32
        case .cameraSwitchButtonFull:
            return 32
        case .cameraSwitchButtonPip:
            return 28
        }
    }
    var buttonBackgroundColor: Color {
        switch viewModel.buttonType {
        case .roundedRectButton:
            return Color(UIColor.compositeColor(.errorColor))
        case .controlButton,
                .infoButton,
                .backNavigation,
                .dismissButton:
            return .clear
        case .cameraSwitchButtonFull,
                .cameraSwitchButtonPip:
            return .clear
        }
    }
    
    var buttonForegroundColor: Color {
        switch viewModel.buttonType {
        case .controlButton:
            return .red
        case .dismissButton:
            return Color(StyleProvider.color.onBackground)
        default:
            return .white
        }
    }
    
    var tappableWidth: CGFloat {
        switch viewModel.buttonType {
        case .cameraSwitchButtonFull:
            return 44
        default:
            return width
        }
    }
    
    var tappableHeight: CGFloat {
        switch viewModel.buttonType {
        case .cameraSwitchButtonFull:
            return 44
        default:
            return height
        }
    }
    
    var shapeCornerRadius: CGFloat {
        switch viewModel.buttonType {
        case .cameraSwitchButtonPip,
                .cameraSwitchButtonFull:
            return 4
        case .roundedRectButton:
            return 14
        default:
            return 8
        }
    }
    
    var roundedCorners: UIRectCorner {
        switch viewModel.buttonType {
        case .cameraSwitchButtonPip:
            return [.bottomLeft]
        default:
            return [.allCorners]
        }
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        if viewModel.isVisible {
            Group {
                Button(action: viewModel.action) {
                    icon // Unstyled image view
                }
                .disabled(viewModel.isDisabled)
                .frame(width: width, height: height, alignment: viewModel.buttonType == .backNavigation ? .top : .center)
                .background(buttonBackgroundColor) // Apply background if needed
                .clipShape(RoundedCornersShape(radius: shapeCornerRadius, corners: roundedCorners))
                .accessibilityLabel(Text(viewModel.accessibilityLabel ?? ""))
                .accessibilityValue(Text(viewModel.accessibilityValue ?? ""))
                .accessibilityHint(Text(viewModel.accessibilityHint ?? ""))
            }
            .frame(width: tappableWidth,
                   height: tappableHeight,
                   alignment: .center)
            .contentShape(Rectangle())
            .onTapGesture {
                guard !viewModel.isDisabled else {
                    return
                }
                viewModel.action()
            }
        }
    }
    
    var icon: some View {
        var icon = Icon(size: iconImageSize, renderAsOriginal: viewModel.renderAsOriginal)
        icon.contentShape(Rectangle())
        if let uiImage = viewModel.icon {
            icon.uiImage = uiImage
        }
        if let iconName = viewModel.iconName {
            icon.name = iconName
        }
        
        return icon
    }
}

struct RoundedCornersShape: Shape {
    let radius: CGFloat
    let corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
