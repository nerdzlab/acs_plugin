//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

protocol ChatCompositeViewFactoryProtocol {
    func makeChatView() -> ChatView
}

struct ChatCompositeViewFactory: ChatCompositeViewFactoryProtocol {
    private let logger: Logger
    private let compositeViewModelFactory: ChatCompositeViewModelFactoryProtocol

    init(logger: Logger,
         compositeViewModelFactory: ChatCompositeViewModelFactoryProtocol) {
        self.logger = logger
        self.compositeViewModelFactory = compositeViewModelFactory
    }

    func makeChatView() -> ChatView {
        return ChatView(viewModel: compositeViewModelFactory.getChatViewModel())
    }
}
