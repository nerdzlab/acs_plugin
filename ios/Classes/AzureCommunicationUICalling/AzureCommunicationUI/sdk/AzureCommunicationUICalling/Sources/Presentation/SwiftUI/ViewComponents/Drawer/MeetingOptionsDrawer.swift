//
//  DrawerState.swift
//  Pods
//
//  Created by Yriy Malyts on 17.04.2025.
//

import SwiftUI

internal struct MeetingOptionsDrawer<Content: View>: View {
    @State private var drawerState: DrawerState = .gone
    let isPresented: Bool
    let hideDrawer: () -> Void
    let content: Content
    var drawerWorkItem: DispatchWorkItem?
    
    init(isPresented: Bool, hideDrawer: @escaping () -> Void, @ViewBuilder content: () -> Content) {
        self.isPresented = isPresented
        self.content = content()
        self.hideDrawer = hideDrawer
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        ZStack(alignment: .bottom) {
            if drawerState != .gone {
                Group {
                    Color.black.opacity(drawerState == .visible ? DrawerConstants.overlayOpacity : 0)
                        .ignoresSafeArea()
                        .onTapGesture {
                            hideDrawer()
                        }
                        .accessibilityHidden(true)
                    
                    content
                        .shadow(radius: DrawerConstants.drawerShadowRadius)
                        .padding(.bottom, 34)
                        .padding(.horizontal, 12)
                        .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: drawerState == .visible)
                        .offset(y: drawerState == .hidden ? UIScreen.main.bounds.height : 0)
                        .accessibilityAddTraits(.isModal)
                        .onAppear {
                            UIAccessibility.post(notification: .screenChanged, argument: nil)
                        }
                }
            }
            
        }
        
        .onChange(of: isPresented) { newValue in
            if newValue {
                drawerState = .hidden
                withAnimation {
                    drawerState = .visible
                }
            } else {
                withAnimation {
                    drawerState = .hidden
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + DrawerConstants.delayUntilGone) {
                    drawerState = .gone
                }
            }
        }
    }
}
