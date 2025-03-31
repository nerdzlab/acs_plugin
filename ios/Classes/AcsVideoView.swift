//
//  AcsVideoView.swift
//  Pods
//
//  Created by Yriy Malyts on 28.03.2025.
//

import Flutter
import UIKit

class AcsVideoView: NSObject, FlutterPlatformView {
    private var containerView: UIView
    
    init(frame: CGRect, viewId: Int64, args: Any?, messenger: FlutterBinaryMessenger) {
        self.containerView = UIView()
        
        if let existingView = AcsPlugin.shared.previewView {
            self.containerView.addSubview(existingView)
        }
    }
    
    func view() -> UIView {
        return containerView
    }
}
