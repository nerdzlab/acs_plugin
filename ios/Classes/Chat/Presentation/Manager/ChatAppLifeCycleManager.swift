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

    init(logger: Logger) {
        self.logger = logger
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
    }

    @objc func didActivate(_ notification: Notification) {
        logger.debug("Did Activate")
    }
}
