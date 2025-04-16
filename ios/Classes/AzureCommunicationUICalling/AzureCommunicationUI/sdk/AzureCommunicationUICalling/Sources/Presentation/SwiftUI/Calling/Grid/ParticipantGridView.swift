//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct ParticipantGridView: View {
    @ObservedObject var viewModel: ParticipantGridViewModel
    let avatarViewManager: AvatarViewManagerProtocol
    let screenSize: ScreenSizeClassType
    @State var gridsCount: Int = 0
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        return Group {
            ParticipantGridLayoutView(viewModel: viewModel,
                                      rendererViewManager: viewModel.rendererViewManager,
                                      avatarViewManager: avatarViewManager,
                                      screenSize: screenSize,
                                      previousSpeaker: viewModel.previousSpeaker)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
            .id(gridsCount)
            .onReceive(viewModel.$gridsCount) {
                gridsCount = $0
            }
    }
}
