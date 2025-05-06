class ScreenShareReceiver: NSObject {
    // Delegate to notify when frames are received
    
    private var socketServer: SocketServer?
    private let socketFilePath: String
    
    // Buffer to store incoming data
    private var dataBuffer = NSMutableData()
    private var currentFrameSize: Int = 0
    private var metadataSize: Int = 0
    private var isReadingMetadata = true
    
    // Queue for processing frames
    private let processingQueue = DispatchQueue(label: "com.yourapp.screenShareProcessing")
    
    init(appGroupIdentifier: String) {
        // Use the same app group identifier as in the broadcast extension
        let sharedContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupIdentifier)
        socketFilePath = sharedContainer?.appendingPathComponent("socet.rtc_SSFD").path ?? ""
        
        super.init()
        
        // Setup notification observers for broadcast events
//        setupNotificationObservers()
    }
    
    func start() {
        // Create and start the socket server
        setupSocketServer()
    }
    
    func stop() {
        socketServer?.stop()
        socketServer = nil
    }
    
    private func setupSocketServer() {
        // Create a new socket server
        socketServer = SocketServer(filePath: socketFilePath)
        
        // Handle when a client connects
        socketServer?.clientDidConnect = { [weak self] in
            print("Broadcast extension connected")
        }
        
        // Handle received data
        socketServer?.dataReceived = { [weak self] data in
            self?.processingQueue.async {
//                self?.processReceivedData(data)
            }
        }
        
        // Start the server
        if !(socketServer?.start() ?? false) {
            print("Failed to start socket server")
        }
    }
    
    // Rest of the implementation remains the same as before
    // ...
}
