////
////  Copyright (c) Microsoft Corporation. All rights reserved.
////  Licensed under the MIT License.
////
//
//import Foundation
//import SwiftUI
//import FluentUI
//
//internal struct ParticipantsListView: View {
//    @ObservedObject var viewModel: ParticipantsListViewModel
//    let avatarManager: AvatarViewManagerProtocol
//    init(viewModel: ParticipantsListViewModel,
//         avatarManager: AvatarViewManagerProtocol) {
//        self.viewModel = viewModel
//        self.avatarManager = avatarManager
//    }
//
//    var body: some View {
//#if DEBUG
//        let _ = Self._printChanges()
//#endif
//
//        var sections: [DrawerListSection] = []
//
//        // Include Lobby Participants if in VM
//        if viewModel.lobbyParticipants.count > 0 {
//            sections.append(DrawerListSection(
//                header: viewModel.lobbyParticipantsTitle,
//                items: viewModel.lobbyParticipants))
//
//        }
//
//        sections.append(DrawerListSection(
//                header: viewModel.meetingParticipantsTitle,
//                items: viewModel.meetingParticipants))
//
//        return DrawerListView(sections: sections,
//                              withDivider: false,
//                              avatarManager: avatarManager)
//    }
//}

import Foundation
import SwiftUI
import FluentUI

internal struct ParticipantsListView: View {
    @ObservedObject var viewModel: ParticipantsListViewModel
    let avatarManager: AvatarViewManagerProtocol
    
    @State private var scrollViewContentSize: CGSize = .zero
    
    private let maxHeightRatio: CGFloat = 0.7
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        ScrollView {
            LazyVStack(spacing: 6, pinnedViews: .sectionHeaders) {
                if !viewModel.lobbyParticipants.isEmpty {
                    participantSection(
                        header: viewModel.lobbyParticipantsTitle,
                        items: viewModel.lobbyParticipants
                    )
                }
                
                participantSection(
                    header: viewModel.meetingParticipantsTitle,
                    items: viewModel.meetingParticipants
                )
            }
            .padding(.vertical, 16)
            .background(scrollGeometry)
            .padding(.horizontal, 6)
        }
        .frame(maxHeight: min(scrollViewContentSize.height, UIScreen.main.bounds.height * maxHeightRatio))
    }
    
    // MARK: - Section Builder
    
    @ViewBuilder
    private func participantSection(header: BaseDrawerItemViewModel?, items: [BaseDrawerItemViewModel]) -> some View {
        Section(
            header: inflateHeader(header)
                .accessibilityElement(children: .combine)
        ) {
            ForEach(0..<items.count, id: \.self) { index in
                if let participant = items[index] as? ParticipantsListCellViewModel {
                    participantRow(participant)
                }
            }
        }
    }
    
    // MARK: - Row View
    
    @ViewBuilder
    private func participantRow(_ participant: ParticipantsListCellViewModel) -> some View {
        VStack(spacing: 6) {
            DrawerParticipantView(item: participant, avatarManager: avatarManager)
                .accessibilityElement(children: .combine)
        }
    }
    
    // MARK: - Header View
    
    @ViewBuilder
    private func inflateHeader(_ header: BaseDrawerItemViewModel?) -> some View {
        if let titleItem = header as? TitleDrawerListItemViewModel {
            VStack(spacing: 0) {
                DrawerTitleView(item: titleItem)
                
                if let share = viewModel.shareMeetingLink as? DrawerListItemViewModel {
                    DrawerListItemView(item: share)
                        .padding(.leading, 6)
                        .padding(.top, 10)
                        .padding(.bottom, 6)
                    Divider()
                        .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
                }
            }
            .background(Color.white)
        } else {
            EmptyView()
        }
    }
    
    // MARK: - Geometry Reader for Height
    
    private var scrollGeometry: some View {
        GeometryReader { geometry in
            Color.clear
                .onAppear {
                    DispatchQueue.main.async {
                        scrollViewContentSize = geometry.size
                    }
                }
                .onChange(of: geometry.size) { _ in
                    DispatchQueue.main.async {
                        withAnimation {
                            scrollViewContentSize = geometry.size
                        }
                    }
                }
        }
    }
}
