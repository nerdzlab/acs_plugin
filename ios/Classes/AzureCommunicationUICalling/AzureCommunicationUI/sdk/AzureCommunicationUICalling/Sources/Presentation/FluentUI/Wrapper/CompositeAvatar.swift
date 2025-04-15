

import SwiftUI

struct CompositeAvatar: View {
    @Binding var displayName: String?
    @Binding var avatarImage: UIImage?
    var backgroundColor: Color
    var isSpeaking: Bool

    var avatarSize: CGFloat = 80
    var fontSize: CGFloat
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
