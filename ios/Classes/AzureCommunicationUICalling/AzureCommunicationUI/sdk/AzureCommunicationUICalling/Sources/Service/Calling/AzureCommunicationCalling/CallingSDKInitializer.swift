//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import AzureCommunicationCalling
import Foundation

internal class CallingSDKInitializer: NSObject {
    // native calling SDK keeps single reference of call agent
    // this is to ensure that we don't create multiple call agents
    // destroying call agent is time consuming and we don't want to do it
    private var callClient: CallClient?
    private var callAgent: CallAgent?
    private var incomingCall: AzureCommunicationCalling.IncomingCall?
    private var displayName: String?
    private var callKitOptions: CallKitOptions?
    private var disableInternalPushForIncomingCall = false
    private var tags: [String]
    private var credential: CommunicationTokenCredential
    private var logger: Logger
    private var events: CallComposite.Events
    private var onCallAdded: (String) -> Void

    init(tags: [String],
         credential: CommunicationTokenCredential,
         callKitOptions: CallKitOptions?,
         displayName: String? = nil,
         disableInternalPushForIncomingCall: Bool,
         logger: Logger,
         events: CallComposite.Events,
         onCallAdded: @escaping (String) -> Void) {
        self.logger = logger
        self.tags = tags
        self.credential = credential
        self.callKitOptions = callKitOptions
        self.displayName = displayName
        self.disableInternalPushForIncomingCall = disableInternalPushForIncomingCall
        self.events = events
        self.onCallAdded = onCallAdded
    }
    
    deinit {
        callClient?.dispose()
        callAgent?.dispose()
    }

    func getIncomingCall() -> AzureCommunicationCalling.IncomingCall? {
        return incomingCall
    }

    func setupCallClient() -> CallClient {
        if self.callClient == nil {
            self.callClient = makeCallClient()
        }
        return self.callClient!
    }
    
    func updateDisplayName(_ displayName: String?) {
        self.displayName = displayName
    }

    func setupCallAgent(isNeedRenewCallAgent: Bool) async throws -> CallAgent {
        //MTODO need to think about display name after call agent created
//        self.callAgent = nil
        
        //перепідписатися на пушки спробувати
        
        if isNeedRenewCallAgent {
            self.callAgent = nil
        }
        
        if let existingCallAgent = self.callAgent {
                logger.debug("Reusing call agent")
                return existingCallAgent
        }
        
//        callAgent.
        
        
        let callClient = setupCallClient()
        let options = CallAgentOptions()
        options.disableInternalPushForIncomingCall = disableInternalPushForIncomingCall
        if let providerConfig = callKitOptions?.providerConfig {
            let sdkCallKitOptions = configureSDKCallKitOptions(with: providerConfig)
            options.callKitOptions = sdkCallKitOptions
        }
        if let displayName = displayName {
            options.displayName = displayName
        }
        do {
            let callAgent = try await callClient.createCallAgent(
                userCredential: credential,
                options: options
            )
            self.callAgent = callAgent
            callAgent.delegate = self
            
            if isNeedRenewCallAgent {
                //need event to  inform about call agent updating
            }
            
            return callAgent
        }
        catch {
            logger.error("It was not possible to create a call agent.")
            throw error
        }
    }

    func registerPushNotification(deviceRegistrationToken: Data,
                                  completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        Task {
            do {
                let callAgent = try await setupCallAgent(isNeedRenewCallAgent: false)
                try await callAgent.registerPushNotifications(
                    deviceToken: deviceRegistrationToken)
                completionHandler?(.success(()))
            } catch {
                logger.error("Failed to registerPushNotification")
                completionHandler?(.failure(error))
            }
        }
    }

    func unregisterPushNotifications(completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        Task {
            do {
                let callAgent = try await setupCallAgent(isNeedRenewCallAgent: false)
                try await callAgent.unregisterPushNotification()
                completionHandler?(.success(()))
            } catch {
                logger.error("Failed to unregisterPushNotification")
                completionHandler?(.failure(error))
            }

        }
     }

    static func reportIncomingCall(pushNotification: PushNotification,
                                   callKitOptions: CallKitOptions,
                                   completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        let sdkCallKitOptions = AzureCommunicationCalling.CallKitOptions(with: callKitOptions.providerConfig)
        sdkCallKitOptions.isCallHoldSupported = callKitOptions.isCallHoldSupported
        sdkCallKitOptions.configureAudioSession = callKitOptions.configureAudioSession
        if let provideRemoteInfo = callKitOptions.provideRemoteInfo {
            sdkCallKitOptions.provideRemoteInfo = { (callerInfo: AzureCommunicationCalling.CallerInfo) -> AzureCommunicationCalling.CallKitRemoteInfo in
                let info = provideRemoteInfo(Caller(displayName: callerInfo.displayName, identifier: callerInfo.identifier))
                let callKitRemoteInfo = AzureCommunicationCalling.CallKitRemoteInfo()
                callKitRemoteInfo.displayName = info.displayName
                callKitRemoteInfo.handle = info.handle
                return callKitRemoteInfo
            }
        }
        let pushNotificationInfo = PushNotificationInfo.fromDictionary(pushNotification.data)
        CallClient.reportIncomingCall(
            with: pushNotificationInfo,
            callKitOptions: sdkCallKitOptions
        ) { error in
            if let error = error {
                completionHandler?(.failure(error))
            } else {
                completionHandler?(.success(()))
            }
        }
    }

