//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI
import Combine

struct OverlayView: View {
    private let iconImageSize: CGFloat = 24
    private let verticalIconPaddingSize: CGFloat = 14
    private let verticalSubtitlePaddingSize: CGFloat = 5
    private let verticalButtonPaddingSize: CGFloat = 32
    private let horizontalPaddingSize: CGFloat = 16

    let viewModel: OverlayViewModelProtocol

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Color(viewModel.background)
            .overlay(
                ZStack(alignment: .bottom) {
                    VStack(spacing: 0) {
                        Spacer()
                        Group {
                            Icon(name: .clock, size: iconImageSize, renderAsOriginal: false)
                                .accessibility(hidden: true)
                                .padding(.bottom, verticalIconPaddingSize)

                            Text(viewModel.title)
                                .font(Fonts.title2.font)
                                .multilineTextAlignment(.center)
                            if let subtitle = viewModel.subtitle {
                                Text(subtitle)
                                    .font(Fonts.subhead.font)
                                    .multilineTextAlignment(.center)
                                    .padding(.top, verticalSubtitlePaddingSize)

                            }
                        }
                        .padding(.horizontal, horizontalPaddingSize)
                        .accessibilityElement(children: .combine)
                        .accessibility(addTraits: .isHeader)
                        if let actionButtonViewModel = viewModel.actionButtonViewModel {
                            AppPrimaryButton(viewModel: actionButtonViewModel)
                                    .frame(width: 128, height: 40)
                                    .padding(.top, verticalButtonPaddingSize)
                        }
                        Spacer()
                    }
                    if let errorInfoViewModel = viewModel.errorInfoViewModel {
                        VStack {
                            Spacer()
                            ErrorInfoView(viewModel: errorInfoViewModel)
                                .padding([.bottom])
                                .accessibilityElement(children: .contain)
                                .accessibilityAddTraits(.isModal)
                        }
                    }
                }
            )
    }
}
