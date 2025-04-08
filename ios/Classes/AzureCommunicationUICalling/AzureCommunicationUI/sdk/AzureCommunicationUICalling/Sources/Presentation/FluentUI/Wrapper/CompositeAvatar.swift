//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI
import UIKit

struct CompositeAvatar: View {
    @Binding var displayName: String?
    @Binding var avatarImage: UIImage?
    var isSpeaking: Bool
    var avatarSize: MSFAvatarSize = .size72
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        let isNameEmpty = displayName == nil
        || displayName?.trimmingCharacters(in: .whitespaces).isEmpty == true
        return Avatar(style: isNameEmpty ? .outlined : .default,
                      size: avatarSize,
                      image: avatarImage,
                      primaryText: displayName)
        .backgroundColor(UIColor.compositeColor(.purpleBlue))
        .foregroundColor(UIColor.white)
        .ringColor(UIColor.compositeColor(.purpleBlue))
            .isRingVisible(isSpeaking)
            .accessibilityHidden(true)
    }
}
