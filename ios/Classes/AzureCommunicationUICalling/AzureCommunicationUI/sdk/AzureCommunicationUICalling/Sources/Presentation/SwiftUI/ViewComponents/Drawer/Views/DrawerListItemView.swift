//
//  DrawerGenericItemView 2.swift
//  Pods
//
//  Created by Yriy Malyts on 14.04.2025.
//


//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

internal struct DrawerListItemView: View {
    let item: DrawerListItemViewModel

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack {
            Icon(name: item.icon, size: DrawerListConstants.iconSize, renderAsOriginal: true)
                    .foregroundColor(item.isEnabled ? Color(UIColor.compositeColor(.purpleBlue)) : .gray)
                    .accessibilityHidden(true)
            VStack(alignment: .leading) {
                Text(item.title)
                    .foregroundColor(item.isEnabled ? Color(UIColor.compositeColor(.textPrimary)) : .gray)
                    .padding(.leading, DrawerListConstants.textPaddingLeading)
                    .font(AppFont.CircularStd.book.font(size: 16))
            }
            Spacer()
        }
        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
        .padding(.bottom, 12)
        .padding(.top, 4)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .opacity(item.isEnabled ? 1.0 : DrawerListConstants.disabledOpacity)
        .onTapGesture {
            if item.isEnabled {
                item.action()
            }
        }
        .disabled(!item.isEnabled)
        .accessibilityElement(children: .combine)
    }
}
