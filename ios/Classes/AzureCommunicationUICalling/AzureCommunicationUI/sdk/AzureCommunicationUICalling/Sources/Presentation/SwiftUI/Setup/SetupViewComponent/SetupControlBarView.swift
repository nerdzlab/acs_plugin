//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct SetupControlBarView: View {
    @ObservedObject var viewModel: SetupControlBarViewModel
    @State var audioDeviceButtonSourceView = UIView()
    @AccessibilityFocusState var focusedOnAudioButton: Bool
    let layoutSpacing: CGFloat = 16
    let controlHeight: CGFloat = 32
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        GeometryReader { geometry in
            HStack(alignment: .center, spacing: layoutSpacing) {
                if viewModel.isMicButtonVisible {
                    micButton
                }
                
                if viewModel.isCameraButtonVisible {
                    cameraButton
                }
                
                switchCameraButton
                
                backgroundEffectButton
                Spacer()
             
                if viewModel.isAudioDeviceButtonVisible {
                    audioDeviceButton
                }
            }
            .frame(height: controlHeight)
            .hidden(viewModel.isControlBarHidden())
            .accessibilityElement(children: .contain)
        }
    }
    var cameraButton: some View {
        PrimaryIconButton(viewModel: viewModel.cameraButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleVideoAccessibilityID.rawValue)
            .hidden(!viewModel.isCameraButtonVisible)
    }
    
    var micButton: some View {
        PrimaryIconButton(viewModel: viewModel.micButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleMicAccessibilityID.rawValue)
            .hidden(!viewModel.isMicButtonVisible)
    }
    
    var backgroundEffectButton: some View {
        PrimaryIconButton(viewModel: viewModel.backgroundEffectButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleMicAccessibilityID.rawValue)
    }
    
    var switchCameraButton: some View {
        PrimaryIconButton(viewModel: viewModel.switchCameraButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleMicAccessibilityID.rawValue)
    }
    
    var audioDeviceButton: some View {
        PrimaryIconButton(viewModel: viewModel.audioDeviceButtonViewModel)
            .background(SourceViewSpace(sourceView: audioDeviceButtonSourceView))
            .accessibility(identifier: AccessibilityIdentifier.toggleAudioDeviceAccessibilityID.rawValue)
            .accessibilityFocused($focusedOnAudioButton, equals: true)
            .hidden(!viewModel.isAudioDeviceButtonVisible)
    }
}
