//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

// swiftlint:disable type_body_length
// swiftlint:disable file_length
struct CallingView: View {
    enum InfoHeaderViewConstants {
        static let horizontalPadding: CGFloat = 8.0
        static let maxWidth: CGFloat = 380.0
        static let height: CGFloat = 100.0
    }
    
    enum ErrorInfoConstants {
        static let controlBarHeight: CGFloat = 92
        static let horizontalPadding: CGFloat = 8
    }
    
    enum Constants {
        static let topAlertAreaViewTopPadding: CGFloat = 0.0
    }
    
    enum DiagnosticToastInfoConstants {
        static let bottomPaddingPortrait: CGFloat = 5
        static let bottomPaddingLandscape: CGFloat = 16
    }
    
    enum CaptionsInfoConstants {
        static let maxHeight: CGFloat = 115.0
    }
    
    @ObservedObject var viewModel: CallingViewModel
    let avatarManager: AvatarViewManagerProtocol
    let viewManager: VideoViewManager
    
    @Environment(\.horizontalSizeClass) var widthSizeClass: UserInterfaceSizeClass?
    @Environment(\.verticalSizeClass) var heightSizeClass: UserInterfaceSizeClass?
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation
    @State var debugInfoSourceView = UIView()
    
    var safeAreaIgnoreArea: Edge.Set {
        return getSizeClass() != .iphoneLandscapeScreenSize ? [] : [/* .bottom */]
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Banner on top, full width, ignoring top safe area
                bannerView
                    .frame(maxWidth: .infinity)
                    .ignoresSafeArea(edges: .top)

                // Main content below banner, fills remaining space
                ZStack {
                    if getSizeClass() != .iphoneLandscapeScreenSize {
                        portraitCallingView
                    } else {
                        landscapeCallingView
                    }

                    if viewModel.isScreenSharing && !viewModel.isInPip {
                        screenSharingIndicator
                    }

                    errorInfoView
                    bottomDrawer
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .ignoresSafeArea()
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .environment(\.screenSizeClass, getSizeClass())
        .environment(\.appPhase, viewModel.appState)
        .edgesIgnoringSafeArea(safeAreaIgnoreArea)
        .onRotate { newOrientation in
            updateChildViewIfNeededWith(newOrientation: newOrientation)
        }
        .onAppear {
            resetOrientation()
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    var bottomDrawer: some View {
        ZStack {
            BottomDrawer(isPresented: viewModel.supportFormViewModel.isDisplayed,
                         hideDrawer: viewModel.supportFormViewModel.hideForm) {
                reportErrorView
                    .accessibilityElement(children: .contain)
                    .accessibilityAddTraits(.isModal)
            }
            BottomDrawer(isPresented: viewModel.moreCallOptionsListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                MoreCallOptionsListView(viewModel: viewModel.moreCallOptionsListViewModel,
                                        avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.audioDeviceListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                AudioDevicesListView(viewModel: viewModel.audioDeviceListViewModel)
            }
            BottomDrawer(isPresented: viewModel.participantActionViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                ParticipantMenuView(viewModel: viewModel.participantActionViewModel,
                                    avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.participantListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                ParticipantsListView(viewModel: viewModel.participantListViewModel,
                                     avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.captionsLanguageListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                CaptionsLanguageListView(viewModel: viewModel.captionsLanguageListViewModel,
                                         avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.captionsLanguageListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                CaptionsLanguageListView(viewModel: viewModel.captionsLanguageListViewModel,
                                         avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.captionsListViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                CaptionsListView(viewModel: viewModel.captionsListViewModel,
                                 avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.leaveCallConfirmationViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                LeaveCallConfirmationView(
                    viewModel: viewModel.leaveCallConfirmationViewModel,
                    avatarManager: avatarManager)
            }
            
            BottomDrawer(isPresented: viewModel.participantOptionsViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                ParticipantOptionsView(viewModel: viewModel.participantOptionsViewModel,
                                       avatarManager: avatarManager)
            }
            BottomDrawer(isPresented: viewModel.layoutOptionsViewModel.isDisplayed,
                         hideDrawer: viewModel.dismissDrawer) {
                LayoutOptionsView(viewModel: viewModel.layoutOptionsViewModel, avatarManager: avatarManager)
            }
            
            MeetingOptionsDrawer(isPresented: viewModel.meetingOptionsViewModel.isDisplayed,
                                 hideDrawer: viewModel.dismissDrawer) {
                MeetingOptionsView(viewModel: viewModel.meetingOptionsViewModel)
            }
        }
    }
    
    var portraitCallingView: some View {
        VStack(alignment: .center, spacing: 0) {
            containerView
                .cornerRadius(12)
                .padding(.leading, 4)
                .padding(.trailing, 4)
                .padding(.bottom, 4)
                .padding(.top, viewModel.bannerViewModel.isBannerDisplayed ? 4 : safeAreaInsets.top)
            ControlBarView(viewModel: viewModel.controlBarViewModel)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: -2)
        }
    }
    
    var landscapeCallingView: some View {
        HStack(alignment: .center, spacing: 0) {
            containerView
            ControlBarView(viewModel: viewModel.controlBarViewModel)
        }
    }
    
    var containerView: some View {
        Group {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading) {
                    GeometryReader { geometry in
                        ZStack {
                            videoGridView
                                .accessibilityHidden(!viewModel.isVideoGridViewAccessibilityAvailable)
                            if viewModel.isParticipantGridDisplayed &&
                                viewModel.allowLocalCameraPreview {
                                Group {
                                    DraggableLocalVideoView(containerBounds:
                                                                geometry.frame(in: .local),
                                                            viewModel: viewModel,
                                                            avatarManager: avatarManager,
                                                            viewManager: viewManager,
                                                            orientation: $orientation,
                                                            screenSize: getSizeClass()
                                    )
                                }
                                .accessibilityElement(children: .contain)
                                .accessibilityIdentifier(
                                    AccessibilityIdentifier.draggablePipViewAccessibilityID.rawValue)
                            }
                            bottomToastDiagnosticsView
                                .accessibilityElement(children: .contain)
                            captionsErrorView.accessibilityElement(children: .contain)
                        }.zIndex(2)
                    }
                    if viewModel.captionsInfoViewModel.isDisplayed &&
                        !viewModel.isInPip {
                        captionsInfoView
                    }
                }
                topAlertAreaView
                    .accessibilityElement(children: .contain)
                    .accessibilitySortPriority(1)
                    .accessibilityHidden(viewModel.lobbyOverlayViewModel.isDisplayed
                                         || viewModel.onHoldOverlayViewModel.isDisplayed
                                         || viewModel.loadingOverlayViewModel.isDisplayed)
                
            }
            .contentShape(Rectangle())
            .animation(.linear(duration: 0.167), value: true)
            .onTapGesture(perform: {
                viewModel.infoHeaderViewModel.toggleDisplayInfoHeaderIfNeeded()
            })
            .modifier(PopupModalView(isPresented: viewModel.lobbyOverlayViewModel.isDisplayed) {
                OverlayView(viewModel: viewModel.lobbyOverlayViewModel)
                    .accessibilityElement(children: .contain)
                    .accessibilityHidden(!viewModel.lobbyOverlayViewModel.isDisplayed)
            })
            .modifier(PopupModalView(isPresented: viewModel.loadingOverlayViewModel.isDisplayed &&
                                     !viewModel.lobbyOverlayViewModel.isDisplayed) {
                LoadingOverlayView(viewModel: viewModel.loadingOverlayViewModel)
                    .accessibilityElement(children: .contain)
                    .accessibilityHidden(!viewModel.loadingOverlayViewModel.isDisplayed)
            })
            .modifier(PopupModalView(isPresented: viewModel.onHoldOverlayViewModel.isDisplayed) {
                OverlayView(viewModel: viewModel.onHoldOverlayViewModel)
                    .accessibilityElement(children: .contain)
                    .accessibilityHidden(!viewModel.onHoldOverlayViewModel.isDisplayed)
            })
            .modifier(PopupModalView(isPresented: viewModel.isShareMeetingLinkDisplayed) {
                shareActivityView
                    .accessibilityElement(children: .contain)
                    .accessibilityAddTraits(.isModal)
            })
            .accessibilityElement(children: .contain)
        }
    }
    
    var topAlertAreaView: some View {
        GeometryReader { geometry in
            let geoWidth: CGFloat = geometry.size.width
            let isIpad = getSizeClass() == .ipadScreenSize
            let widthWithoutHorizontalPadding = geoWidth - 2 * InfoHeaderViewConstants.horizontalPadding
            let infoHeaderViewWidth = isIpad ? min(widthWithoutHorizontalPadding,
                                                   InfoHeaderViewConstants.maxWidth) : widthWithoutHorizontalPadding
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 8)
                HStack {
                    if isIpad {
                        Spacer()
                    } else {
                        EmptyView()
                    }
                    infoHeaderView
                        .frame(width: infoHeaderViewWidth, alignment: .leading)
                        .padding(.leading, InfoHeaderViewConstants.horizontalPadding)
                    Spacer()
                }.accessibilityElement(children: .contain)
                HStack {
                    if isIpad {
                        Spacer()
                    } else {
                        EmptyView()
                    }
                    lobbyWaitingHeaderView
                        .frame(width: infoHeaderViewWidth, alignment: .leading)
                        .padding(.leading, InfoHeaderViewConstants.horizontalPadding)
                    Spacer()
                }
                HStack {
                    if isIpad {
                        Spacer()
                    } else {
                        EmptyView()
                    }
                    lobbyActionErrorView
                        .frame(width: infoHeaderViewWidth, alignment: .leading)
                        .padding(.leading, InfoHeaderViewConstants.horizontalPadding)
                    Spacer()
                }
                HStack {
                    if isIpad {
                        Spacer()
                    } else {
                        EmptyView()
                    }
                    topMessageBarDiagnosticsView
                        .frame(width: infoHeaderViewWidth, alignment: .leading)
                        .padding(.leading, InfoHeaderViewConstants.horizontalPadding)
                    Spacer()
                }
            }
            .padding(.top, Constants.topAlertAreaViewTopPadding)
            .accessibilityElement(children: .contain)
        }
    }
    
    var shareActivityView: some View {
        return Group {
            SharingActivityView(viewModel: viewModel.shareMeetingLinkViewModel,
                                applicationActivities: nil,
                                sourceView: debugInfoSourceView,
                                isPresented: $viewModel.isShareMeetingLinkDisplayed)
            .edgesIgnoringSafeArea(.all)
            .modifier(LockPhoneOrientation())
        }
    }
    
    var infoHeaderView: some View {
        InfoHeaderView(viewModel: viewModel.infoHeaderViewModel,
                       avatarViewManager: avatarManager)
    }
    
    var lobbyWaitingHeaderView: some View {
        LobbyWaitingHeaderView(viewModel: viewModel.lobbyWaitingHeaderViewModel,
                               avatarViewManager: avatarManager)
    }
    
    var lobbyActionErrorView: some View {
        LobbyErrorHeaderView(viewModel: viewModel.lobbyActionErrorViewModel,
                             avatarViewManager: avatarManager)
    }
    
    var bannerView: some View {
        BannerView(viewModel: viewModel.bannerViewModel)
    }
    
    var participantGridsView: some View {
        ParticipantGridView(viewModel: viewModel.participantGridsViewModel,
                            avatarViewManager: avatarManager,
                            screenSize: getSizeClass())
        .edgesIgnoringSafeArea(safeAreaIgnoreArea)
    }
    
    var localVideoFullscreenView: some View {
        Group {
            LocalVideoView(viewModel: viewModel.localVideoViewModel,
                           viewManager: viewManager,
                           viewType: .localVideofull,
                           avatarManager: avatarManager)
            .background(Color(UIColor.compositeColor(.lightPurple)))
        }
    }
    
    var videoGridView: some View {
        Group {
            if viewModel.isParticipantGridDisplayed {
                participantGridsView
            } else {
                localVideoFullscreenView
            }
        }
    }
    
    var captionsInfoView: some View {
        return CaptionsInfoView(viewModel: viewModel.captionsInfoViewModel,
                                avatarViewManager: avatarManager)
        .frame(maxWidth: .infinity, maxHeight: CaptionsInfoConstants.maxHeight, alignment: .bottom)
        .zIndex(1)
    }
    
    var errorInfoView: some View {
        return VStack {
            Spacer()
            ErrorInfoView(viewModel: viewModel.errorInfoViewModel)
                .padding(EdgeInsets(top: 0,
                                    leading: ErrorInfoConstants.horizontalPadding,
                                    bottom: ErrorInfoConstants.controlBarHeight,
                                    trailing: ErrorInfoConstants.horizontalPadding)
                )
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isModal)
        }
    }
    
    var screenSharingIndicator: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ShareScreenIndicator(
                    buttonLabel: viewModel.localizationProvider.getLocalizedString(LocalizationKey.stopShareScreenTitle),
                    iconName: CompositeIcon.stopShareIcon,
                    paddings: ShareScreenIndicator.Paddings(horizontal: 8, vertical: 10),
                    themeOptions: ThemeColor(),
                    onTap: {
                        viewModel.requestStopScreenSharing()
                    }
                )
                    
                .frame(width: 102, height: 40)
                Spacer()
            }
            .padding(.bottom, 110)
            .accessibilityElement(children: .contain)
            .accessibilityAddTraits(.isModal)
            
        }
    }
    
