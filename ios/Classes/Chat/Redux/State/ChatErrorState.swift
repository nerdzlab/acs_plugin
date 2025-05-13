//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

enum ChatErrorCategory {
    case fatal
    case chatState
    case trouter
    case none
}

struct ChatErrorState: Equatable {
    // errorType would be nil for no error status
    let internalError: ChatCompositeInternalError?
    let error: Error?
    let errorCategory: ChatErrorCategory

    init(internalError: ChatCompositeInternalError? = nil,
         error: Error? = nil,
         errorCategory: ChatErrorCategory = .none) {
        self.internalError = internalError
        self.error = error
        self.errorCategory = errorCategory
    }

    static func == (lhs: ChatErrorState, rhs: ChatErrorState) -> Bool {
        return (lhs.internalError?.rawValue == rhs.internalError?.rawValue)
    }
}
