//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import Combine
import FluentUI

struct SetupView: View {
    @ObservedObject var viewModel: SetupViewModel
    let viewManager: VideoViewManager
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Orientation var orientation: UIDeviceOrientation
    let avatarManager: AvatarViewManagerProtocol

    enum LayoutConstant {
        static let spacing: CGFloat = 0
        static let spacingLarge: CGFloat = 0
        static let startCallButtonHeight: CGFloat = 52
        static let iPadLarge: CGFloat = 469.0
        static let iPadSmall: CGFloat = 375.0
        static let iPadSmallHeightWithMargin: CGFloat = iPadSmall + spacingLarge + startCallButtonHeight
        static let iPadLargeHeightWithMargin: CGFloat = iPadLarge + spacingLarge + startCallButtonHeight
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        ZStack {
            VStack(spacing: 0) {
                SetupTitleView(viewModel: viewModel)
                GeometryReader { geometry in
                    ZStack(alignment: .bottomLeading) {
                        VStack(alignment: .center,
                               spacing: getSizeClass() == .ipadScreenSize ?
                               LayoutConstant.spacingLarge : LayoutConstant.spacing) {
                            ZStack(alignment: .center) {
                                PreviewAreaView(viewModel: viewModel.previewAreaViewModel,
                                                viewManager: viewManager,
                                                avatarManager: avatarManager)
                                if viewModel.shouldShowSetupControlBarView() {
                                    SetupControlBarView(viewModel: viewModel.setupControlBarViewModel)
                                }
                            }
                            .background(Color(UIColor.compositeColor(.lightPurple)))
                            .accessibilityElement(children: .contain)
                            joinCallView
                        }
                        errorInfoView
                            .padding(.bottom, CGFloat(16))
                    }
                }
            }
            BottomDrawer(isPresented: viewModel.audioDeviceListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissAudioDevicesDrawer) {
                AudioDevicesListView(viewModel: viewModel.audioDeviceListViewModel,
                avatarManager: avatarManager)
            }
        }
    }

    var joinCallView: some View {
        Group {
            if viewModel.isJoinRequested {
                JoiningCallActivityView(viewModel: viewModel.joiningCallActivityViewModel)
            } else {
                PrimaryButton(viewModel: viewModel.joinCallButtonViewModel)
                    .frame(height: 52)
                    .accessibilityIdentifier(AccessibilityIdentifier.joinCallAccessibilityID.rawValue)
            }
        }
    }

    var errorInfoView: some View {
        VStack {
            Spacer()
            ErrorInfoView(viewModel: viewModel.errorInfoViewModel)
                .padding(EdgeInsets(top: 0,
                                    leading: 0,
                                    bottom: LayoutConstant.startCallButtonHeight + LayoutConstant.spacing,
                                    trailing: 0)
                )
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
        }
    }

    private func getSizeClass() -> ScreenSizeClassType {
        switch (widthSizeClass, heightSizeClass) {
        case (.compact, .regular):
            return .iphonePortraitScreenSize
        case (.compact, .compact),
             (.regular, .compact):
            return .iphoneLandscapeScreenSize
        default:
            return .ipadScreenSize
        }
    }
}

struct SetupTitleView: View {
    let viewHeight: CGFloat = 80
    let padding: CGFloat = 34.0
    let verticalSpacing: CGFloat = 0
    var viewModel: SetupViewModel

    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        VStack(spacing: verticalSpacing) {
            ZStack(alignment: .leading) {
                IconButton(viewModel: viewModel.dismissButtonViewModel)
                    .flipsForRightToLeftLayoutDirection(true)
                    .accessibilityIdentifier(AccessibilityIdentifier.dismissButtonAccessibilityID.rawValue)
                HStack {
                    Spacer()
                    VStack {
                        Text(viewModel.title)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(Color(UIColor.compositeColor(.headerTitle)))
                            .lineLimit(1)
                            .minimumScaleFactor(sizeCategory.isAccessibilityCategory ? 0.4 : 1)
                            .accessibilityAddTraits(.isHeader)
                            .padding(.bottom, 4)
                        if let subtitle = viewModel.subTitle, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(UIColor.compositeColor(.headerTitle)))
                                .lineLimit(1)
                                .minimumScaleFactor(sizeCategory.isAccessibilityCategory ? 0.4 : 1)
                                .accessibilityAddTraits(.isHeader)
                        }
                    }
                    Spacer()
                }.accessibilitySortPriority(1)
            }.frame(height: viewHeight)
        }
    }
}
