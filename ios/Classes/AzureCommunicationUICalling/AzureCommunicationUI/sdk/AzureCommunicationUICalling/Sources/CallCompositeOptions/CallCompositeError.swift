//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import UIKit

/// Call Composite runtime error types.
public struct CallCompositeErrorCode {
    /// Error when local user fails to join a call.
    public static let callJoin: String = "callJoin"

    /// Error when a call disconnects unexpectedly or fails on ending.
    public static let callEnd: String = "callEnd"

    /// Error when camera failed to start or stop
    public static let cameraFailure: String = "cameraFailure"

    /// Error when the input token is expired.
    public static let tokenExpired: String = "tokenExpired"

    /// Error when microphone did not have the permission and join call failed.
    public static let microphonePermissionNotGranted: String = "microphonePermissionNotGranted"

    /// Error when internet is unavailable and call join fails
    public static let networkConnectionNotAvailable: String = "networkConnectionNotAvailable"

    /// Captions not active. To change caption language, captions must be active.
    public static let captionsNotActive: String = "captionsNotActive"

    /// Error when captions start failed because spoken language is not supported.
    public static let captionsStartFailedSpokenLanguageNotSupported: String =
    "captionsStartFailedSpokenLanguageNotSupported"

    /// Error when failed to start captions. Call state is not connected.
    public static let captionsStartFailedCallNotConnected: String = "captionsStartFailedCallNotConnected"

    /// Error when a participant is evicted from the call by another participant
    static let callEvicted: String = "callEvicted"

    /// Error when a participant is denied from entering the call
    static let callDenied: String = "callDenied"

    /// Error when local user fails to hold a call.
    static let callHold: String = "callHold"

    /// Error when local user fails to resume a call.
    static let callResume: String = "callResume"

    /// Communication token credential not set.
    public static let communicationTokenCredentialNotSet: String = "communicationTokenCredentialNotSet"
    
    /// Error when local user raise hand.
    public static let raiseHand: String = "raiseHand"
    
    /// Error when local user lower hand.
    public static let lowerHand: String = "lowerHand"
    
    /// Error when local user start screen share.
    public static let startScreenShareFailure: String = "startScreenShareFailure"
    
    /// Error when local user stop screen share.
    public static let stopScreenShareFailure: String = "stopScreenShareFailure"
}

/// The error thrown after Call Composite launching.
public struct CallCompositeError {

    /// The string representing the CallCompositeErrorCode.
    public let code: String

    /// The NSError returned from Azure Communication SDK.
    public let error: Error?
}

extension CallCompositeError: Equatable {
    public static func == (lhs: CallCompositeError, rhs: CallCompositeError) -> Bool {
        if let error1 = lhs.error as NSError?,
           let error2 = rhs.error as NSError? {
            return error1.domain == error2.domain
                && error1.code == error2.code
                && "\(error1.description)" == "\(error2.description)"
                && lhs.code == rhs.code
        }

        return false
    }
}
