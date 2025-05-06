//
//  BroadcastServer.swift
//  Pods
//
//  Created by Yriy Malyts on 05.05.2025.
//

import Foundation
import UIKit
import OSLog

//let serverLogger = OSLog(subsystem: "live.videosdk.flutter.example", category: "Broadcast")


class BroadcastServer {
    private let socketPath: String
    private var serverSocket: Int32 = -1
    private var clientSocket: Int32 = -1

    var onFrameReceived: ((Data) -> Void)?

    init?(appGroup: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            print("Failed to get container URL")
            return nil
        }

        socketPath = containerURL.appendingPathComponent("rtc_SSFD").path
    }

    func startListening() {
//        removeSocketFileIfExists()
//
//        serverSocket = socket(AF_UNIX, SOCK_STREAM, 0)
//        guard serverSocket >= 0 else {
////            serverLogger.error("Failed to create server socket")
//            return
//        }
//
//        var addr = sockaddr_un()
//        addr.sun_family = sa_family_t(AF_UNIX)
//        _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
//            socketPath.withCString { cstr in
//                strncpy(ptr, cstr, MemoryLayout.size(ofValue: addr.sun_path))
//            }
//        }
//
//        let bindResult = withUnsafePointer(to: &addr) {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                bind(serverSocket, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
//            }
//        }
//
//        guard bindResult == 0 else {
////            serverLogger.error("Failed to bind server socket")
//            close(serverSocket)
//            return
//        }
//
//        listen(serverSocket, 1)
//
//        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
//            self?.acceptLoop()
//        }
    }

    private func acceptLoop() {
        while true {
            clientSocket = accept(serverSocket, nil, nil)
            if clientSocket < 0 {
//                serverLogger.error("Client socket accept failed")
                continue
            }

            receiveLoop()
        }
    }

    private func receiveLoop() {
        var buffer = [UInt8](repeating: 0, count: 64 * 1024)

        while true {
            let bytesRead = read(clientSocket, &buffer, buffer.count)
            if bytesRead <= 0 {
                close(clientSocket)
                break
            }

            let data = Data(buffer.prefix(bytesRead))
            onFrameReceived?(data)
        }
    }

    private func removeSocketFileIfExists() {
        if FileManager.default.fileExists(atPath: socketPath) {
            try? FileManager.default.removeItem(atPath: socketPath)
        }
    }

    func stop() {
        if clientSocket >= 0 {
            close(clientSocket)
        }
        if serverSocket >= 0 {
            close(serverSocket)
        }
    }
}
