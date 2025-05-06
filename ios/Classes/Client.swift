//
//  Client.swift
//  Pods
//
//  Created by Yriy Malyts on 06.05.2025.
//
import Foundation

class Client {
    
    private var socketDescriptor: Int32?
    private let socketPath: String

    /// Initializes the Client with an app group identifier and a socket name.
    /// - Parameters:
    ///   - appGroup: The application group identifier.
    ///   - socketName: The name of the socket.
    init(appGroup: String, socketName: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Invalid app group identifier.")
        }
        socketPath = containerURL.appendingPathComponent(socketName).path
    }

    /// Attempts to connect to the Unix socket.
    func connect() {
        log("Attempting to connect to socket path: \(socketPath)")
        
        socketDescriptor = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard let socketDescriptor = socketDescriptor, socketDescriptor != -1 else {
            logError("Error creating socket")
            return
        }

        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        socketPath.withCString { ptr in
            withUnsafeMutablePointer(to: &address.sun_path.0) { dest in
                _ = strcpy(dest, ptr)
            }
        }

        log("File exists: \(FileManager.default.fileExists(atPath: socketPath))")

        if Darwin.connect(socketDescriptor, withUnsafePointer(to: &address, { $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 } }), socklen_t(MemoryLayout<sockaddr_un>.size)) == -1 {
            logError("Error connecting to socket - \(String(cString: strerror(errno)))")
            return
        }

        log("Successfully connected to socket")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.readData()
        })
    }

    /// Reads data from the connected socket.
    func readData() {
        DispatchQueue.global().async {
            while true {
                guard let socketDescriptor = self.socketDescriptor else {
                    self.logError("Socket descriptor is nil")
                    return
                }

                // Step 1: Read 4-byte header (data length)
                var lengthBuffer = [UInt8](repeating: 0, count: 4)
                var totalRead = 0
                while totalRead < 4 {
                    let bytesRead = lengthBuffer.withUnsafeMutableBytes {
                        read(socketDescriptor, $0.baseAddress!.advanced(by: totalRead), 4 - totalRead)
                    }
                    if bytesRead <= 0 {
                        self.logError("Failed to read length header or connection closed")
                        return
                    }
                    totalRead += bytesRead
                }

                // Convert to UInt32 (big endian)
                let dataLength = lengthBuffer.withUnsafeBytes {
                    $0.load(as: UInt32.self).bigEndian
                }
                self.log("Expecting \(dataLength) bytes of data")

                // Step 2: Read full payload
                var dataBuffer = Data(count: Int(dataLength))
                dataBuffer.withUnsafeMutableBytes { rawBuffer in
                    var offset = 0
                    while offset < dataLength {
                        let bytesRead = read(socketDescriptor, rawBuffer.baseAddress!.advanced(by: offset), Int(dataLength) - offset)
                        if bytesRead <= 0 {
                            self.logError("Failed to read full payload or connection closed")
                            return
                        }
                        offset += bytesRead
                    }
                }

                // Step 3: Use received data
                self.log("Received full data payload of size \(dataBuffer.count) bytes")
                if let image = UIImage(data: dataBuffer) {
                    DispatchQueue.main.async {
                        // You can update UI here or pass the image to another component
                        self.log("Image created successfully")
                    }
                } else {
                    self.logError("Failed to decode UIImage from received data")
                }
            }

            if let socketDescriptor = self.socketDescriptor {
                close(socketDescriptor)
            }
        }
    }



    /// Logs a message.
    /// - Parameter message: The message to log.
    private func log(_ message: String) {
        print("ClientUnixSocket: \(message)")
    }

    /// Logs an error message.
    /// - Parameter message: The error message to log.
    private func logError(_ message: String) {
        print("ClientUnixSocket: [ERROR] \(message)")
    }
}
