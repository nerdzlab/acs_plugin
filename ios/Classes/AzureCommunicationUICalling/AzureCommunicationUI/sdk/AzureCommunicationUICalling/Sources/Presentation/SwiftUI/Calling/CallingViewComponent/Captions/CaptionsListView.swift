//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI
import FluentUI

internal struct CaptionsListView: View {
    @ObservedObject var viewModel: CaptionsListViewModel
    let avatarManager: AvatarViewManagerProtocol

    init(viewModel: CaptionsListViewModel,
         avatarManager: AvatarViewManagerProtocol) {
        self.viewModel = viewModel
        self.avatarManager = avatarManager
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        DrawerListView(sections: [DrawerListSection(header: nil, items: viewModel.items)],
                       avatarManager: avatarManager)
    }
}
