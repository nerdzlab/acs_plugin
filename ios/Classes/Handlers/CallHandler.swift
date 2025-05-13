//
//  CallHandler.swift
//  Pods
//
//  Created by Yriy Malyts on 12.05.2025.
//
import Flutter
import AzureCommunicationCalling
import AzureCommunicationCommon

final class CallHandler: MethodHandler {
    private enum Constants {
        enum FlutterEvents {
            static let onShowChat = "onShowChat"
            static let onCallUIClosed = "onCallUIClosed"
            static let onPluginStarted = "onPluginStarted"
            static let onUserCallEnded = "onUserCallEnded"
        }
        
        enum MethodChannels {
            static let returnToCall = "returnToCall"
            static let initializeRoomCall = "initializeRoomCall"
            static let startOneOnOneCall = "startOneOnOneCall"
            static let setUserData = "setUserData"
        }
    }
    
    private let channel: FlutterMethodChannel
    private let onGetllComposite: () -> CallComposite?
    private let onSendEvent: (String) -> Void
    
    private var isRealDevice: Bool {
#if targetEnvironment(simulator)
        return false
#else
        return true
#endif
    }

    init(
        channel: FlutterMethodChannel,
        onGetllComposite: @escaping () -> CallComposite?,
        onSendEvent: @escaping (String) -> Void
    ) {
        self.channel = channel
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
               let token = arguments["token"] as? String,
               let roomId = arguments["roomId"] as? String,
               let userId = arguments["userId"] as? String,
               let isChatEnable = arguments["isChatEnable"] as? Bool,
               let isRejoin = arguments["isRejoin"] as? Bool
            {
                initializeRoomCall(token: token, roomId: roomId, userId: userId, isChatEnable: isChatEnable, isRejoin: isRejoin, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token and roomId are required", details: nil))
            }
            
            return true
            
        case Constants.MethodChannels.startOneOnOneCall:
            if let arguments = call.arguments as? [String: Any],
               let token = arguments["token"] as? String,
               let participantId = arguments["participantId"] as? String,
               let userId = arguments["userId"] as? String
            {
                startOneOnOneCall(token: token, participantId: participantId, userId: userId, result: result)
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, participantId and userId are required", details: nil))
            }
            
            return true
            
        default:
            return false
        }
    }

    private func initializeRoomCall(
        token: String,
        roomId: String,
        userId: String,
        isChatEnable: Bool,
        isRejoin: Bool,
        result: @escaping FlutterResult
    ) {
        let localOptions = LocalOptions(cameraOn: true, isChatEnable: isChatEnable, microphoneOn: true, skipSetupScreen: isRejoin)
        
        onGetllComposite()?.launch(locator: .roomCall(roomId: roomId), localOptions: localOptions)
        
//        onGetllComposite()?.launch(locator: .teamsMeeting(teamsLink: "https://teams.microsoft.com/l/meetup-join/19:meeting_NWM5YjYyYWUtNWNjYy00YjRhLWIwYWItYjg3YzkxOTMyZmEw@thread.v2/0?context=%7B%22Tid%22:%2241d68bdf-c355-4709-9c3f-40e323196d74%22,%22Oid%22:%2285555719-0dd7-410b-8f00-fa039800f874%22%7D"), localOptions: localOptions)
        
        //                callComposite.launch(locator: .teamsMeeting(teamsLink: "https://teams.microsoft.com/l/meetup-join/19%3ameeting_YWE4NzBkZTEtOGYzZC00ZWYyLWIzMTItYTc0ODgwODQ1ODk3%40thread.v2/0?context=%7b%22Tid%22%3a%22e16f27b3-237b-4547-9aa2-7f2dc7fc9aaf%22%2c%22Oid%22%3a%22843c6f37-5ffc-48e0-9d01-e8e5126b4f6f%22%7d"), localOptions: localOptions)
    }
    
    private func startOneOnOneCall(
        token: String,
        participantId: String,
        userId: String,
        result: @escaping FlutterResult
    ) {
        let localOptions = LocalOptions(cameraOn: true, microphoneOn: true)
        
        onGetllComposite()?.launch(
            participants: [CommunicationUserIdentifier(participantId)],
            localOptions: localOptions
        )
    }
    
    private func returnToCall() {
        guard let callComposit = onGetllComposite() else { return }
        
        callComposit.isHidden = false
    }
    
    func subscribeToEvents(callComposite: CallComposite) {
        let localOptions = LocalOptions(cameraOn: true, microphoneOn: true)
        
        let callKitCallAccepted: (String) -> Void = { [weak callComposite] callId in
            callComposite?.launch(callIdAcceptedFromCallKit: callId, localOptions: localOptions)
        }
        
        callComposite.events.onIncomingCallAcceptedFromCallKit = callKitCallAccepted
        
        let showChatEvent: () -> Void = { [weak self] in
            self?.onSendEvent(Constants.FlutterEvents.onShowChat)
        }
        
        callComposite.events.onShowUserChat = showChatEvent
        
        let callCompositDismissed: ((CallCompositeDismissed) -> Void)? = { [weak self] _ in
            self?.onSendEvent(Constants.FlutterEvents.onCallUIClosed)
        }
        
        callComposite.events.onDismissed = callCompositDismissed
        
        let onPluginStarted: () -> Void = { [weak self] in
            self?.onSendEvent(Constants.FlutterEvents.onPluginStarted)
        }
        
        callComposite.events.onPluginStarted = onPluginStarted
        
        let onUserCallEnded: () -> Void = { [weak self] in
            self?.onSendEvent(Constants.FlutterEvents.onUserCallEnded)
        }
        
        callComposite.events.onUserCallEnded = onUserCallEnded
    }
}
