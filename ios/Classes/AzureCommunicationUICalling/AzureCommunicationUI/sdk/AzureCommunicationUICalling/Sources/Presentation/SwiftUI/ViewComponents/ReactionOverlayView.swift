//
//  ReactionOverlayView.swift
//  Pods
//
//  Created by Yriy Malyts on 25.04.2025.
//
import SwiftUI

struct ReactionOverlayView: View {
    var selectedReaction: ReactionPayload
    @State private var scale: CGFloat = 0.8

    var body: some View {
        Color.white.opacity(0.35)
            .overlay(
                Text(selectedReaction.reaction.emoji)
                    .font(AppFont.CircularStd.bold.font(size: 45))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
                    .onAppear {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                            scale = 1.4
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeOut(duration: 0.2)) {
                                scale = 1.0
                            }
                        }
                    }
            )
            .transition(.scale.combined(with: .opacity))
            .id(selectedReaction.receivedOn)
    }
}
