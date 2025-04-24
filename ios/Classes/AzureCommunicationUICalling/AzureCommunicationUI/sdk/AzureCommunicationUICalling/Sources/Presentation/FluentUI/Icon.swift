//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import Foundation

struct Icon: View {
    var name: CompositeIcon?
    var uiImage: UIImage?
    var size: CGFloat
    var renderAsOriginal: Bool

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        if let uiImage = uiImage {
            Image(uiImage: uiImage)
                .renderingMode(renderAsOriginal ? .original : .template)
                .resizable()
                .frame(width: size, height: size, alignment: .center)
            
        }
        if let name = name {
            StyleProvider.icon.getImage(for: name)
                .renderingMode(renderAsOriginal ? .original : .template)
                .resizable()
                .frame(width: size, height: size, alignment: .center)
        }
    }
}
