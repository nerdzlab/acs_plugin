//
//  AcsVideoViewFactory.swift
//  Pods
//
//  Created by Yriy Malyts on 28.03.2025.
//


import Flutter
import UIKit

class AcsVideoViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger

    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }

    func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return AcsVideoView(frame: frame, viewId: viewId, args: args, messenger: messenger)
    }
}