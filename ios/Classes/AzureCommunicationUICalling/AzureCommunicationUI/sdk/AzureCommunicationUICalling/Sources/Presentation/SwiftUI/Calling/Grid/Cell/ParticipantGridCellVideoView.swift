//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import FluentUI
import SwiftUI

struct ParticipantGridCellVideoView: View {
    var videoRendererViewInfo: ParticipantRendererViewInfo!
    let rendererViewManager: RendererViewManager?
    let zoomable: Bool
    let onUserClicked: () -> Void
    
    @Binding var isSpeaking: Bool
    @Binding var displayName: String?
    @Binding var isMuted: Bool
    @Binding var isHandRaised: Bool
    @Binding var selectedReaction: ReactionPayload?
    @Binding var isPinned: Bool
    @Environment(\.screenSizeClass) var screenSizeClass: ScreenSizeClassType
    @State var show = true
    let isWhiteBoard: Bool
        
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        ZStack(alignment: .bottomLeading) {
            VStack(alignment: .center, spacing: 0) {
                if zoomable {
                    zoomableVideoRenderView
                        .prefersHomeIndicatorAutoHidden(UIDevice.current.hasHomeBar)
                } else {
                    videoRenderView
                }
            }

            ParticipantTitleView(displayName: $displayName,
                                 isMuted: $isMuted,
                                 isHold: .constant(false),
                                 isHandRaised: $isHandRaised,
                                 isPinned: $isPinned,
                                 titleFont: AppFont.CircularStd.book.font(size: 13),
                                 mutedIconSize: 14,
                                 isWhiteBoard: isWhiteBoard)
                .padding(.vertical, 2)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.leading, 8)
                .padding(.bottom, screenSizeClass == .iphoneLandscapeScreenSize
                    && UIDevice.current.hasHomeBar ? 16 : 8)
                .onTapGesture {
                    if (!isWhiteBoard) {
                        onUserClicked()
                    }
                }
            
            // Reaction overlay
            if let reaction = selectedReaction {
                ReactionOverlayView(selectedReaction: reaction)
            }

        }.overlay(
            isHandRaised ? RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(UIColor.compositeColor(.orange)), lineWidth: 4) : nil
        )
        .animation(.default, value: show)
        
        .overlay(
            isSpeaking && !isMuted ? RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color(UIColor.compositeColor(.purpleBlue)), lineWidth: 4) : nil
        ).animation(.default, value: show)
    }

    var videoRenderView: some View {
        VideoRendererView(rendererView: videoRendererViewInfo.rendererView)
    }

    var zoomableVideoRenderView: some View {
        ZoomableVideoRenderView(videoRendererViewInfo: videoRendererViewInfo,
                                rendererViewManager: rendererViewManager)
                                .gesture(TapGesture(count: 2).onEnded({}))
        // The double tap action does nothing. This is a work around to
        // prevent the single-tap gesture (in CallingView) from being recognized
        // until after the double-tap gesture  recognizer (in ZoomableVideoRenderView) explicitly
        // reaches the failed state, which happens when the touch sequence contains only one tap.
    }
}
