//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import UIKit
import Combine

protocol ChatLifeCycleManagerProtocol {

}

class ChatUIKitAppLifeCycleManager: ChatLifeCycleManagerProtocol {

    private let logger: Logger
    private let store: Store<ChatAppState, ActionChat>

    var cancellables = Set<AnyCancellable>()

    init(store: Store<ChatAppState, ActionChat>,
         logger: Logger) {
        self.logger = logger
        self.store = store
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willDeactivate),
                                               name: UIScene.willDeactivateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didActivate),
                                               name: UIScene.didActivateNotification,
                                               object: nil)
    }

    @objc func willDeactivate(_ notification: Notification) {
        logger.debug("Will Deactivate")
        store.dispatch(action: .lifecycleAction(.backgroundEntered))
    }

    @objc func didActivate(_ notification: Notification) {
        logger.debug("Did Activate")
        store.dispatch(action: .lifecycleAction(.foregroundEntered))
    }
}
