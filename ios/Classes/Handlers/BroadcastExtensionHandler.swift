//
//  CallHandler 2.swift
//  Pods
//
//  Created by Yriy Malyts on 12.05.2025.
//


import Flutter
import ReplayKit
import UIKit
import AzureCommunicationCalling
import AzureCommunicationCommon
import PushKit

final class BroadcastExtensionHandler: MethodHandler {
    
    private var logger: Logger = DefaultLogger(category: "Calling")
    
    struct BroadcastExtensionData {
        let appGroupIdentifier: String
        let extensionBubdleId: String
    }
    
    private enum Constants {
        enum Broadcast {
            static let socketName = "socet.rtc_SSFD"
        }
        
        enum FlutterEvents {
            static let onStopScreenShare = "onStopScreenShare"
            static let onStartScreenShare = "onStartScreenShare"
        }
        
        enum MethodChannels {
            static let setBroadcastExtensionData = "setBroadcastExtensionData"
        }
    }
    
    private let onGetllComposite: () -> CallComposite?
    private let onSendEvent: (Event) -> Void
    
    private var client: Client!
    
    private var broadcastExtensionData: BroadcastExtensionData? {
        didSet {
            // Need to save this, to have access when app launch by call kit, to get access to shared UserDefaults by appGroup
            if broadcastExtensionData != nil {
                UserDefaults.standard.setAppGroupIdentifier(broadcastExtensionData!.appGroupIdentifier)
            }
        }
    }
    
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
        self.startListenBroadcastEvents()
    }

    func handle(call: FlutterMethodCall, result: @escaping FlutterResult) -> Bool {
        switch call.method {
        case Constants.MethodChannels.setBroadcastExtensionData:
            if let arguments = call.arguments as? [String: Any],
               let appGroupIdentifier = arguments["appGroupIdentifier"] as? String,
               let extensionBubdleId = arguments["extensionBubdleId"] as? String
            {
                self.broadcastExtensionData = BroadcastExtensionData(
                    appGroupIdentifier: appGroupIdentifier,
                    extensionBubdleId: extensionBubdleId
                )
                
            } else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Token, name and userId are required", details: nil))
            }
            return true
            
        default:
            return false
        }
    }
    
    private func startBroadcastSession() {
        guard let broadcastExtensionData = broadcastExtensionData else {
            return
        }
        
        DispatchQueue.main.async {
            let pickerView = RPSystemBroadcastPickerView(
                frame: CGRect(x: 0, y: 0, width: 0, height: 0)
            )
            
            pickerView.showsMicrophoneButton = false
            pickerView.preferredExtension = broadcastExtensionData.extensionBubdleId
            (pickerView.subviews.first as? UIButton)?.sendActions(for: .touchUpInside)
        }
    }

    private func stopBroadcastSession() {
        DarwinNotificationCenter.shared.postNotification(.stopBroadcast)
    }
    
    private func startListenBroadcastEvents() {
        DarwinNotificationCenter.shared.subscribe(.startBroadcast, observer: self) { [weak self] in
            guard let self = self else { return }
            
            self.onSendEvent(Event(name: Constants.FlutterEvents.onStartScreenShare))
            
            guard let broadcastExtensionData = broadcastExtensionData else {
                return
            }
            
            self.client = Client(appGroup: broadcastExtensionData.appGroupIdentifier, socketName: Constants.Broadcast.socketName)
            self.client.connect()
            self.listenBufferData()
            
            guard let callComposite = self.onGetllComposite() else { return }
            
            Task {
                await callComposite.startScreenSharing()
            }
        }
        
        DarwinNotificationCenter.shared.subscribe(.stopBroadcast, observer: self) { [weak self] in
            guard let self = self else { return }
            
            self.client.stop()
            self.onSendEvent(Event(name: Constants.FlutterEvents.onStopScreenShare))
            
            guard let callComposite = self.onGetllComposite() else { return }
            
            Task {
                await callComposite.stopScreenSharing()
            }
        }
    }
    
    func subscribeToEvents(callComposite: CallComposite) {
        let onStartScreenSharing: () -> Void = { [weak self] in
            self?.startBroadcastSession()
        }
        
        callComposite.events.onStartScreenSharing = onStartScreenSharing
        
        let onStopScreenSharing: () -> Void = { [weak self] in
            self?.stopBroadcastSession()
        }
        
        callComposite.events.onStopScreenSharing = onStopScreenSharing
    }
    
    public func listenBufferData() {
        self.logger.debug("Start listen buffer data")
        
        client.onBufferReceived = { [weak self] data in
            self?.logger.debug("Received buffer data")
            
            guard let callComposite = self?.onGetllComposite(), let buffer = data else {
                self?.logger.debug("callComposite or data is nil, ignore buffer data")
                return
            }
            
            callComposite.sendVideoBuffer(sampleBuffer: buffer)
        }
    }
}
