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
        self.containerView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 50, height: 100)))
        self.containerView.backgroundColor = UIColor.green
        super.init()
        
        if let existingView = AcsPlugin.shared.previewView {
            self.containerView.addSubview(existingView)
            existingView.frame = CGRect(origin: .zero, size: CGSize(width: 100, height: 100))
        }
    }
    
    func view() -> UIView {
        return containerView
    }
}
