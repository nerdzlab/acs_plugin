//
//  CallCompositeInternalError.swift
//  Pods
//
//  Created by Yriy Malyts on 03.04.2025.
//


import Foundation

enum CallCompositeInternalError: Error, Equatable {
    case deviceManagerFailed(Error?)
    case callJoinConnectionFailed
    case callTokenFailed
    case callJoinFailed
    case callEndFailed
    case callHoldFailed
    case callResumeFailed
    case callEvicted
    case callDenied
    case callJoinFailedByMicPermission
    case cameraSwitchFailed
    case cameraOnFailed
    case networkConnectionNotAvailable
    case micNotAvailable
    case captionsNotActive
    case captionsStartFailedSpokenLanguageNotSupported
    case captionsStartFailedCallNotConnected

    func toCallCompositeErrorCode() -> String? {
        switch self {
        case .deviceManagerFailed:
            return CallCompositeErrorCode.cameraFailure
        case .callTokenFailed:
            return CallCompositeErrorCode.tokenExpired
        case .callJoinFailed, .callJoinConnectionFailed:
            return CallCompositeErrorCode.callJoin
        case .callEndFailed:
            return CallCompositeErrorCode.callEnd
        case .cameraOnFailed:
            return CallCompositeErrorCode.cameraFailure
        case .callJoinFailedByMicPermission:
            return CallCompositeErrorCode.microphonePermissionNotGranted
        case .networkConnectionNotAvailable:
            return CallCompositeErrorCode.networkConnectionNotAvailable
        case .captionsNotActive:
            return CallCompositeErrorCode.captionsNotActive
        case .captionsStartFailedCallNotConnected:
            return CallCompositeErrorCode.captionsStartFailedCallNotConnected
        case .captionsStartFailedSpokenLanguageNotSupported:
            return CallCompositeErrorCode.captionsStartFailedSpokenLanguageNotSupported
        case .callHoldFailed,
                .callResumeFailed,
                .callEvicted,
                .callDenied,
                .micNotAvailable,
                .cameraSwitchFailed:
            return nil
        }
    }

    func isFatalError() -> Bool {
        switch self {
        case .deviceManagerFailed,
                .callTokenFailed,
                .callJoinFailed,
                .callJoinFailedByMicPermission,
                .networkConnectionNotAvailable,
                .callEndFailed:
            return true
        case .callHoldFailed,
                .callResumeFailed,
                .callEvicted,
                .callDenied,
                .cameraSwitchFailed,
                .cameraOnFailed,
                .micNotAvailable,
                .captionsNotActive,
                .captionsStartFailedCallNotConnected,
                .captionsStartFailedSpokenLanguageNotSupported,
                .callJoinConnectionFailed:
            return false
        }
    }
}

extension CallCompositeInternalError {
    static func == (lhs: CallCompositeInternalError, rhs: CallCompositeInternalError) -> Bool {
        switch(lhs, rhs) {
        case (.deviceManagerFailed, .deviceManagerFailed),
            (.callJoinConnectionFailed, .callJoinConnectionFailed),
            (.callTokenFailed, .callTokenFailed),
            (.callJoinFailed, .callJoinFailed),
            (.callEndFailed, .callEndFailed),
            (.callHoldFailed, .callHoldFailed),
            (.callResumeFailed, .callResumeFailed),
            (.callEvicted, .callEvicted),
            (.callDenied, .callDenied),
            (.cameraSwitchFailed, .cameraSwitchFailed),
            (.networkConnectionNotAvailable, .networkConnectionNotAvailable),
            (.cameraOnFailed, .cameraOnFailed),
            (.micNotAvailable, .micNotAvailable),
            (.captionsNotActive, .captionsNotActive),
            (.captionsStartFailedSpokenLanguageNotSupported, .captionsStartFailedSpokenLanguageNotSupported),
            (.captionsStartFailedCallNotConnected, .captionsStartFailedCallNotConnected):
            return true
        default:
            return false
        }
    }
}
