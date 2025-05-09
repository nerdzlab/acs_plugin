//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

internal struct LobbyWaitingHeaderView: View {
    @ObservedObject var viewModel: LobbyWaitingHeaderViewModel
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
    @State var participantsListButtonSourceView = UIView()
    let avatarViewManager: AvatarViewManagerProtocol

    private enum Constants {
        static let shapeCornerRadius: CGFloat = 5
        static let infoLabelHorizontalPadding: CGFloat = 16.0
        static let hStackHorizontalPadding: CGFloat = 20.0
        static let hStackBottomPadding: CGFloat = 10.0
        static let hSpace: CGFloat = 4
        static let foregroundColor: Color = .white

        // MARK: Font Minimum Scale Factor
        // Under accessibility mode, the largest size is 35
        // so the scale factor would be 9/35 or 0.2
        static let accessibilityFontScale: CGFloat = 0.2
        // UI guideline suggested min font size should be 9.
        // Since Fonts.caption1 has font size of 12,
        // so min scale factor should be 9/12 or 0.75 as default.
        static let defaultFontScale: CGFloat = 0.75
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        ZStack {
            if viewModel.isDisplayed {
                lobbyHeader
            } else {
                EmptyView()
            }
        }
        .onAppear(perform: {
            viewModel.isPad = UIDevice.current.userInterfaceIdiom == .pad
        })
    }

    var lobbyHeader: some View {
        HStack(alignment: .center) {
            addParticipantIcon
            Text(viewModel.title)
                .padding(EdgeInsets(top: Constants.infoLabelHorizontalPadding,
                                    leading: 0,
                                    bottom: Constants.infoLabelHorizontalPadding,
                                    trailing: 0))
                .foregroundColor(Constants.foregroundColor)
                .font(Fonts.caption1.font)
                .accessibilityLabel(Text(viewModel.accessibilityLabel))
                .accessibilitySortPriority(1)
            Spacer()
            participantListButton
            dismissButton
        }
        .padding(EdgeInsets(top: 0,
                            leading: Constants.hStackHorizontalPadding / 2.0,
                            bottom: 0,
                            trailing: Constants.hStackHorizontalPadding / 2.0))
        .background(Color(StyleProvider.color.surfaceDarkColor))
        .clipShape(RoundedRectangle(cornerRadius: Constants.shapeCornerRadius))
        .padding(.bottom, Constants.hStackBottomPadding)
    }

    var addParticipantIcon: some View {
        Icon(name: .addParticipant, size: 24, renderAsOriginal: false)
            .foregroundColor(.white)
            .contentShape(Rectangle())
    }

    var participantListButton: some View {
        PrimaryButton(viewModel: viewModel.participantListButtonViewModel)
            .fixedSize()
            .background(SourceViewSpace(sourceView: participantsListButtonSourceView))
            .accessibilityIdentifier(AccessibilityIdentifier.lobbyWaitingViewID.rawValue)
    }

    var dismissButton: some View {
        IconButton(viewModel: viewModel.dismissButtonViewModel)
            .background(SourceViewSpace(sourceView: participantsListButtonSourceView))
            .accessibilityIdentifier(AccessibilityIdentifier.lobbyWaitingDismissID.rawValue)
    }
}
