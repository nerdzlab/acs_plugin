//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct CaptionsInfoCellView: View {
    var avatarViewManager: AvatarViewManagerProtocol
    var caption: CallCompositeCaptionsData
    @State private var avatarImage: UIImage?
    @State private var displayName: String?
    
    @State private var isRTL = false

    init(caption: CallCompositeCaptionsData, avatarViewManager: AvatarViewManagerProtocol) {
        self.caption = caption
        self.avatarViewManager = avatarViewManager
        self.displayName = caption.speakerName
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        HStack(alignment: .top) {
            avatarView
            VStack(alignment: isRTL ? .trailing : .leading, spacing: 0) {
                Text(caption.speakerName)
                    .font(.caption)
                    .foregroundColor(Color(StyleProvider.color.textSecondary))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(displayText)
                    .font(.callout)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(isRTL ? .trailing : .leading)
                    /// wrap to the next line instead of being truncated,
                    /// ensuring that all content is visible without ... truncation
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .environment(\.locale, Locale(identifier: language))
            }
            .frame(maxWidth: .infinity, alignment: isRTL ? .trailing : .leading)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .background(Color(StyleProvider.color.drawerColor))
        .onAppear {
            updateAvatar()
            determineTextDirection()
        }
    }

    private var avatarView: some View {
        CompositeAvatar(displayName: $displayName,
                        avatarImage: $avatarImage,
                        backgroundColor: Color(UIColor.compositeColor(.purpleBlue)),
                        isSpeaking: false,
                        avatarSize: 24,
                        fontSize: 10
        )
    }

    // Display text based on caption availability
    private var displayText: String {
        (caption.captionText?.isEmpty ?? true) ? caption.spokenText : caption.captionText ?? ""
    }

    private var language: String {
        (caption.captionText?.isEmpty ?? true) ? caption.spokenLanguage : caption.captionLanguage ?? ""
    }
    private func updateAvatar() {
        // Attempt to get the avatar image directly from the avatar storage for the given speaker's ID.
        if let participantViewDataAvatar = avatarViewManager.avatarStorage.value(
            forKey: caption.speakerRawId)?.avatarImage {
            // If an avatar image exists, set it.
            avatarImage = participantViewDataAvatar
        } else {
            avatarImage = nil
            displayName = caption.speakerName
        }
    }

    private func determineTextDirection() {
        let activeLanguageCode = (caption.captionLanguage?.isEmpty ?? true) ?
        caption.spokenLanguage : caption.captionLanguage ?? caption.spokenLanguage
        isRTL = isRightToLeftLanguage(activeLanguageCode)
    }

    // Function to determine if the language is right-to-left
    private func isRightToLeftLanguage(_ languageCode: String) -> Bool {
        let rtlLanguages = ["ar", "he", "fa", "ur"] // Add more as needed
        let locale = Locale(identifier: languageCode)
        return rtlLanguages.contains(locale.languageCode ?? "")
    }
}
