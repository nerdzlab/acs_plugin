//
//  FullScreenModelView.swift
//  Pods
//
//  Created by Yriy Malyts on 18.04.2025.
//

import SwiftUI

internal struct FullScreenModalView<Content: View>: View {
    private enum ModalState {
        case gone, hidden, visible
    }

    @State private var modalState: ModalState = .gone
    let isPresented: Bool
    let hideModal: () -> Void
    let content: Content

    init(isPresented: Bool, hideModal: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented
        self.hideModal = hideModal
        self.content = content()
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif

        ZStack {
            if modalState != .gone {
                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(StyleProvider.color.drawerColor))
                    .cornerRadius(0)
                    .accessibilityAddTraits(.isModal)
                    .onAppear {
                        UIAccessibility.post(notification: .screenChanged, argument: nil)
                    }
                    .offset(y: modalState == .visible ? 0 : UIScreen.main.bounds.height)
                    .animation(.easeInOut(duration: 0.25), value: modalState)
            }
        }
        .ignoresSafeArea()
        .onChange(of: isPresented) { newValue in
            if newValue {
                modalState = .hidden
                withAnimation {
                    modalState = .visible
                }
            } else {
                withAnimation {
                    modalState = .hidden
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                    modalState = .gone
                }
            }
        }
    }
}
