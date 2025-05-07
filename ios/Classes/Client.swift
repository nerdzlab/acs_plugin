//
//  Client.swift
//  Pods
//
//  Created by Yriy Malyts on 06.05.2025.
//
import Foundation
import UIKit
import AVFoundation
import CoreVideo
import CoreMedia

class Client {
    
    var onBufferReceived: ((CMSampleBuffer?) -> Void)?
    
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
    
    func readData() {
        DispatchQueue.global().async {
            while true {
                guard let socketDescriptor = self.socketDescriptor else {
                    self.logError("Socket descriptor is nil")
                    return
                }

                // Step 1: Read 4-byte length header
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

                let dataLength = lengthBuffer.withUnsafeBytes {
                    $0.load(as: UInt32.self).bigEndian
                }

                let maxSize: UInt32 = 10_000_000 // 10 MB limit
                if dataLength == 0 || dataLength > maxSize {
                    self.logError("Data length out of bounds: \(dataLength)")
                    return
                }

                self.log("Expecting \(dataLength) bytes of data")

                // Step 2: Read payload in chunks
                var dataBuffer = Data(capacity: Int(dataLength))
                var received: UInt32 = 0
                while received < dataLength {
                    let chunkSize = min(4096, Int(dataLength - received)) // Limit the chunk size to 4 KB
                    var chunk = [UInt8](repeating: 0, count: chunkSize)
                    let bytesRead = read(socketDescriptor, &chunk, chunk.count)
                    if bytesRead <= 0 {
                        self.logError("Failed to read payload or connection closed")
                        return
                    }
                    dataBuffer.append(contentsOf: chunk.prefix(bytesRead))
                    received += UInt32(bytesRead)
                }

                self.log("✅ Received full payload: \(dataBuffer.count) bytes")

                // Assuming raw RGB data, we will create a CVPixelBuffer directly from the socket data
                let pixelBuffer = self.createPixelBufferFromRawData(dataBuffer)

                if let pixelBuffer = pixelBuffer {
                    // Step 3: Pass pixelBuffer to your processing pipeline directly
                    self.processPixelBuffer(pixelBuffer)
                } else {
                    self.logError("❌ Failed to create CVPixelBuffer from raw data")
                }
            }
        }
    }

    func createPixelBufferFromRawData(_ data: Data) -> CVPixelBuffer? {
        let width = 1920 // Example width, replace with actual
        let height = 1080 // Example height, replace with actual
        let bytesPerRow = width * 4 // For RGB format with 4 bytes per pixel

        var pixelBuffer: CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32BGRA, nil, &pixelBuffer)

        guard let buffer = pixelBuffer, status == kCVReturnSuccess else {
            return nil
        }

        // Lock pixel buffer
        CVPixelBufferLockBaseAddress(buffer, .readOnly)

        // Access raw data from the Data object
        data.withUnsafeBytes { rawBuffer in
            // Copy raw data into pixel buffer
            let pixelBufferBaseAddress = CVPixelBufferGetBaseAddress(buffer)
            memcpy(pixelBufferBaseAddress, rawBuffer.baseAddress, data.count)
        }

        // Unlock pixel buffer after modification
        CVPixelBufferUnlockBaseAddress(buffer, .readOnly)

        return buffer
    }

    func processPixelBuffer(_ pixelBuffer: CVPixelBuffer) {
        // Use the pixelBuffer for video processing or rendering
        self.log("✅ Successfully created pixel buffer from raw data")

        // Convert the pixel buffer to CMSampleBuffer if needed
        let sampleBuffer = self.createSampleBuffer(from: pixelBuffer)

        // If you need to use captureOutput directly
        if let sampleBuffer = sampleBuffer {
            onBufferReceived?(sampleBuffer)
        }
    }

    func createSampleBuffer(from pixelBuffer: CVPixelBuffer) -> CMSampleBuffer? {
        var sampleBuffer: CMSampleBuffer?

        // Step 1: Create format description (specifying pixel format and video dimensions)
        var formatDescription: CMFormatDescription?
        let status = CMVideoFormatDescriptionCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                                  imageBuffer: pixelBuffer,
                                                                  formatDescriptionOut: &formatDescription)
        
        guard status == noErr, let formatDesc = formatDescription else {
            print("Failed to create format description.")
            return nil
        }

        // Step 2: Define timing info (if applicable)
        var timingInfo = CMSampleTimingInfo(duration: CMTime(value: 1, timescale: 30), // Example duration (e.g., 1 frame at 30fps)
                                            presentationTimeStamp: CMTime(value: 0, timescale: 30), // Start from 0 time
                                            decodeTimeStamp: CMTime.invalid) // No decode time

        // Step 3: Create the CMSampleBuffer
        let statusCreate = CMSampleBufferCreateForImageBuffer(allocator: kCFAllocatorDefault,
                                                              imageBuffer: pixelBuffer,
                                                              dataReady: true,
                                                              makeDataReadyCallback: nil,
                                                              refcon: nil,
                                                              formatDescription: formatDesc,
                                                              sampleTiming: &timingInfo,
                                                              sampleBufferOut: &sampleBuffer)
        
        if statusCreate != noErr {
            print("Failed to create sample buffer.")
            return nil
        }
        
        return sampleBuffer
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
