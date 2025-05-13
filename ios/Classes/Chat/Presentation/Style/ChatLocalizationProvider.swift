//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI

protocol ChatLocalizationProviderProtocol: ChatBaseLocalizationProviderProtocol {
    var isRightToLeft: Bool { get }
    func getLocalizedString(_ key: ChatLocalizationKey) -> String
    func getLocalizedString(_ key: ChatLocalizationKey, _ args: CVarArg...) -> String
}

class ChatLocalizationProvider: ChatBaseLocalizationProvider, ChatLocalizationProviderProtocol {
    init(logger: Logger) {
        super.init(logger: logger, bundleClass: ChatAdapter.self)
    }
}
