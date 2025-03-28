//
//  CallHandler.swift
//  Pods
//
//  Created by Yriy Malyts on 27.03.2025.
//

import Foundation
import AzureCommunicationCalling
import AVFoundation
import Flutter

final class CallHandler: NSObject, CallAgentDelegate {
//    public var callClient: CallClient?
//    public var initialized: Bool = false
//    private weak var callService: CallService?
//        
//    // This method will be used to send errors back to Flutter
//    private var result: FlutterResult?
//    
//    private static var instance: CallHandler?
//    static func getOrCreateInstance() -> CallHandler {
//        if let c = instance {
//            return c
//        }
//        instance = CallHandler()
//        return instance!
//    }
//    
//    private override init() {}
//    
//    public func callAgent(_ callAgent: CallAgent, didUpdateCalls args: CallsUpdatedEventArgs) {
//        if let removedCall = args.removedCalls.first {
//            callService?.callRemoved(removedCall)
//            debugPrint("Error____ Call removed")
//            result?(FlutterError(code: "Error", message: "Call removed", details: nil))
//        }
//    }
//    
//    public func initializeCall(token: String, callService: CallService, result: @escaping FlutterResult) {
//        if self.initialized {
//            debugPrint("Success___ Already initialized")
//            result("Already initialized")
//            return
//        }
//        
//        self.callService = callService
//        
//        self.result = result
//                
//        var userCredential: CommunicationTokenCredential
//        do {
//            userCredential = try CommunicationTokenCredential(token: token)
//        } catch {
//            debugPrint("Error____ Failed to create CommunicationTokenCredential")
//            result(FlutterError(code: "CREDENTIAL_ERROR", message: "Failed to create CommunicationTokenCredential", details: nil))
//            return
//        }
//        
//        self.callClient = CallClient()
//        
//        self.callClient!.getDeviceManager { (deviceManager, error) in
//            if let error = error {
//                debugPrint("Error____ Failed to get DeviceManager \(error.localizedDescription)")
//                self.result?(FlutterError(code: "DEVICE_MANAGER_ERROR", message: "Failed to get DeviceManager", details: error.localizedDescription))
//                return
//            } else {
//                debugPrint("Success___ Got device manager instance")
//                // Handle the device manager logic if necessary
//            }
//        }
//        
//        let options = CallAgentOptions()
//        
//        // Creating the call agent
//        self.callClient!.createCallAgent(userCredential: userCredential, options: options) { [weak self] (callAgent, error) in
//            if let error = error {
//                debugPrint("Error____ Failed to create CallAgent \(error.localizedDescription)")
//                self?.result?(FlutterError(code: "CALL_AGENT_ERROR", message: "Failed to create CallAgent", details: error.localizedDescription))
//            } else {
//                guard let self = self else {
//                    self?.result?(FlutterError(code: "Error", message: "Self is null", details: ""))
//                    return
//                }
//                // Call agent created successfully
//                callService.setCallAgent(callAgent: callAgent!, callHandler: self)
//                self.initialized = true
//                debugPrint("Success___ Call Agent Initialized Successfully")
//                self.result?("Call Agent Initialized Successfully")
//            }
//        }
//    }
}
