//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

internal struct DrawerBodyTextView: View {
    let item: BodyTextDrawerListItemViewModel

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack {
            Text(item.title)
                .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                .padding(.leading, DrawerListConstants.textPaddingLeading)
                .font(AppFont.CircularStd.bold.font(size: 20))
            Spacer()
        }
        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
        .padding(.vertical, DrawerListConstants.optionPaddingVertical)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .accessibilityIdentifier(item.accessibilityIdentifier)
        .background(Color(StyleProvider.color.drawerColor))
    }
}

internal struct DrawerBodyWithActionTextView: View {
    let item: BodyTextWithActionDrawerListItemViewModel
    @State
    var isConfirming = false

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack {
            Text(item.title)
                .foregroundColor(.primary)
                .padding(.leading, DrawerListConstants.textPaddingLeading)
                .font(.body)
            Spacer()
            Text(item.actionText)
                .onTapGesture {
                    isConfirming = true
                }
                .foregroundColor(Color(StyleProvider.color.primaryColor))
        }
        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
        .padding(.vertical, DrawerListConstants.optionPaddingVertical)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .accessibilityIdentifier(item.accessibilityIdentifier)
        .accessibilityAddTraits(.isButton)
        .background(Color(StyleProvider.color.drawerColor))
        .fullScreenCover(isPresented: $isConfirming) {
            CustomAlert(
                title: item.confirmTitle,
                agreeText: item.confirmAccept,
                denyText: item.confirmDeny,
                dismiss: {
                    isConfirming = false
                },
                agreeAction: item.accept,
                denyAction: item.deny
            )
            .background(BackgroundCleanerView())
        }
        .transaction { transaction in
            transaction.disablesAnimations = true
            // transaction.animation = .linear(duration: 1)
        }
    }
}
