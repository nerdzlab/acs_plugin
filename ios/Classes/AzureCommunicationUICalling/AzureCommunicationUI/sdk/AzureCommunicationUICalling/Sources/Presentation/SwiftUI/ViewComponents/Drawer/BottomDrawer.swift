//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

internal enum DrawerState {
    case gone
    case hidden
    case visible
}

internal enum DrawerConstants {
    // How round is the drawer handle
    static let drawerHandleCornerRadius: CGFloat = 4

    // How round is the drawer itself
    static let drawerCornerRadius: CGFloat = 16

    // How much shadow is under the drawer
    static let drawerShadowRadius: CGFloat = 10

    // How much "fill" below the content to push it off the bottom os the screen
    static let bottomFillY: CGFloat = 48

    // Opacity of faded items (like background overlay)
    static let overlayOpacity: CGFloat = 0.7

    // After hiding, the delay before making it "gone", accounts for animation
    static let delayUntilGone: CGFloat = 0.3
}

/// Bottom Drawer w/Swift UI Support
///
/// How it works:
/// When enabling/disabling, state goes Gone->Hidden->Visible, or Visible->HIdden->Gone
/// Gone is means the content is not included in the view
/// Hidden is the "off screen state" to allow for animation transitions
/// Visible is the "on screen state" when it's displayed
///
/// When tapping out, or dragging down on the handle, the hideDrawer functions is called
///
/// Examples Usage:
///     BottomDrawer(isPresented: viewModel.supportFormViewModel.isDisplayed,
///                  hideDrawer: viewModel.supportFormViewModel.hideForm) {
///         reportErrorView
///         .accessibilityElement(children: .contain)
///         .accessibilityAddTraits(.isModal)
///    }
///
///  Typically used (if presenting a list) with DrawerListView
///
internal struct BottomDrawer<Content: View>: View {
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

                    VStack {
                        Spacer()
                        VStack {
                            Color.clear.frame(maxWidth: .infinity, maxHeight: 1)
                                .accessibilityHidden(drawerState != .visible)
                                .accessibilityLabel(Text("Close Drawer"))
                                .accessibilityAction {
                                    hideDrawer()
                                }
                                .accessibility(hidden: drawerState != .visible)
                                .allowsHitTesting(drawerState == .visible)

                            content
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(StyleProvider.color.drawerColor))
                        .cornerRadius(DrawerConstants.drawerCornerRadius)
                        .shadow(radius: DrawerConstants.drawerShadowRadius)
                        .padding(.bottom, 34)
                        .padding(.horizontal, 12)
                    }
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
