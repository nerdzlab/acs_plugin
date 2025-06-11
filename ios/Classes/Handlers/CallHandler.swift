//
//  CallHandler.swift
//  Pods
//
//  Created by Yriy Malyts on 12.05.2025.
//
import Flutter
import AzureCommunicationCalling
import AzureCommunicationCommon
import Foundation

final class CallHandler: MethodHandler {
    private enum Constants {
        enum FlutterEvents {
            static let onShowChat = "onShowChat"
            static let onCallUIClosed = "onCallUIClosed"
            static let onPluginStarted = "onPluginStarted"
            static let onUserCallEnded = "onUserCallEnded"
            static let onOneOnOneCallEnded = "onOneOnOneCallEnded"
        }
        
        enum MethodChannels {
            static let returnToCall = "returnToCall"
            static let initializeRoomCall = "initializeRoomCall"
            static let startOneOnOneCall = "startOneOnOneCall"
            static let startTeamsMeetingCall = "startTeamsMeetingCall"
            static let setUserData = "setUserData"
        }
    }
    
    private let onGetllComposite: () -> CallComposite?
    private let onSendEvent: (Event) -> Void
    
    private var isRealDevice: Bool {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }

    init(
        onGetllComposite: @escaping () -> CallComposite?,
        onSendEvent: @escaping (Event) -> Void
    ) {
        self.onGetllComposite = onGetllComposite
        self.onSendEvent = onSendEvent
    }

    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case Constants.MethodChannels.returnToCall:
            returnToCall()
            return true
            
        case Constants.MethodChannels.initializeRoomCall:
            if let arguments = call.arguments as? [String: Any],
               let roomId = arguments["roomId"] as? String,
               let callId = arguments["callId"] as? String,
               let whiteBoardId = arguments["whiteBoardId"] as? String,
               let isChatEnable = arguments["isChatEnable"] as? Bool,
               let isRejoin = arguments["isRejoin"] as? Bool
            {
                initializeRoomCall(
                    roomId: roomId,
                    callId: callId,
                    whiteBoardId: whiteBoardId,
                    isChatEnable: isChatEnable,
                    isRejoin: isRejoin,
                    result: result
                )
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token and roomId are required", details: nil))
            }
            
            return true
            
        case Constants.MethodChannels.startOneOnOneCall:
            if let arguments = call.arguments as? [String: Any],
               let participantsId = arguments["participantsId"] as? [String]
            {
                startOneOnOneCall(
                    participantsId: participantsId,
                    result: result
                )
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, participantId and userId are required", details: nil))
            }
            
            return true
            
        case Constants.MethodChannels.startTeamsMeetingCall:
            if let arguments = call.arguments as? [String: Any],
               let callId = arguments["callId"] as? String,
               let meetingLink = arguments["meetingLink"] as? String,
               let whiteBoardId = arguments["whiteBoardId"] as? String,
               let isChatEnable = arguments["isChatEnable"] as? Bool,
               let isRejoin = arguments["isRejoin"] as? Bool
            {
                startTeamsMeetingCall(
                    meetingLink: meetingLink,
                    callId: callId,
                    whiteBoardId: whiteBoardId,
                    isChatEnable: isChatEnable,
                    isRejoin: isRejoin,
                    result: result
                )
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token and roomId are required", details: nil))
            }
            
            return true
            
        default:
            return false
        }
    }

    private func initializeRoomCall(
        roomId: String,
        callId: String,
        whiteBoardId: String,
        isChatEnable: Bool,
        isRejoin: Bool,
        result: @escaping FlutterResult
    ) {
        let localOptions = LocalOptions(
            cameraOn: true,
            isChatEnable: isChatEnable,
            microphoneOn: true,
            skipSetupScreen: isRejoin,
            whiteBoardId: whiteBoardId,
            callId: callId
        )
        
        onGetllComposite()?.launch(locator: .roomCall(roomId: roomId), localOptions: localOptions)
    }
    
    private func startTeamsMeetingCall(
        meetingLink: String,
        callId: String,
        whiteBoardId: String,
        isChatEnable: Bool,
        isRejoin: Bool,
        result: @escaping FlutterResult
    ) {
        let localOptions = LocalOptions(
            cameraOn: false,
            isChatEnable: isChatEnable,
            microphoneOn: true,
            skipSetupScreen: isRejoin,
            whiteBoardId: whiteBoardId,
            callId: callId
        )
        
        onGetllComposite()?.launch(locator: .teamsMeeting(teamsLink: meetingLink), localOptions: localOptions)
    }
    
    private func startOneOnOneCall(
        participantsId: [String],
        result: @escaping FlutterResult
    ) {
        let localOptions = LocalOptions(
            cameraOn: false,
            isChatEnable: true,
            microphoneOn: true,
            skipSetupScreen: true
        )
        
        let participants = participantsId.map { CommunicationUserIdentifier($0) }
        
        onGetllComposite()?.launch(
            participants: participants,
            localOptions: localOptions
        )
    }
    
    private func returnToCall() {
        guard let callComposit = onGetllComposite() else { return }
        
        callComposit.isHidden = false
    }
    
    func subscribeToEvents(callComposite: CallComposite) {
        let callKitCallAccepted: (String) -> Void = { [weak callComposite] callId in
            let localOptions = LocalOptions(cameraOn: false, isChatEnable: true, microphoneOn: true, azureCorrelationId: callId)
            callComposite?.launch(callIdAcceptedFromCallKit: callId, localOptions: localOptions)
        }
        
        callComposite.events.onIncomingCallAcceptedFromCallKit = callKitCallAccepted
        
        let showChatEvent: (String?) -> Void = { [weak self] azureCorrelationId in
            if azureCorrelationId != nil {
                self?.onSendEvent(Event(name: Constants.FlutterEvents.onShowChat, payload: ["azureCorrelationId": azureCorrelationId]))
            } else {
                self?.onSendEvent(Event(name: Constants.FlutterEvents.onShowChat))
            }
        }
        
        callComposite.events.onShowUserChat = showChatEvent
        
        let callCompositDismissed: ((CallCompositeDismissed) -> Void)? = { [weak self] _ in
            self?.onSendEvent(Event(name: Constants.FlutterEvents.onCallUIClosed))
        }
        
        callComposite.events.onDismissed = callCompositDismissed
        
        let onPluginStarted: () -> Void = { [weak self] in
            self?.onSendEvent(Event(name: Constants.FlutterEvents.onPluginStarted))
        }
        
        callComposite.events.onPluginStarted = onPluginStarted
        
        let onUserCallEnded: () -> Void = { [weak self] in
            self?.onSendEvent(Event(name: Constants.FlutterEvents.onUserCallEnded))
        }
        
        callComposite.events.onUserCallEnded = onUserCallEnded
        
        let onOneOnOneCallEnded: () -> Void = { [weak self] in
            self?.onSendEvent(Event(name: Constants.FlutterEvents.onOneOnOneCallEnded))
        }
        
        callComposite.events.onOneOnOneCallEnded = onOneOnOneCallEnded
    }
}
