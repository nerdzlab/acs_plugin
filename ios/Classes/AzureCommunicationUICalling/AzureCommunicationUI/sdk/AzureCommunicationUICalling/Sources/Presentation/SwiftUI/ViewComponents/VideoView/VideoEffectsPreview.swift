//
//  LocalVideoViewType.swift
//  Pods
//
//  Created by Yriy Malyts on 23.04.2025.
//


import SwiftUI
import FluentUI

struct VideoEffectsPreview: View {
    @ObservedObject var viewModel: VideoEffectsPreviewViewModel
    let viewManager: VideoViewManager
    let viewType: LocalVideoViewType
    let avatarManager: AvatarViewManagerProtocol
    
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
                        }
                        
                    } else {
                        VStack(alignment: .center, spacing: 5) {
                            CompositeAvatar(
                                displayName: $viewModel.displayName,
                                avatarImage: Binding.constant(
                                    avatarManager.localParticipantViewData?.avatarImage
                                ),
                                backgroundColor: Color(UIColor.compositeColor(.purpleBlue)),
                                isSpeaking: false,
                                avatarSize: viewType.avatarSize,
                                fontSize: viewType.initialFontSize
                            )
                        }
                        .frame(width: geometry.size.width,
                               height: geometry.size.height)
                        .accessibilityElement(children: .combine)
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
}
