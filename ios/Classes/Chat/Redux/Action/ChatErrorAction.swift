//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum ChatErrorAction: Equatable {
    case fatalErrorUpdated(internalError: ChatCompositeInternalError, error: Error?)

    static func == (lhs: ChatErrorAction, rhs: ChatErrorAction) -> Bool {
        switch (lhs, rhs) {
        case let (.fatalErrorUpdated(internalError: lErr, error: _),
                  .fatalErrorUpdated(internalError: rErr, error: _)):
            return lErr == rErr
        }
    }
}