    var bottomToastDiagnosticsView: some View {
        VStack {
            Spacer()
            BottomToastView(viewModel: viewModel.bottomToastViewModel)
                .padding(
                    EdgeInsets(top: 0,
                               leading: 0,
                               bottom:
                                getSizeClass() == .iphoneLandscapeScreenSize
                               ? DiagnosticToastInfoConstants.bottomPaddingLandscape
                               : DiagnosticToastInfoConstants.bottomPaddingPortrait,
                               trailing: 0)
                )
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isStaticText)
        }.frame(maxWidth: .infinity, alignment: .center)
    }
    
    var captionsErrorView: some View {
        VStack {
            Spacer()
            CaptionsErrorView(viewModel: viewModel.captionsErrorViewModel)
                .padding(
                    EdgeInsets(top: 0,
                               leading: 0,
                               bottom:
                                getSizeClass() == .iphoneLandscapeScreenSize
                               ? DiagnosticToastInfoConstants.bottomPaddingLandscape
                               : DiagnosticToastInfoConstants.bottomPaddingPortrait,
                               trailing: 0)
                )
                .accessibilityElement(children: .contain)
                .accessibilityAddTraits(.isStaticText)
        }.frame(maxWidth: .infinity, alignment: .center)
    }
    
    var topMessageBarDiagnosticsView: some View {
        VStack {
            ForEach(viewModel.callDiagnosticsViewModel.messageBarStack) { diagnosticMessageBarViewModel in
                MessageBarDiagnosticView(viewModel: diagnosticMessageBarViewModel)
                    .accessibilityElement(children: .contain)
                    .accessibilityAddTraits(.isStaticText)
            }
            Spacer()
        }
    }
    var reportErrorView: some View {
        return Group {
            SupportFormView(viewModel: viewModel.supportFormViewModel)
        }
    }
}
// swiftlint:enable type_body_length

extension CallingView {
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
    
    private func updateChildViewIfNeededWith(newOrientation: UIDeviceOrientation) {
        let areAllOrientationsSupported = SupportedOrientationsPreferenceKey.defaultValue == .all
        if newOrientation != orientation
            && newOrientation != .unknown
            && newOrientation != .faceDown
            && newOrientation != .faceUp
            && (areAllOrientationsSupported || (!areAllOrientationsSupported
                                                && newOrientation != .portraitUpsideDown)) {
            orientation = newOrientation
            if UIDevice.current.userInterfaceIdiom == .phone {
                UIViewController.attemptRotationToDeviceOrientation()
            }
        }
    }
    
    private func resetOrientation() {
        UIDevice.current.setValue(UIDevice.current.orientation.rawValue, forKey: "orientation")
        UIViewController.attemptRotationToDeviceOrientation()
    }
}
// swiftlint:enable file_length
