////
////  MeetingOptionsView.swift
////  Pods
////
////  Created by Yriy Malyts on 16.04.2025.
////
//import SwiftUI
//
//struct MeetingOptionsView: View {
//    @ObservedObject var viewModel: SetupControlBarViewModel
//    @State var audioDeviceButtonSourceView = UIView()
//    @AccessibilityFocusState var focusedOnAudioButton: Bool
//    let layoutSpacing: CGFloat = 0
//    let controlWidth: CGFloat = 315
//    let controlHeight: CGFloat = 78
//    let horizontalPadding: CGFloat = 16
//    let verticalPadding: CGFloat = 13
//    
//    var body: some View {
//        GeometryReader { geometry in
//            VStack(alignment: .center) {
//                Spacer()
//                HStack(alignment: .center, spacing: layoutSpacing) {
//                    Spacer()
//                    cameraButton
//                    Spacer()
//                    micButton
//                    Spacer()
//                    audioDeviceButton
//                    Spacer()
//                }
//                .frame(width: getWidth(from: geometry), height: controlHeight)
//                .padding(.horizontal, getHorizontalPadding(from: geometry))
//                .padding(.vertical, verticalPadding)
//                .hidden(viewModel.isControlBarHidden())
//                .accessibilityElement(children: .contain)
//                Spacer()
//                HStack(alignment: .center, spacing: layoutSpacing) {
//                    Spacer()
//                    cameraButton
//                    Spacer()
//                    micButton
//                    Spacer()
//                    audioDeviceButton
//                    Spacer()
//                }
//                .frame(width: getWidth(from: geometry), height: controlHeight)
//                .padding(.horizontal, getHorizontalPadding(from: geometry))
//                .padding(.vertical, verticalPadding)
//                .hidden(viewModel.isControlBarHidden())
//                .accessibilityElement(children: .contain)
//            }.accessibilityElement(children: .contain)
//        }
//    }
//    var cameraButton: some View {
//        IconWithLabelButton(viewModel: viewModel.cameraButtonViewModel)
//            .accessibility(identifier: AccessibilityIdentifier.toggleVideoAccessibilityID.rawValue)
//            .hidden(!viewModel.isCameraButtonVisible)
//    }
//    
//    var micButton: some View {
//        IconWithLabelButton(viewModel: viewModel.micButtonViewModel)
//            .accessibility(identifier: AccessibilityIdentifier.toggleMicAccessibilityID.rawValue)
//            .hidden(!viewModel.isMicButtonVisible)
//    }
//    
//    var audioDeviceButton: some View {
//        IconWithLabelButton(viewModel: viewModel.audioDeviceButtonViewModel)
//            .background(SourceViewSpace(sourceView: audioDeviceButtonSourceView))
//            .accessibility(identifier: AccessibilityIdentifier.toggleAudioDeviceAccessibilityID.rawValue)
//            .accessibilityFocused($focusedOnAudioButton, equals: true)
//            .hidden(!viewModel.isAudioDeviceButtonVisible)
//    }
//    
//    private func getWidth(from geometry: GeometryProxy) -> CGFloat {
//        if controlWidth > geometry.size.width {
//            return geometry.size.width
//        }
//        return controlWidth
//    }
//    
//    private func getHorizontalPadding(from geometry: GeometryProxy) -> CGFloat {
//        if controlWidth > geometry.size.width {
//            return 0
//        }
//        return (geometry.size.width - controlWidth) / 2
//    }
//}
