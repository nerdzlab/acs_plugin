////
////  MeetingOptionsView.swift
////  Pods
////
////  Created by Yriy Malyts on 16.04.2025.
////
import SwiftUI

struct MeetingOptionsView: View {
    @ObservedObject var viewModel: MeetingOptionsViewModel
    let controlHeight: CGFloat = 78
    
    var body: some View {
        
        VStack(spacing: 8) {
            Spacer()
            HStack {
                Spacer()
                ForEach(ReactionType.allCases, id: \.self) { reaction in
                    Button(action: {
                            viewModel.sendReaction(reaction)
                        }) {
                            Text(reaction.emoji)
                                .font(AppFont.CircularStd.medium.font(size: 36))
                                .frame(width: 36, height: 36)
                        }
                    Spacer()
                }
            }
            .frame(height: 60)
            .frame(maxWidth: .infinity)
            .background(Color(StyleProvider.color.drawerColor))
            .cornerRadius(DrawerConstants.drawerCornerRadius)
            
            VStack(alignment: .center) {
                Spacer()
                HStack(alignment: .center) {
                    chatButton
                    Spacer()
                    participantsButton
                    Spacer()
                    effectsButton
                }
                .accessibilityElement(children: .contain)
                HStack(alignment: .center) {
                    raiseHandButton
                    Spacer()
                    layoutOptionsButton
                    Spacer()
                    shareScreenButton
                }
                .accessibilityElement(children: .contain)
                Spacer()
            }.accessibilityElement(children: .contain)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(height: 200)
                .background(Color(StyleProvider.color.drawerColor))
                .cornerRadius(DrawerConstants.drawerCornerRadius)
        }
    }
    
    var chatButton: some View {
        IconWithLabelButton(viewModel: viewModel.chatButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleVideoAccessibilityID.rawValue)
    }
    
    var participantsButton: some View {
        IconWithLabelButton(viewModel: viewModel.participantsButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleMicAccessibilityID.rawValue)
    }
    
    var effectsButton: some View {
        IconWithLabelButton(viewModel: viewModel.effectsButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleAudioDeviceAccessibilityID.rawValue)
    }
    
    var raiseHandButton: some View {
        IconWithLabelButton(viewModel: viewModel.raiseHandButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleAudioDeviceAccessibilityID.rawValue)
    }
    
    var layoutOptionsButton: some View {
        IconWithLabelButton(viewModel: viewModel.layoutOptionsButtonViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleAudioDeviceAccessibilityID.rawValue)
    }
    
    var shareScreenButton: some View {
        IconWithLabelButton(viewModel: viewModel.shareScreenViewModel)
            .accessibility(identifier: AccessibilityIdentifier.toggleAudioDeviceAccessibilityID.rawValue)
    }
}
