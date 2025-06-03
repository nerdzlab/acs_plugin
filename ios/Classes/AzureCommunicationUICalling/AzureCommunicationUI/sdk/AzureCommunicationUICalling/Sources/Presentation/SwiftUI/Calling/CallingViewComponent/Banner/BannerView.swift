//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct BannerView: View {
    @ObservedObject var viewModel: BannerViewModel
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        if viewModel.isBannerDisplayed {
            HStack(alignment: .center) {
                BannerTextView(viewModel: viewModel.bannerTextViewModel)
                    .padding([.leading])
                    .accessibilitySortPriority(2)
                Spacer()
                dismissButton
                    .padding([.trailing])
                    .accessibilitySortPriority(1)
            }
            .background(viewModel.bannerBackgroundColor)
            .accessibilitySortPriority(2)
            .accessibilityIdentifier(AccessibilityIdentifier.bannerViewAccessibilityID.rawValue)
            .padding(.top, safeAreaInsets.top)
        } else {
            Spacer()
                .frame(height: 0)
        }
    }

    var dismissButton: some View {
        return IconButton(viewModel: viewModel.dismissButtonViewModel)
    }
}
