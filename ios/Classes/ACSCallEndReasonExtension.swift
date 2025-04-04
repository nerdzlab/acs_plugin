//
//  File.swift
//  Pods
//
//  Created by Yriy Malyts on 03.04.2025.
//


import Foundation
import AzureCommunicationCalling

extension CallEndReason {
    func toCompositeInternalError(_ wasCallConnected: Bool) -> CallCompositeInternalError? {
        let getTokenFailed: Int32 = 401
        let callCancelled: Int32 = 487
        let globallyDeclined: Int32 = 603

        let callEndErrorCode = self.code
        let callEndErrorSubCode = self.subcode

        var internalError: CallCompositeInternalError?
        switch callEndErrorCode {
        case 0:
            if callEndErrorSubCode == 5300 || callEndErrorSubCode == 5000,
               wasCallConnected {
                internalError = CallCompositeInternalError.callEvicted
            } else if callEndErrorSubCode == 5854 {
                internalError = CallCompositeInternalError.callDenied
            }
        case getTokenFailed:
            internalError = CallCompositeInternalError.callTokenFailed
        case callCancelled, globallyDeclined:
            // Call cancelled by user as a happy path
            break
        default:
            // For all other errorCodes:
            // https://docs.microsoft.com/en-us/azure/communication-services/concepts/troubleshooting-info
            internalError = wasCallConnected ? CallCompositeInternalError.callEndFailed
            : CallCompositeInternalError.callJoinFailed
        }

        return internalError
    }
}
