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
        
        // Extract parameters from args
        var viewType = ""
        if let params = args as? [String: Any] {
            viewType = params["view_type"] as? String ?? ""
        }
        
        // Get the appropriate view based on viewType
        switch viewType {
        case "self_preview":
            if let existingView = AcsPlugin.shared.previewView {
                self.containerView.addSubview(existingView)
            }
            
        case "participant_preview":
            if let participantId = (args as? [String: Any])?["view_id"] as? String,
               let remoteView = AcsPlugin.shared.getParticipantView(for: participantId) {
                self.containerView.addSubview(remoteView)
            }
            
        default:
            // Default view or error handling
            break
        }
    }
    
    func view() -> UIView {
        return containerView
    }
}
