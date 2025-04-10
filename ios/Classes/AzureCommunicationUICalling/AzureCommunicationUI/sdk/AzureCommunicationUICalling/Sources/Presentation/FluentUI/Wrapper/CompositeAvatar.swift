//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

//import SwiftUI
//import FluentUI
//import UIKit
//
//struct CompositeAvatar: View {
//    @Binding var displayName: String?
//    @Binding var avatarImage: UIImage?
//    var isSpeaking: Bool
//    var avatarSize: MSFAvatarSize = .size72
//    var body: some View {
//#if DEBUG
//        let _ = Self._printChanges()
//#endif
//        
//        let isNameEmpty = displayName == nil
//        || displayName?.trimmingCharacters(in: .whitespaces).isEmpty == true
//        return Avatar(style: isNameEmpty ? .outlined : .default,
//                      size: avatarSize,
//                      image: avatarImage,
//                      primaryText: displayName)
//        .backgroundColor(UIColor.compositeColor(.purpleBlue))
//        .foregroundColor(UIColor.white)
//        .ringColor(UIColor.compositeColor(.purpleBlue))
//            .isRingVisible(isSpeaking)
//            .accessibilityHidden(true)
//    }
//}

import SwiftUI

struct CompositeAvatar: View {
    @Binding var displayName: String?
    @Binding var avatarImage: UIImage?
    var isSpeaking: Bool

    var avatarSize: CGFloat = 80
    var fontSize: CGFloat
    private let backgroundColor = Color(UIColor.compositeColor(.purpleBlue))
    private let textColor = Color.white
    private let ringColor = Color(UIColor.compositeColor(.purpleBlue))

    private var initials: String {
        guard let name = displayName else { return "" }
        let first = name.dropFirst(0).first.map(String.init) ?? ""
        let second = name.dropFirst(1).first.map(String.init) ?? ""
        return (first + second).uppercased()
    }

    var body: some View {
        #if DEBUG
                let _ = Self._printChanges()
        #endif
        
        ZStack {
            if let image = avatarImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: avatarSize, height: avatarSize)
                    .clipShape(Circle())
            } else {
                Text(initials)
                    .font(AppFont.CircularStd.medium.font(size: fontSize))
                    .foregroundColor(textColor)
                    .frame(width: avatarSize, height: avatarSize)
                    .background(backgroundColor)
                    .clipShape(Circle())
            }

            if isSpeaking {
                Circle()
                    .stroke(ringColor, lineWidth: 4)
                    .frame(width: avatarSize + 8, height: avatarSize + 8)
            }
        }
        .accessibilityHidden(true)
    }
}
