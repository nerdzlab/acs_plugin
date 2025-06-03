//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import SwiftUI
import FluentUI

struct BannerTextView: View {
    @ObservedObject var viewModel: BannerTextViewModel

    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif


            let titleText = Text(viewModel.title)
                .foregroundColor(.white)

            let bodyText = Text(" ") + Text(viewModel.body)
            let linkText = Text(" ") + Text(viewModel.linkDisplay).underline()

            (titleText + bodyText + linkText)
                .font(AppFont.CircularStd.medium.font(size: 18))
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text(viewModel.accessibilityLabel))
                .accessibilityAddTraits(.isLink)
                .onTapGesture {
                    if let url = URL(string: viewModel.link) {
                        UIApplication.shared.open(url)
                    }
                }
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        (UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero).insets
    }
}

extension EnvironmentValues {
    
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    
    var insets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}
