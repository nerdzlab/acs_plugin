//
//  Constants.swift
//  Runner
//
//  Created by Yriy Malyts on 05.05.2025.
//

import ReplayKit
import OSLog

let broadcastLogger = OSLog(subsystem: "logs_acs_plugin", category: "Broadcast")

private enum Constants {
    static let appGroupIdentifier = "group.acsPluginExample"
    static let socketName = "socet.rtc_SSFD"
}

class SampleHandler: RPBroadcastSampleHandler {
    
    private static var imageContext = CIContext(options: nil)
    
    private var server: Server?
    private var isClientConnected = false
    
    override init() {
        super.init()
        server = Server(appGroup: Constants.appGroupIdentifier, socketName: Constants.socketName)
        startListeningForStopNotification()
    }
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        server?.startBroadcasting()
        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
    }
    
    override func broadcastPaused() {
        os_log(.debug, log: broadcastLogger, "Broadcast paused")
    }
    
    override func broadcastResumed() {
        os_log(.debug, log: broadcastLogger, "Broadcast resumed")
    }
    
    override func broadcastFinished() {
        server?.stopBroadcasting()
        DarwinNotificationCenter.shared.postNotification(.broadcastStopped)
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard sampleBufferType == .video else { return }
        
        if let data = sampleBufferToRawPacket(sampleBuffer) {
            server?.sendRawPixelBufferData(data)
        }
    }
    
    private func sampleBufferToRawPacket(_ sampleBuffer: CMSampleBuffer) -> Data? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        
        CVPixelBufferLockBaseAddress(pixelBuffer, .readOnly)
        
        let width = UInt32(CVPixelBufferGetWidth(pixelBuffer))
        let height = UInt32(CVPixelBufferGetHeight(pixelBuffer))
        let bytesPerRow = UInt32(CVPixelBufferGetBytesPerRow(pixelBuffer))
        let pixelFormat = UInt32(CVPixelBufferGetPixelFormatType(pixelBuffer))
        let baseAddress = CVPixelBufferGetBaseAddress(pixelBuffer)!
        
        let bufferSize = bytesPerRow * height
        let rawBytes = Data(bytes: baseAddress, count: Int(bufferSize))
        
        CVPixelBufferUnlockBaseAddress(pixelBuffer, .readOnly)
        
        // Header: [width (4)] + [height (4)] + [bytesPerRow (4)] + [pixelFormat (4)]
        var packet = Data()
        packet.append(contentsOf: withUnsafeBytes(of: width.bigEndian, Array.init))
        packet.append(contentsOf: withUnsafeBytes(of: height.bigEndian, Array.init))
        packet.append(contentsOf: withUnsafeBytes(of: bytesPerRow.bigEndian, Array.init))
        packet.append(contentsOf: withUnsafeBytes(of: pixelFormat.bigEndian, Array.init))
        packet.append(rawBytes)
        
        return packet
    }
    
    private func startListeningForStopNotification() {
        DarwinNotificationCenter.shared.subscribe(.broadcastStopped, observer: self) { [weak self] in
            guard let self = self else { return }
            
            let error = NSError(
                domain: "",
                code: 1001,
                userInfo: [NSLocalizedDescriptionKey: "You have stopped screen sharing"]
            )
            self.finishBroadcastWithError(error)
        }
    }
}
