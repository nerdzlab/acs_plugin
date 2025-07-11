//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

enum LocalVideoViewType {
    case preview
    case localVideoPip
    case localVideofull
    case systemLocalVideoPip
    case effectsPreview
    
    var cameraSwitchButtonAlignment: Alignment {
        switch self {
        case .localVideoPip:
            return .topTrailing
        case .localVideofull, .systemLocalVideoPip, .effectsPreview:
            return .bottomTrailing
        case .preview:
            return .trailing
        }
    }
    
    var avatarSize: CGFloat {
        switch self {
        case .localVideofull,
                .preview, .effectsPreview:
            return 80
        case .systemLocalVideoPip:
            return 24
        case .localVideoPip:
            return 48
        }
    }
    
    var initialFontSize: CGFloat {
        switch self {
        case .localVideofull,
                .preview, .effectsPreview:
            return 32
        case .systemLocalVideoPip:
            return 8
        case .localVideoPip:
            return 20
        }
    }
    
    var showDisplayNameTitleView: Bool {
        switch self {
        case .localVideoPip,
                .preview, .effectsPreview:
            return false
        case .systemLocalVideoPip:
            return false
        case .localVideofull:
            return true
        }
    }
    
    var hasGradient: Bool {
        switch self {
        case .localVideoPip, .systemLocalVideoPip,
                .localVideofull, .effectsPreview:
            return false
        case .preview:
            return true
        }
    }
    
}

struct LocalVideoView: View {
    @ObservedObject var viewModel: LocalVideoViewModel
    let viewManager: VideoViewManager
    let viewType: LocalVideoViewType
    let avatarManager: AvatarViewManagerProtocol
    @Environment(\.screenSizeClass) var screenSizeClass: ScreenSizeClassType
    
    @State private var avatarImage: UIImage?
    @State private var localVideoStreamId: String?
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Group {
            GeometryReader { geometry in
                ZStack(alignment: .bottomLeading) {
                    
                    // MARK: - Main content depending on camera status
                    if viewModel.cameraOperationalStatus == .on,
                       let streamId = localVideoStreamId,
                       let rendererView = viewManager.getLocalVideoRendererView(streamId) {
                        
                        avatarView
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                            .accessibilityElement(children: .combine)
                        
                        ZStack(alignment: viewType.cameraSwitchButtonAlignment) {
                            VideoRendererView(rendererView: rendererView)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height)
                            
                            if !viewModel.isInPip || viewType != .effectsPreview {
                                cameraSwitchButton
                            }
                        }
                        
                    } else {
                        avatarView
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                            .accessibilityElement(children: .combine)
                    }
                    
                    // MARK: - Always show title in bottom leading
                    if viewType.showDisplayNameTitleView {
                        ParticipantTitleView(
                            displayName: Binding.constant(
                                viewModel.localizationProvider.getLocalizedString(
                                    .localeParticipantWithSuffix,
                                    viewModel.displayName ?? ""
                                )
                            ),
                            isMuted: $viewModel.isMuted,
                            isHold: .constant(false),
                            isHandRaised: .constant(false),
                            isPinned: .constant(false),
                            titleFont: AppFont.CircularStd.book.font(size: 13),
                            mutedIconSize: 16,
                            isWhiteBoard: false
                        )
                        .padding(.vertical, 2)
                        .background(viewModel.cameraOperationalStatus == .on ? Color.white : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding([.leading, .bottom], 8)
                    }
                    
                    if let reaction = viewModel.selectedReaction {
                        ReactionOverlayView(selectedReaction: reaction)
                            .frame(width: geometry.size.width,
                                   height: geometry.size.height)
                    }
                }
            }
            
        }.onReceive(viewModel.$localVideoStreamId) {
            viewManager.updateDisplayedLocalVideoStream($0)
            if localVideoStreamId != $0 {
                localVideoStreamId = $0
            }
            
        }.accessibilityIgnoresInvertColors(true)
    }
    
    var avatarView: some View {
        VStack(alignment: .center, spacing: 5) {
            CompositeAvatar(
                displayName: $viewModel.displayName,
                avatarImage: Binding.constant(
                    avatarManager.localParticipantViewData?.avatarImage
                ),
                backgroundColor: Color(UIColor.compositeColor(.purpleBlue)),
                isSpeaking: false,
                avatarSize:  (viewModel.isInPip && viewType == .localVideofull) ? 50 : viewType.avatarSize,
                fontSize: (viewModel.isInPip && viewType == .localVideofull) ? 24 : viewType.initialFontSize
            )
        }
    }
    
    var cameraSwitchButton: some View {
        let cameraSwitchButtonPaddingPip: CGFloat = 8
        let cameraSwitchButtonPaddingFull: CGFloat = 4
        return Group {
            switch viewType {
            case .localVideoPip:
                IconButton(viewModel: viewModel.cameraSwitchButtonPipViewModel)
                    .padding(cameraSwitchButtonPaddingPip)
            case .localVideofull:
                IconButton(viewModel: viewModel.cameraSwitchButtonFullViewModel)
                    .padding(cameraSwitchButtonPaddingFull)
            default:
                EmptyView()
            }
        }
    }
}
