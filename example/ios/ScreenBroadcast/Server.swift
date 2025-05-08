//
//  Server.swift
//  Runner
//
//  Created by Yriy Malyts on 06.05.2025.
//
import Foundation

class Server {

    private var socket: Int32?
    private var clientSocket: Int32?
    private let socketPath: String

    /// Initializes the Server with an app group identifier and a socket name.
    /// - Parameters:
    ///   - appGroup: The application group identifier.
    ///   - socketName: The name of the socket.
    init(appGroup: String, socketName: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Invalid app group identifier.")
        }
        socketPath = containerURL.appendingPathComponent(socketName).path
    }

    /// Starts the server and begins listening for connections.
    func startBroadcasting() {
        createSocket()
        bindSocket()
        listenOnSocket()
        waitForConnection()
    }

    /// Creates a socket for communication.
    private func createSocket() {
        socket = Darwin.socket(AF_UNIX, SOCK_STREAM, 0)
        guard socket != nil, socket != -1 else {
            logError("Error creating socket")
            return
        }
        log("Socket created successfully")
    }

    /// Binds the created socket to a specific address.
    private func bindSocket() {
        guard let socket = socket else { return }

        var address = sockaddr_un()
        address.sun_family = sa_family_t(AF_UNIX)
        socketPath.withCString { ptr in
            withUnsafeMutablePointer(to: &address.sun_path.0) { dest in
                _ = strcpy(dest, ptr)
            }
        }

        unlink(socketPath) // Remove any existing socket file

        if Darwin.bind(socket, withUnsafePointer(to: &address, { $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 } }), socklen_t(MemoryLayout<sockaddr_un>.size)) == -1 {
            logError("Error binding socket - \(String(cString: strerror(errno)))")
            return
        }
        log("Binding to socket path: \(socketPath)")
    }

    /// Listens for connections on the bound socket.
    private func listenOnSocket() {
        guard let socket = socket else { return }

        if Darwin.listen(socket, 1) == -1 {
            logError("Error listening on socket - \(String(cString: strerror(errno)))")
            return
        }
        log("Listening for connections...")
    }

    /// Waits for a connection and accepts it when available.
    private func waitForConnection() {
        DispatchQueue.global().async { [weak self] in
            self?.acceptConnection()
        }
    }

    /// Accepts a connection request from a client.
    private func acceptConnection() {
        guard let socket = socket else { return }

        var clientAddress = sockaddr_un()
        var clientAddressLen = socklen_t(MemoryLayout<sockaddr_un>.size)
        clientSocket = Darwin.accept(socket, withUnsafeMutablePointer(to: &clientAddress, { $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { $0 } }), &clientAddressLen)

        if clientSocket == -1 {
            logError("Error accepting connection - \(String(cString: strerror(errno)))")
            return
        }
        log("Connection accepted!")
    }
    
    func sendRawPixelBufferData(_ data: Data) {
        guard let socket = clientSocket else { return }

        var length = UInt32(data.count).bigEndian
        var packet = Data()
        packet.append(Data(bytes: &length, count: 4))
        packet.append(data)

        _ = packet.withUnsafeBytes {
            send(socket, $0.baseAddress!, packet.count, 0)
        }
    }

    /// Stops the server and closes any open connections.
    func stopBroadcasting() {
        if let clientSocket = clientSocket {
            log("Closing client socket...")
            close(clientSocket)
        }
        if let socket = socket {
            log("Closing server socket...")
            close(socket)
        }
        unlink(socketPath)
        log("Broadcasting stopped.")
    }

    /// Logs a success message.
    /// - Parameter message: The message to log.
    private func log(_ message: String) {
        print("ServerUnixSocket: \(message)")
    }

    /// Logs an error message.
    /// - Parameter message: The message to log.
    private func logError(_ message: String) {
        print("ServerUnixSocket: [ERROR] \(message)")
    }
}
