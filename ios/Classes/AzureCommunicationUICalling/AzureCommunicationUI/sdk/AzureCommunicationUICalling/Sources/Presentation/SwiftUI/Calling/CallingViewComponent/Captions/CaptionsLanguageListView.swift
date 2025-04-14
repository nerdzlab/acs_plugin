//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI
import UIKit

internal struct CaptionsLanguageListView: View {
    @ObservedObject var viewModel: CaptionsLanguageListViewModel
    let avatarManager: AvatarViewManagerProtocol

    init(viewModel: CaptionsLanguageListViewModel,
         avatarManager: AvatarViewManagerProtocol) {
        self.viewModel = viewModel
        self.avatarManager = avatarManager
    }

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        DrawerListView(sections: [DrawerListSection(header: nil, items: viewModel.items)], withDivider: false,
                       avatarManager: avatarManager)
    }
}
