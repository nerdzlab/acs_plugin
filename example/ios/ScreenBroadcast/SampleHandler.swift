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
        
        guard let image = imageFromSampleBuffer(sampleBuffer),
              let imageData = image.jpegData(compressionQuality: 0.5) else {
            print("Failed to get image from sample buffer")
            return
        }
        
        server?.sendImageData(imageData)
    }
    
    func imageFromSampleBuffer(_ sampleBuffer: CMSampleBuffer) -> UIImage? {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return nil
        }
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
