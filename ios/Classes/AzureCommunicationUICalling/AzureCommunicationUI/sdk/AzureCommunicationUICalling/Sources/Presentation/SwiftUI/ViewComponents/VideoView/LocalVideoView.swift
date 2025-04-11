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
    
    var cameraSwitchButtonAlignment: Alignment {
        switch self {
        case .localVideoPip:
            return .topTrailing
        case .localVideofull:
            return .bottomTrailing
        case .preview:
            return .trailing
        }
    }
    
    var avatarSize: CGFloat {
        switch self {
        case .localVideofull,
                .preview:
            return 80
        case .localVideoPip:
            return 48
        }
    }
    
    var initialFontSize: CGFloat {
        switch self {
        case .localVideofull,
                .preview:
            return 32
        case .localVideoPip:
            return 20
        }
    }
    
    var showDisplayNameTitleView: Bool {
        switch self {
        case .localVideoPip,
                .preview:
            return false
        case .localVideofull:
            return true
        }
    }
    
    var hasGradient: Bool {
        switch self {
        case .localVideoPip,
                .localVideofull:
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
                        
                        ZStack(alignment: viewType.cameraSwitchButtonAlignment) {
                            VideoRendererView(rendererView: rendererView)
                                .frame(width: geometry.size.width,
                                       height: geometry.size.height)
                            
                            if viewType.hasGradient {
                                GradientView()
                            }
                            
                            if !viewModel.isInPip {
                                cameraSwitchButton
                            }
                        }
                        
                    } else {
                        VStack(alignment: .center, spacing: 5) {
                            CompositeAvatar(
                                displayName: $viewModel.displayName,
                                avatarImage: Binding.constant(
                                    avatarManager.localParticipantViewData?.avatarImage
                                ),
                                isSpeaking: false,
                                avatarSize: viewType.avatarSize,
                                fontSize: viewType.initialFontSize
                            )
                        }
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
                            titleFont: AppFont.CircularStd.book.font(size: 13),
                            mutedIconSize: 16
                        )
                        .padding(.vertical, 2)
                        .background(viewModel.cameraOperationalStatus == .on ? Color.white : .clear)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .padding([.leading, .bottom], 8)
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
