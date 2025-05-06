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

        let dummyData = Data("video frame".utf8)
        server?.sendData(dummyData)
    }
}
