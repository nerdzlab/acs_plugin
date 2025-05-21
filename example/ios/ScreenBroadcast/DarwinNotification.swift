//
//  DarwinNotification.swift
//  Runner
//
//  Created by Yriy Malyts on 05.05.2025.
//

import Foundation

enum DarwinNotification: String {
    case broadcastStarted = "videosdk.flutter.startScreenShare"
    case broadcastStopped = "videosdk.flutter.stopScreenShare"
}

class DarwinNotificationCenter {

    static let shared = DarwinNotificationCenter()

    private let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()

    // Store handlers by observer + notification
    private var handlers: [String: () -> Void] = [:]
    private let lock = NSLock()

    private init() {}

    func postNotification(_ name: DarwinNotification) {
        CFNotificationCenterPostNotification(
            notificationCenter,
            CFNotificationName(name.rawValue as CFString),
            nil,
            nil,
            true
        )
    }

    func subscribe(_ name: DarwinNotification, observer: AnyObject, handler: @escaping () -> Void) {
        let observerKey = key(for: observer, name: name)
        lock.lock()
        handlers[observerKey] = handler
        lock.unlock()

        let rawObserver = UnsafeRawPointer(Unmanaged.passUnretained(observer).toOpaque())

        CFNotificationCenterAddObserver(
            notificationCenter,
            rawObserver,
            DarwinNotificationCenter.callback,
            name.rawValue as CFString,
            nil,
            .deliverImmediately
        )
    }

    func unsubscribe(_ observer: AnyObject) {
        let rawObserver = UnsafeRawPointer(Unmanaged.passUnretained(observer).toOpaque())
        CFNotificationCenterRemoveEveryObserver(notificationCenter, rawObserver)

        lock.lock()
        handlers = handlers.filter { !$0.key.hasPrefix(keyPrefix(for: observer)) }
        lock.unlock()
    }

    private func key(for observer: AnyObject, name: DarwinNotification) -> String {
        return "\(Unmanaged.passUnretained(observer).toOpaque())_\(name.rawValue)"
    }

    private func keyPrefix(for observer: AnyObject) -> String {
        return "\(Unmanaged.passUnretained(observer).toOpaque())_"
    }

    /// C-compatible callback function
    private static let callback: CFNotificationCallback = { (_, observer, name, _, _) in
        guard
            let observer = observer,
            let name = name?.rawValue as String?
        else { return }

        let key = "\(observer)_\(name)"
        DarwinNotificationCenter.shared.lock.lock()
        let handler = DarwinNotificationCenter.shared.handlers[key]
        DarwinNotificationCenter.shared.lock.unlock()
        handler?()
    }
}



