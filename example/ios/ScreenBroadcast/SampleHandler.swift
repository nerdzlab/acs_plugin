//
//  Constants.swift
//  Runner
//
//  Created by Yriy Malyts on 05.05.2025.
//

import ReplayKit
import OSLog

import ReplayKit
import OSLog

let broadcastLogger = OSLog(subsystem: "logs_acs_plugin", category: "Broadcast")

private enum Constants {
    static let appGroupIdentifier = "group.acsPluginExample"
}

class SampleHandler: RPBroadcastSampleHandler {
    
    private static var imageContext = CIContext(options: nil)
    
    private var server: Server?
    private var isClientConnected = false
    
    override init() {
        super.init()
        server = Server(appGroup: Constants.appGroupIdentifier, socketName: "socet.rtc_SSFD")
        startListeningForStopNotification()
    }
    
    override func broadcastStarted(withSetupInfo setupInfo: [String: NSObject]?) {
        server?.startBroadcasting()
        DarwinNotificationCenter.shared.postNotification(.broadcastStarted)
        
        let notificationName = CFNotificationName("videosdk.flutter.startScreenShare" as CFString)
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, nil, nil, true)
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
        
        let notificationName = CFNotificationName("videosdk.flutter.stopScreenShare" as CFString)
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, nil, nil, true)
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
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let observer = UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())
        let notificationName = "videosdk.flutter.stopScreenShare" as CFString

        CFNotificationCenterAddObserver(
            notificationCenter,
            observer,
            { (_, observer, _, _, _) in
                guard let observer = observer else { return }
                let handler = Unmanaged<SampleHandler>.fromOpaque(observer).takeUnretainedValue()

                let error = NSError(
                    domain: "com.yourcompany.broadcast",
                    code: 1001,
                    userInfo: [NSLocalizedDescriptionKey: "You have stopped screen sharing"]
                )
                handler.finishBroadcastWithError(error)
            },
            notificationName,
            nil,
            .deliverImmediately
        )
    }
}
