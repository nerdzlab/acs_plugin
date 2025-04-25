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
    @State private var animationID = UUID()

    var body: some View {
        Color.white.opacity(0.35)
            .overlay(
                Text(selectedReaction.reaction.emoji)
                    .font(AppFont.CircularStd.bold.font(size: 45))
                    .foregroundColor(.white)
                    .scaleEffect(scale)
            )
            .id(animationID)
            .transition(.scale.combined(with: .opacity))
            .onAppear {
                runAnimation()
            }
            .onChange(of: selectedReaction.receivedOn) { _ in
                animationID = UUID() // force view reload
                runAnimation()
            }
    }

    private func runAnimation() {
        scale = 0.8
        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
            scale = 1.4
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeOut(duration: 0.2)) {
                scale = 1.0
            }
        }
    }
}

