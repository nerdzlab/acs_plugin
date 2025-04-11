//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI
internal struct DrawerTitleView: View {
    let item: TitleDrawerListItemViewModel

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack {
            Spacer()
            Text(item.title)
                .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                .padding(.leading, DrawerListConstants.textPaddingLeading)
                .font(AppFont.CircularStd.bold.font(size: 20))
                .accessibilityAddTraits(.isHeader)
            Spacer()
        }
        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
        .padding(.vertical, 0)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .accessibilityIdentifier(item.accessibilityIdentifier)
        .background(Color.white)
    }
}