    func handlePushNotification(pushNotification: PushNotification,
                                completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        let pushNotificationInfo = PushNotificationInfo.fromDictionary(pushNotification.data)
        if let providerConfig = callKitOptions?.providerConfig {
            let sdkCallKitOptions = configureSDKCallKitOptions(with: providerConfig)
            CallClient.reportIncomingCall(with: pushNotificationInfo, callKitOptions: sdkCallKitOptions) { error in
                if let error = error {
                    completionHandler?(.failure(error))
                } else {
                    self.handlePushNotificationAsync(pushNotificationInfo: pushNotificationInfo,
                                                     completionHandler: completionHandler)
                }
            }
        } else {
            handlePushNotificationAsync(pushNotificationInfo: pushNotificationInfo,
                                        completionHandler: completionHandler)
        }
    }

    private func configureSDKCallKitOptions(with providerConfig: CXProviderConfiguration) ->
    AzureCommunicationCalling.CallKitOptions {
        let sdkCallKitOptions = AzureCommunicationCalling.CallKitOptions(with: providerConfig)
        sdkCallKitOptions.isCallHoldSupported = callKitOptions?.isCallHoldSupported ?? false
        sdkCallKitOptions.configureAudioSession = callKitOptions?.configureAudioSession
        if let provideRemoteInfo = callKitOptions?.provideRemoteInfo {
            sdkCallKitOptions.provideRemoteInfo = { (callerInfo: AzureCommunicationCalling.CallerInfo) in
                let info = provideRemoteInfo(Caller(displayName: callerInfo.displayName,
                                                    identifier: callerInfo.identifier))
                let callKitRemoteInfo = AzureCommunicationCalling.CallKitRemoteInfo()
                callKitRemoteInfo.displayName = info.displayName
                callKitRemoteInfo.handle = info.handle
                return callKitRemoteInfo
            }
        }
        return sdkCallKitOptions
    }

    private func handlePushNotificationAsync(pushNotificationInfo: PushNotificationInfo,
                                             completionHandler: ((Result<Void, Error>) -> Void)?) {
        Task {
            do {
                let callAgent = try await self.setupCallAgent(isNeedRenewCallAgent: false)
                try await callAgent.handlePush(notification: pushNotificationInfo)
                completionHandler?(.success(()))
            } catch {
                self.logger.error("Failed to handle push notification")
                completionHandler?(.failure(error))
            }
        }
    }

    func reject(incomingCallId: String, completionHandler: ((Result<Void, Error>) -> Void)? = nil) {
        if incomingCall == nil ||
            incomingCall?.id != incomingCallId {
            completionHandler?(.failure(IncomingCallError.callIdNotFound))
        }
        incomingCall?.reject { error in
            if let error = error {
                completionHandler?(.failure(error))
            } else {
                self.incomingCall?.delegate = nil
                self.incomingCall = nil
                completionHandler?(.success(()))
            }
        }
    }

    func dispose() {
        incomingCall?.delegate = nil
        incomingCall = nil
        self.callAgent?.delegate = nil
        self.callAgent?.dispose()
        self.callAgent = nil
        self.callClient = nil
    }

    func onIncomingCallAccpeted() {
        incomingCall?.delegate = nil
        incomingCall = nil
    }
    
    func showChat(azureCorrelationId: String?) {
        events.onShowUserChat?(azureCorrelationId)
    }
    
    func requestScreenSharing() {
        events.onStartScreenSharing?()
    }
    
    func requestStopSharing() {
        events.onStopScreenSharing?()
    }

    private func makeCallClient() -> CallClient {
        let clientOptions = CallClientOptions()
        let appendingTag = tags
        let diagnostics = clientOptions.diagnostics ?? CallDiagnosticsOptions()
        diagnostics.tags.append(contentsOf: appendingTag)
        clientOptions.diagnostics = diagnostics
        return CallClient(options: clientOptions)
    }
}

extension CallingSDKInitializer: CallAgentDelegate {
    public func callAgent(_ callAgent: CallAgent, didUpdateCalls args: CallsUpdatedEventArgs) {
        if !args.addedCalls.isEmpty {
            if let call = args.addedCalls.first {
                let callId = call.id
                self.logger.debug("on calls update received \(callId)")
                self.onCallAdded(callId)
            }
        }
    }

    public func callAgent(_ callAgent: CallAgent,
                          didRecieveIncomingCall incomingCall: AzureCommunicationCalling.IncomingCall) {
        self.incomingCall = incomingCall
        incomingCall.delegate = self
        self.logger.debug("incoming сall received \(incomingCall.id)")
        let incomingCallInfo = IncomingCall(
            callId: incomingCall.id,
            callerDisplayName: incomingCall.callerInfo.displayName,
            callerIdentifier: incomingCall.callerInfo.identifier)
        guard let onIncomingCallEventHandler = events.onIncomingCall else {
            return
        }
        onIncomingCallEventHandler(incomingCallInfo)
    }
}

extension CallingSDKInitializer: IncomingCallDelegate {
    func incomingCall(_ incomingCall: AzureCommunicationCalling.IncomingCall, didEnd args: PropertyChangedEventArgs) {
        guard let onIncomingCallCancelled = events.onIncomingCallCancelled,
              let callEndReason = incomingCall.callEndReason else {
            return
        }
        let callCancelled = IncomingCallCancelled(
            callId: incomingCall.id,
            code: Int(callEndReason.code),
            subCode: Int(callEndReason.subcode)
        )
        onIncomingCallCancelled(callCancelled)
    }
}
