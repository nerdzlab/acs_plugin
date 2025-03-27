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
    public var callClient: CallClient?
    public var initialized: Bool = false
    private var callService: CallService?
    
    private var lock = NSLock()
    
    // This method will be used to send errors back to Flutter
    private var result: FlutterResult?
    
    private static var instance: CallHandler?
    static func getOrCreateInstance() -> CallHandler {
        if let c = instance {
            return c
        }
        instance = CallHandler()
        return instance!
    }
    
    private override init() {}
    
    public func callAgent(_ callAgent: CallAgent, didUpdateCalls args: CallsUpdatedEventArgs) {
        if let removedCall = args.removedCalls.first {
            callService?.callRemoved(removedCall)
            result?(FlutterError(code: "CREDENTIAL_ERROR", message: "Need to remove call", details: nil))
        }
    }
    
    public func initializeCall(token: String, callService: CallService, result: @escaping FlutterResult) {
        if self.initialized {
            result("Already initialized")
            return
        }
        
        self.callService = callService
        
        self.result = result
        
        lock.lock()
        
        var userCredential: CommunicationTokenCredential
        do {
            userCredential = try CommunicationTokenCredential(token: token)
        } catch {
            result(FlutterError(code: "CREDENTIAL_ERROR", message: "Failed to create CommunicationTokenCredential", details: nil))
            lock.unlock()
            return
        }
        
        self.callClient = CallClient()
        
        self.callClient!.getDeviceManager { (deviceManager, error) in
            if let error = error {
                self.result?(FlutterError(code: "DEVICE_MANAGER_ERROR", message: "Failed to get DeviceManager", details: error.localizedDescription))
                return
            } else {
                print("Got device manager instance")
                // Handle the device manager logic if necessary
            }
        }
        
        let options = CallAgentOptions()
        
        // Creating the call agent
        self.callClient!.createCallAgent(userCredential: userCredential, options: options) { (callAgent, error) in
            if let error = error {
                self.result?(FlutterError(code: "CALL_AGENT_ERROR", message: "Failed to create CallAgent", details: error.localizedDescription))
            } else {
                // Call agent created successfully
                self.initialized = true
                self.result?("Call Agent Initialized Successfully")
            }
        }
        
        self.lock.unlock()
    }
}
