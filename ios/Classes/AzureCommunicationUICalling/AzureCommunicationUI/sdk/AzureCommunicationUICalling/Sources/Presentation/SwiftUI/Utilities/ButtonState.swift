//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

protocol ButtonState: Equatable {
    var iconName: CompositeIcon { get }
    var localizationKey: LocalizationKey { get }
}
