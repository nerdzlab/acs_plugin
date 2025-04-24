//
//  ParticipantOptionsView.swift
//  Pods
//
//  Created by Yriy Malyts on 15.04.2025.
//


import SwiftUI
import FluentUI

internal struct LayoutOptionsView: View {
    @ObservedObject var viewModel: LayoutOptionsViewModel
    let avatarManager: AvatarViewManagerProtocol
    
    init(viewModel: LayoutOptionsViewModel, avatarManager: AvatarViewManagerProtocol) {
        self.viewModel = viewModel
        self.avatarManager = avatarManager
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        Group {
            DrawerListView(
                sections: [
                    DrawerListSection(
                        header: TitleDrawerListItemViewModel(
                            title: viewModel.getOptionsTitle(),
                            accessibilityIdentifier: "??"),
                        items: viewModel.items
                    )
                ],
                withDivider: true,
                avatarManager: avatarManager
            )
        }
    }
}
