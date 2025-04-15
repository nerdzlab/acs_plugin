//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import FluentUI
import SwiftUI

struct ParticipantGridCellView: View {
    @ObservedObject var viewModel: ParticipantGridCellViewModel
    let rendererViewManager: RendererViewManager?
    let avatarViewManager: AvatarViewManagerProtocol
    @State var avatarImage: UIImage?
    @State var displayedVideoStreamId: String?
    @State var isVideoChanging = false
    let avatarSize: CGFloat = 56
    let initialsFontSize: CGFloat = 20
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Group {
            GeometryReader { geometry in
                if let videoStreamId = displayedVideoStreamId,
                   let rendererViewInfo = getRendererViewInfo(for: videoStreamId), viewModel.isVideoEnableForLocalUser {
                    let zoomable = viewModel.videoViewModel?.videoStreamType == .screenSharing
                    ParticipantGridCellVideoView(videoRendererViewInfo: rendererViewInfo,
                                                 rendererViewManager: rendererViewManager,
                                                 zoomable: zoomable, onUserClicked: {
                        viewModel.onUserClicked()
                    },
                                                 isSpeaking: $viewModel.isSpeaking,
                                                 displayName: $viewModel.displayName,
                                                 
                                                 isMuted: $viewModel.isMuted)
                } else {
                    avatarView
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(Text(viewModel.accessibilityLabel))
            .accessibilityIdentifier(AccessibilityIdentifier.participantGridCellViewAccessibilityID.rawValue)
        }
        .onReceive(viewModel.$videoViewModel) { model in
            if model?.videoStreamId != displayedVideoStreamId {
                displayedVideoStreamId = model?.videoStreamId
            }
        }
        .onReceive(viewModel.$participantIdentifier) {
            updateParticipantViewData(for: $0)
        }
        .onReceive(avatarViewManager.updatedId) {
            guard $0 == viewModel.participantIdentifier else {
                return
            }
            
            updateParticipantViewData(for: viewModel.participantIdentifier)
        }
    }
    
    func getRendererViewInfo(for videoStreamId: String) -> ParticipantRendererViewInfo? {
        if videoStreamId.isEmpty {
            return nil
        }
        
        let remoteParticipantVideoViewId = RemoteParticipantVideoViewId(userIdentifier: viewModel.participantIdentifier,
                                                                        videoStreamIdentifier: videoStreamId)
        return rendererViewManager?.getRemoteParticipantVideoRendererView(remoteParticipantVideoViewId)
    }
    
    private func updateParticipantViewData(for identifier: String) {
        guard let participantViewData =
                avatarViewManager.avatarStorage.value(forKey: identifier) else {
            avatarImage = nil
            viewModel.updateParticipantNameIfNeeded(with: nil)
            return
        }
        
        if avatarImage !== participantViewData.avatarImage {
            avatarImage = participantViewData.avatarImage
        }
        
        viewModel.updateParticipantNameIfNeeded(with: participantViewData.displayName)
    }
    
    var avatarView: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Centered avatar in full area
                VStack {
                    Spacer()
                    CompositeAvatar(
                        displayName: $viewModel.avatarDisplayName,
                        avatarImage: $avatarImage,
                        isSpeaking: viewModel.isSpeaking && !viewModel.isMuted,
                        avatarSize: avatarSize,
                        fontSize: initialsFontSize
                    )
                    .frame(width: avatarSize, height: avatarSize)
                    .opacity(viewModel.isHold ? 0.6 : 1)
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                
                // Title view in bottom-leading
                VStack(alignment: .leading, spacing: 0) {
                    ParticipantTitleView(
                        displayName: $viewModel.displayName,
                        isMuted: $viewModel.isMuted,
                        isHold: $viewModel.isHold,
                        titleFont: AppFont.CircularStd.book.font(size: 13),
                        mutedIconSize: 16
                    )
                    .padding(.vertical, 2)
                    .opacity(viewModel.isHold ? 0.6 : 1)
                    .onTapGesture {
                        viewModel.onUserClicked()
                    }
                    
                    if viewModel.isHold {
                        Text(viewModel.getOnHoldString())
                            .font(Fonts.caption1.font)
                            .lineLimit(1)
                            .foregroundColor(Color(StyleProvider.color.onBackground))
                            .padding(.top, 8)
                    }
                }
                .padding([.leading, .bottom], 8)
            }
        }
    }
    
    
}

struct ParticipantTitleView: View {
    @Binding var displayName: String?
    @Binding var isMuted: Bool
    @Binding var isHold: Bool
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
    let titleFont: Font
    let mutedIconSize: CGFloat
    private var isEmpty: Bool {
        return !isMuted && displayName?.trimmingCharacters(in: .whitespaces).isEmpty == true
    }
    
    private enum Constants {
        static let hSpace: CGFloat = 4
        
        // MARK: Font Minimum Scale Factor
        // Under accessibility mode, the largest size is 35
        // so the scale factor would be 9/35 or 0.2
        static let accessibilityFontScale: CGFloat = 0.2
        // UI guideline suggested min font size should be 9.
        // Since Fonts.caption1 has font size of 12,
        // so min scale factor should be 9/12 or 0.75 as default.
        static let defaultFontScale: CGFloat = 0.75
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack(alignment: .center, spacing: Constants.hSpace, content: {
            if let displayName = displayName,
               !displayName.trimmingCharacters(in: .whitespaces).isEmpty {
                Text(displayName)
                    .font(titleFont)
                    .lineLimit(1)
                    .minimumScaleFactor(sizeCategory.isAccessibilityCategory ?
                                        Constants.accessibilityFontScale :
                                            Constants.defaultFontScale)
                    .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
            }
            if isMuted && !isHold {
                Icon(name: .micOff, size: mutedIconSize, renderAsOriginal: false)
                    .accessibility(hidden: true)
            }
        })
        .padding(.horizontal, isEmpty ? 0 : 6)
        .animation(.default, value: true)
    }
}

struct MoreParticipantView: View {
    let avatarSize: CGFloat = 56
    let initialsFontSize: CGFloat = 20
    var moreParticipantCount: Int
    private let backgroundColor = Color(UIColor.compositeColor(.textSecondary))
    private let textColor = Color.white
    
    private var text: String {
        return "+\(moreParticipantCount)".uppercased()
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottomLeading) {
                // Centered avatar in full area
                VStack {
                    Spacer()
                    Text(text)
                        .font(AppFont.CircularStd.medium.font(size: initialsFontSize))
                        .foregroundColor(textColor)
                        .frame(width: avatarSize, height: avatarSize)
                        .background(backgroundColor)
                        .clipShape(Circle())
                    Spacer()
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}
