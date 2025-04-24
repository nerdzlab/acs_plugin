//
//  VideoEffectsPreview 2.swift
//  Pods
//
//  Created by Yriy Malyts on 23.04.2025.
//


import Combine
import Foundation

public class VideoEffectsPreviewViewModel: ObservableObject {
    
    @Published var localVideoStreamId: String?
    @Published var cameraOperationalStatus: LocalUserState.CameraOperationalStatus = .off
    @Published var displayName: String?
    
    func update(localUserState: LocalUserState, visibilityState: VisibilityState) {
        if localVideoStreamId != localUserState.localVideoStreamIdentifier {
            localVideoStreamId = localUserState.localVideoStreamIdentifier
        }
        
        if displayName != localUserState.initialDisplayName {
            displayName = localUserState.initialDisplayName
        }
        
        if cameraOperationalStatus != localUserState.cameraState.operation {
            cameraOperationalStatus = localUserState.cameraState.operation
        }
    }
}
