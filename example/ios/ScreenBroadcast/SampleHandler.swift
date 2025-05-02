//
//  SampleHandler.swift
//  ScreenBroadcast
//
//  Created by Yriy Malyts on 02.05.2025.
//

import ReplayKit

class SampleHandler: RPBroadcastSampleHandler {
    
    let appGroupIdentifier = "group.acsPluginExample"
    let socket = BroadcastSocket(appGroupIdentifier: "group.acsPluginExample") // Custom class

    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        socket.connect()
    }

    override func broadcastFinished() {
        socket.disconnect()
    }

    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        guard sampleBufferType == .video else { return }
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        socket.send(pixelBuffer: pixelBuffer)
    }
}

