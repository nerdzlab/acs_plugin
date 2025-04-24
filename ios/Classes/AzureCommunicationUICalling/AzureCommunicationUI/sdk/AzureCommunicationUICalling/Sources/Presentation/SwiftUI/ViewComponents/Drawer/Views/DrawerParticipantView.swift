//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

internal struct DrawerParticipantView: View {
    let item: ParticipantsListCellViewModel
    let avatarManager: AvatarViewManagerProtocol
    @State
    var isConfirming = false

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        let participantViewData = item.getParticipantViewData(from: avatarManager)
        let name = item.getParticipantName(with: participantViewData)
        let displayName = item.getCellDisplayName(with: participantViewData)

        HStack {
            // Placeholder replaced with actual avatar view
            CompositeAvatar(
                displayName: Binding.constant(name),
                avatarImage: Binding.constant(
                    item.isLocalParticipant ?
                    avatarManager.localParticipantViewData?.avatarImage :
                        avatarManager.avatarStorage.value(forKey: item.participantId ?? "")?.avatarImage
                ),
                backgroundColor: item.avatarColor,
                isSpeaking: false,
                avatarSize: 40,
                fontSize: 12
            )
            Text(displayName)
                .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                .padding(.leading, DrawerListConstants.textPaddingLeading)
                .font(AppFont.CircularStd.book.font(size: 16))
            Spacer()
            if item.isHold {
                Text("On Hold")
            } else {
                Icon(name: item.isMuted ? .micOff : .micOn,
                     size: DrawerListConstants.iconSize, renderAsOriginal: false)
                .opacity(DrawerListConstants.micIconOpacity)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
        .padding(.vertical, DrawerListConstants.participantOptionPaddingVertical)
        .accessibilityIdentifier(item.getCellAccessibilityLabel(with: participantViewData))
        .onTapGesture {
            // Is this participant is set up to confirm, lets toggle that
            if item.confirmTitle != nil && item.confirmAccept != nil && item.confirmDeny != nil {
                isConfirming = true
            } else {
                // Else, we are going to just do the "accept()" action by default
                guard let action = item.accept else {
                    return
                }
                action()
            }
        }
        .fullScreenCover(isPresented: $isConfirming) {
            CustomAlert(
                title: item.confirmTitle ?? "",
                agreeText: item.confirmAccept ?? "",
                denyText: item.confirmDeny ?? "",
                dismiss: {
                    isConfirming = false
                },
                agreeAction: {
                    guard let accept = item.accept else {
                        return
                    }
                    accept()
                },
                denyAction: {
                    guard let deny = item.deny else {
                        return
                    }
                    deny()
                }
            )
            .background(BackgroundCleanerView())

        }
        .transaction { transaction in
            transaction.disablesAnimations = true
            // transaction.animation = .linear(duration: 1)
        }.onChange(of: item.confirmTitle) { _ in
            isConfirming = false
        }
    }
}
