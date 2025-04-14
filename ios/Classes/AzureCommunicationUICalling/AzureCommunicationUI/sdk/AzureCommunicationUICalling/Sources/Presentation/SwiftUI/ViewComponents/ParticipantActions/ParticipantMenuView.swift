//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI
import FluentUI

internal struct ParticipantMenuView: View {
    @ObservedObject var viewModel: ParticipantMenuViewModel
    let avatarManager: AvatarViewManagerProtocol

    init(viewModel: ParticipantMenuViewModel,
         avatarManager: AvatarViewManagerProtocol) {
        self.viewModel = viewModel
        self.avatarManager = avatarManager
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        DrawerListView(sections: [DrawerListSection(header: nil, items: viewModel.items)], withDivider: true,
                       avatarManager: avatarManager)
    }
}
