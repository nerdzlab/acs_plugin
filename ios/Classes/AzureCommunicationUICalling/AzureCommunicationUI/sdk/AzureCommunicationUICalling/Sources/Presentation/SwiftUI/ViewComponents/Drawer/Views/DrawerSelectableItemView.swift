//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

internal struct DrawerSelectableItemView: View {
    let item: DrawerSelectableItemViewModel

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack {
            if let icon = item.icon {
                Icon(name: icon, size: DrawerListConstants.iconSize, renderAsOriginal: false)
                    .foregroundColor(.primary)
            }
            Text(item.title)
                .foregroundColor(.primary)
                .padding(.leading, DrawerListConstants.textPaddingLeading)
                .font(.body)

            Spacer()
            if item.isSelected {
                Icon(name: .checkmark, size: DrawerListConstants.iconSize, renderAsOriginal: false)
            }
        }
        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
        .padding(.vertical, DrawerListConstants.optionPaddingVertical)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            item.action()
        }
        .accessibilityAddTraits(.isButton)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier(item.accessibilityIdentifier)
        .accessibilityLabel(item.accessibilityLabel ?? item.title)
    }
}
