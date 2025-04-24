//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct InfoHeaderView: View {
    @ObservedObject var viewModel: InfoHeaderViewModel
    @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
    @State var participantsListButtonSourceView = UIView()
    @State var chatButtonSourceView = UIView()
    @State var participantMenuSourceView = UIView()
    /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
    @State var customButton1SourceView = UIView()
    @State var customButton2SourceView = UIView()
    /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
    @AccessibilityFocusState var focusedOnParticipantList: Bool
    /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
    @AccessibilityFocusState var focusedOnCustomButton1: Bool
    @AccessibilityFocusState var focusedOnCustomButton2: Bool
    /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
    let avatarViewManager: AvatarViewManagerProtocol

    private enum Constants {
        static let shapeCornerRadius: CGFloat = 10
        static let infoLabelHorizontalPadding: CGFloat = 16.0
        static let hStackHorizontalPadding: CGFloat = 20.0
        static let hStackBottomPadding: CGFloat = 10.0
        static let hSpace: CGFloat = 4
        static let foregroundColor: Color = Color(UIColor.compositeColor(.textPrimary))

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
        
        ZStack(
            alignment: .leading
        ) {
            if viewModel.isInfoHeaderDisplayed {
                infoHeader
            } else {
                EmptyView()
            }
        }
        .onAppear(perform: {
            viewModel.isPad = UIDevice.current.userInterfaceIdiom == .pad
        })
        /*
        .modifier(PopupModalView(isPresented:
                                    viewModel.isParticipantsListDisplayed || viewModel.isParticipantMenuDisplayed) {
            if viewModel.isParticipantsListDisplayed {
                participantsListView
                    .accessibilityElement(children: .contain)
                    .accessibilityAddTraits(.isModal)
            }
            if viewModel.isParticipantMenuDisplayed {
                participantMenuView
                    .accessibilityElement(children: .contain)
                    .accessibilityAddTraits(.isModal)
            }
        }) */
        .accessibilityElement(children: .contain)
    }

    var infoHeader: some View {
        HStack {
            // correct dismissButtonAccessibilityID
            if viewModel.enableMultitasking {
                IconButton(viewModel: viewModel.dismissButtonViewModel)
                    .flipsForRightToLeftLayoutDirection(true)
                    .accessibilityIdentifier(AccessibilityIdentifier.dismissButtonAccessibilityID.rawValue)
            }
            VStack(alignment: .leading) {
                Text(viewModel.title)
                    .alignmentGuide(.leading) { d in d[.leading] }
                    .foregroundColor(Constants.foregroundColor)
                    .lineLimit(1)
                    .font(AppFont.CircularStd.book.font(size: 16))
                    .accessibilityLabel(Text(viewModel.accessibilityLabelTitle))
                    .accessibilitySortPriority(1)
                    .scaledToFit()
                    .minimumScaleFactor(sizeCategory.isAccessibilityCategory ?
                                        Constants.accessibilityFontScale :
                                            Constants.defaultFontScale)
                if !viewModel.subtitle!.isEmpty {
                    Text(viewModel.subtitle!.trimmingCharacters(in: .whitespacesAndNewlines))
                        .alignmentGuide(.leading) { d in d[.leading] }
                        .foregroundColor(Constants.foregroundColor)
                        .lineLimit(1)
                        .font(AppFont.CircularStd.book.font(size: 10))
                        .accessibilityLabel(Text(viewModel.accessibilityLabelSubtitle))
                        .accessibilitySortPriority(2)
                        .scaledToFit()
                        .minimumScaleFactor(sizeCategory.isAccessibilityCategory ?
                                            Constants.accessibilityFontScale :
                                                Constants.defaultFontScale)
                }
            }
            Spacer()
            /* <CALL_SCREEN_HEADER_CUSTOM_BUTTONS:0> */
            if let customButton1ViewModel = viewModel.customButton1ViewModel {
                IconButton(viewModel: customButton1ViewModel)
                    .background(SourceViewSpace(sourceView: customButton1SourceView))
                    .accessibilityFocused($focusedOnCustomButton1, equals: true)
            }
            if let customButton2ViewModel = viewModel.customButton2ViewModel {
                IconButton(viewModel: customButton2ViewModel)
                    .background(SourceViewSpace(sourceView: customButton2SourceView))
                    .accessibilityFocused($focusedOnCustomButton2, equals: true)
            }
            /* </CALL_SCREEN_HEADER_CUSTOM_BUTTONS> */
            chatButton
                .padding(.trailing, 0)
            participantListButton
        }
        .padding(EdgeInsets(top: 8,
                            leading: 8,
                            bottom: 8,
                            trailing: 8))
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Constants.shapeCornerRadius))
        .padding(.bottom, Constants.hStackBottomPadding)
        .accessibilityElement(children: .contain)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 2)
    }

    var participantListButton: some View {
        IconButton(viewModel: viewModel.participantListButtonViewModel)
            .background(SourceViewSpace(sourceView: participantsListButtonSourceView))
            .accessibilityFocused($focusedOnParticipantList, equals: true)
    }
    
    var chatButton: some View {
        IconButton(viewModel: viewModel.chatButtonViewModel)
            .accessibilityFocused($focusedOnParticipantList, equals: true)
    }
}
