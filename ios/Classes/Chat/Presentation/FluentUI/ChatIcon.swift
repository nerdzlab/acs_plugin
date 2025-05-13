//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI

struct ChatIcon: View {
    var name: ChatCompositeIcon
    var size: CGFloat

    var body: some View {
        ChatStyleProvider.icon.getImage(for: name)
            .resizable()
            .frame(width: size, height: size, alignment: .center)
    }
}
