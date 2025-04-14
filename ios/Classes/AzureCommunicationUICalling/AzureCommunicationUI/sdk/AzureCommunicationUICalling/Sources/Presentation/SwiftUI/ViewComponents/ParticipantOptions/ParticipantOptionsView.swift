//
//  ParticipantOptionsView.swift
//  Pods
//
//  Created by Yriy Malyts on 14.04.2025.
//

import Foundation
import SwiftUI
import FluentUI

internal struct ParticipantOptionsView: View {
    @ObservedObject var viewModel: ParticipantOptionsViewModel
    let avatarManager: AvatarViewManagerProtocol
    
    init(viewModel: ParticipantOptionsViewModel,
         avatarManager: AvatarViewManagerProtocol) {
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
                            title: viewModel.getParticipantName(),
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
