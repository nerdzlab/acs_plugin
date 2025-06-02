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
    
    @StateObject private var keyboard = KeyboardResponder()
    @State var updatedDisplayName: String = ""
    
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
                            ZStack(alignment: .bottom) {
                                PreviewAreaView(
                                    viewModel: viewModel.previewAreaViewModel,
                                    viewManager: viewManager,
                                    avatarManager: avatarManager
                                )
                                .background(Color(UIColor.compositeColor(.lightPurple)))
                                .accessibilityElement(children: .contain)
                                .padding(.bottom, 120)
                                .onTapGesture {
                                    self.endEditing()
                                }
                                
                                Group {
                                    VStack(alignment: .trailing, spacing: 0) {
                                        if viewModel.shouldShowSetupControlBarView() {
                                            SetupControlBarView(viewModel: viewModel.setupControlBarViewModel)
                                        }
                                        
                                        HStack(alignment: .top, spacing: 12) {
                                            if !viewModel.isJoinRequested {
                                                TextField(viewModel.textFieldPLaceholder, text: $updatedDisplayName)
                                                    .padding(.horizontal, 12)
                                                    .font(AppFont.CircularStd.book.font(size: 16))
                                                    .frame(height: 44)
                                                    .background(Color(UIColor.compositeColor(.filledFill)))
                                                    .cornerRadius(8)
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 8)
                                                            .stroke(Color(UIColor.compositeColor(.filledBorder)), lineWidth: 1)
                                                    )
                                                    .textContentType(.name)
                                                    .keyboardType(.alphabet)
                                                    .disableAutocorrection(true)
                                                    .onChange(of: updatedDisplayName) { newValue in
                                                        viewModel.updatedDisplayName = newValue
                                                    }
                                            }
                                            joinCallView
                                        }
                                        .padding(.bottom, 34)
                                    }
                                    .frame(height: 130)
                                    .padding(.horizontal, 16)
                                    .padding(.top, 16)
                                }
                                .background(Color.white)
                                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                                .shadow(color: .black.opacity(0.05), radius: 1, y: -2)
                                .offset(y: -keyboard.currentHeight)
                            }
                    
                            
                        }
                        errorInfoView
                            .padding(.bottom, CGFloat(16))
                    }
                }
            }
            BottomDrawer(isPresented: viewModel.audioDeviceListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                AudioDevicesListView(viewModel: viewModel.audioDeviceListViewModel)
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    var joinCallView: some View {
        Group {
            if viewModel.isJoinRequested {
                JoiningCallActivityView(viewModel: viewModel.joiningCallActivityViewModel)
            } else {
                AppPrimaryButton(viewModel: viewModel.joinCallButtonViewModel)
                    .frame(width: 128, height: 40)
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
    
    private func endEditing() {
        UIApplication.shared.endEditing()
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
                            .font(AppFont.CircularStd.bold.font(size: 24))
                            .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                            .lineLimit(1)
                            .minimumScaleFactor(sizeCategory.isAccessibilityCategory ? 0.4 : 1)
                            .accessibilityAddTraits(.isHeader)
                            .padding(.bottom, 4)
                        if let subtitle = viewModel.subTitle, !subtitle.isEmpty {
                            Text(subtitle)
                                .font(AppFont.CircularStd.book.font(size: 16))
                                .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
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


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
