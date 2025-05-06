//
//  SocketServer.swift
//  Pods
//
//  Created by Yriy Malyts on 06.05.2025.
//


import Foundation
import Darwin

class SocketServer: NSObject {
    private let filePath: String
    private var socketHandle: Int32 = -1
    private var clientSocket: Int32 = -1
    
    private var listenQueue: DispatchQueue?
    private var shouldKeepRunning = false
    
    private var inputStream: InputStream?
    private var outputStream: OutputStream?
    
    // Callback for when a client connects
    var clientDidConnect: (() -> Void)?
    // Callback for when data is received
    var dataReceived: ((Data) -> Void)?
    
    init?(filePath path: String) {
        filePath = path
        super.init()
    }
    
    func start() -> Bool {
        // Remove any existing socket file
        removeSocketFileIfExists()
        
        // Create socket
        socketHandle = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard socketHandle != -1 else {
            print("Failed to create socket: \(String(cString: strerror(errno)))")
            return false
        }
        
        // Set up socket address
        var addr = sockaddr_un()
        addr.sun_family = sa_family_t(AF_UNIX)
        
        guard filePath.count < MemoryLayout.size(ofValue: addr.sun_path) else {
            print("Socket path too long")
            return false
        }
        
        _ = withUnsafeMutablePointer(to: &addr.sun_path.0) { ptr in
            filePath.withCString {
                strncpy(ptr, $0, filePath.count)
            }
        }
        
        // Bind socket to address
        let bindResult = withUnsafePointer(to: &addr) { ptr in
            ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                Darwin.bind(socketHandle, $0, socklen_t(MemoryLayout<sockaddr_un>.size))
            }
        }
        
        guard bindResult != -1 else {
            print("Failed to bind socket: \(String(cString: strerror(errno)))")
            return false
        }
        
        // Set socket permissions so broadcast extension can connect
        chmod(filePath, S_IRWXU | S_IRWXG | S_IRWXO)
        
        // Listen for connections
        let listenResult = Darwin.listen(socketHandle, 5)
        guard listenResult != -1 else {
            print("Failed to listen on socket: \(String(cString: strerror(errno)))")
            return false
        }
        
        // Start accepting connections on a background queue
        shouldKeepRunning = true
        listenQueue = DispatchQueue(label: "com.socketserver.listen", qos: .userInitiated)
        listenQueue?.async { [weak self] in
            self?.acceptConnections()
        }
        
        return true
    }
    
    private func acceptConnections() {
        while shouldKeepRunning {
            var addr = sockaddr_un()
            var len = socklen_t(MemoryLayout<sockaddr_un>.size)
            
            let clientSocketHandle = withUnsafeMutablePointer(to: &addr) { ptr in
                ptr.withMemoryRebound(to: sockaddr.self, capacity: 1) { addrPtr in
                    return Darwin.accept(socketHandle, addrPtr, &len)
                }
            }
            
            if clientSocketHandle != -1 {
                // We got a connection
                print("Client connected")
                
                // Close any existing client socket
                if clientSocket != -1 {
                    Darwin.close(clientSocket)
                }
                
                clientSocket = clientSocketHandle
                
                // Create streams for the client socket
                setupStreams(for: clientSocketHandle)
                
                // Notify about connection
                DispatchQueue.main.async { [weak self] in
                    self?.clientDidConnect?()
                }
            } else if errno != EAGAIN && errno != EWOULDBLOCK {
                print("Accept failed: \(String(cString: strerror(errno)))")
                break
            }
        }
    }
    
    private func setupStreams(for clientSocket: Int32) {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocket(kCFAllocatorDefault, clientSocket, &readStream, &writeStream)
        
        inputStream = readStream?.takeRetainedValue()
        inputStream?.delegate = self
        inputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
        
        outputStream = writeStream?.takeRetainedValue()
        outputStream?.delegate = self
        outputStream?.setProperty(kCFBooleanTrue, forKey: Stream.PropertyKey(kCFStreamPropertyShouldCloseNativeSocket as String))
        
        // Schedule streams on a background runloop
        let networkQueue = DispatchQueue.global(qos: .userInitiated)
        networkQueue.async { [weak self] in
            self?.inputStream?.schedule(in: .current, forMode: .common)
            self?.outputStream?.schedule(in: .current, forMode: .common)
            
            self?.inputStream?.open()
            self?.outputStream?.open()
            
            RunLoop.current.run()
        }
    }
    
    func stop() {
        shouldKeepRunning = false
        
        if socketHandle != -1 {
            Darwin.close(socketHandle)
            socketHandle = -1
        }
        
        if clientSocket != -1 {
            Darwin.close(clientSocket)
            clientSocket = -1
        }
        
        inputStream?.close()
        outputStream?.close()
        
        inputStream = nil
        outputStream = nil
        
        // Clean up the socket file
        removeSocketFileIfExists()
    }
    
    private func removeSocketFileIfExists() {
        if FileManager.default.fileExists(atPath: filePath) {
            try? FileManager.default.removeItem(atPath: filePath)
        }
    }
    
    deinit {
        stop()
    }
}

extension SocketServer: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("Stream opened")
            
        case .hasBytesAvailable:
            guard let inputStream = aStream as? InputStream else { return }
            
            let bufferSize = 65536 // 64KB buffer
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
            defer { buffer.deallocate() }
            
            while inputStream.hasBytesAvailable {
                let bytesRead = inputStream.read(buffer, maxLength: bufferSize)
                if bytesRead > 0 {
                    let data = Data(bytes: buffer, count: bytesRead)
                    DispatchQueue.main.async { [weak self] in
                        self?.dataReceived?(data)
                    }
                } else if bytesRead == 0 {
                    // End of stream, client disconnected
                    print("Client disconnected")
                    break
                } else {
                    print("Error reading from stream: \(aStream.streamError?.localizedDescription ?? "Unknown error")")
                    break
                }
            }
            
        case .errorOccurred:
            print("Stream error: \(aStream.streamError?.localizedDescription ?? "Unknown error")")
            
        default:
            break
        }
    }
}
