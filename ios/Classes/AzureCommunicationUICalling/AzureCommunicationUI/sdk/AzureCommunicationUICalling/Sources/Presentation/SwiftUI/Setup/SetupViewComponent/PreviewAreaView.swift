//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct PreviewAreaView: View {
    @ObservedObject var viewModel: PreviewAreaViewModel
    let viewManager: VideoViewManager
    let avatarManager: AvatarViewManagerProtocol

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Group {
            if viewModel.isPermissionsDenied {
                PermissionWarningView(displayIcon: viewModel.getPermissionWarningIcon(),
                                      displayText: viewModel.getPermissionWarningText(),
                                      goToSettingsButtonViewModel: viewModel.goToSettingsButtonViewModel)
            } else {
                localVideoPreviewView
            }
        }
    }

    var localVideoPreviewView: some View {
        return LocalVideoView(viewModel: viewModel.localVideoViewModel,
                              viewManager: viewManager,
                              viewType: .preview,
                              avatarManager: avatarManager)
    }
}

struct PermissionWarningView: View {
    let displayIcon: CompositeIcon
    let displayText: String
    let goToSettingsButtonViewModel: PrimaryButtonViewModel

    private enum Constants {
        static var verticalSpacing: CGFloat = 20
        static var horizontalSpacing: CGFloat = 16
        static var iconSize: CGFloat = 50
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        GeometryReader { geometry in
            VStack(spacing: Constants.verticalSpacing) {
                Spacer()
                GeometryReader { scrollViewGeometry in
                    ScrollView {
                        VStack {
                            Icon(name: displayIcon, size: Constants.iconSize, renderAsOriginal: false)
                                .foregroundColor(Color(StyleProvider.color.onSurface))
                            Text(displayText)
                                .padding(.horizontal, Constants.horizontalSpacing)
                                .font(Fonts.subhead.font)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(StyleProvider.color.onSurface))
                            PrimaryButton(viewModel: goToSettingsButtonViewModel)
                                .accessibilityIdentifier(AccessibilityIdentifier.goToSettingsAccessibilityID.rawValue)
                                .padding()
                                .frame(height: 52)
                        }
                        .frame(width: scrollViewGeometry.size.width)
                        .frame(minHeight: scrollViewGeometry.size.height)
                    }
                    .frame(height: scrollViewGeometry.size.height - Constants.horizontalSpacing * 2)
                }
            }.frame(width: geometry.size.width,
                    height: geometry.size.height)
            .accessibilityElement(children: .contain)
        }
    }
}

struct GradientView: View {
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        let height: CGFloat = 160

        VStack {
            Spacer()
            Rectangle()
                .fill(
                    LinearGradient(gradient: Gradient(stops: [
                        Gradient.Stop(color: .black.opacity(0), location: 0.3914),
                        Gradient.Stop(color: Color(StyleProvider.color.gradientColor), location: 0.9965)
                    ]), startPoint: .top, endPoint: .bottom)
                )
                .frame(maxHeight: height)
        }
    }
}
