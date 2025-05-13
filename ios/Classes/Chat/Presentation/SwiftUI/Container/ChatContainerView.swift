//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct ChatContainerView: View {
    let viewFactory: ChatCompositeViewFactoryProtocol

    var body: some View {
        viewFactory.makeChatView()
    }
}
