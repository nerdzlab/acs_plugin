//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine
import SwiftUI

struct ParticipantVideoViewInfoModel {
    let videoStreamType: VideoStreamInfoModel.MediaStreamType?
    let videoStreamId: String?
}

class ParticipantGridCellViewModel: ObservableObject, Identifiable, Equatable {
    private let localizationProvider: LocalizationProviderProtocol
    private let accessibilityProvider: AccessibilityProviderProtocol
    
    let id = UUID()
    let isWhiteBoard: Bool
    
    @Published var videoViewModel: ParticipantVideoViewInfoModel?
    @Published var accessibilityLabel: String = ""
    @Published var displayName: String?
    @Published var avatarDisplayName: String?
    @Published var isSpeaking: Bool
    @Published var isMuted: Bool
    @Published var isHold: Bool
    @Published var participantIdentifier: String
    @Published var isPinned: Bool
    @Published var isVideoEnableForLocalUser: Bool
    @Published var isHandRaised: Bool
    @Published var selectedReaction: ReactionPayload?
    
    @State var avatarColor: Color
    
    private var isScreenSharing = false
    private var participantName: String
    private var renderDisplayName: String?
    private var isCameraEnabled: Bool
    private var participantStatus: ParticipantStatus?
    private var callType: CompositeCallType
    
    let onUserClicked: () -> Void
    let onResetReaction: () -> Void
    
    // A single timer for reaction removal
    private var reactionTimer: Timer?
    
    init(localizationProvider: LocalizationProviderProtocol,
         accessibilityProvider: AccessibilityProviderProtocol,
         participantModel: ParticipantInfoModel,
         isCameraEnabled: Bool,
         onUserClicked: @escaping () -> Void,
         onResetReaction: @escaping () -> Void,
         callType: CompositeCallType,
         isWhiteBoard: Bool
    ) {
        self.localizationProvider = localizationProvider
        self.accessibilityProvider = accessibilityProvider
        self.participantStatus = participantModel.status
        self.callType = callType
        let isDisplayConnecting = ParticipantGridCellViewModel.isOutgoingCallDialingInProgress(
            callType: callType,
            participantStatus: participantModel.status)
        if  isDisplayConnecting {
            self.participantName = localizationProvider.getLocalizedString(LocalizationKey.callingCallMessage)
            self.displayName = self.participantName
        } else {
            self.participantName = participantModel.displayName
            self.displayName = participantModel.displayName
        }
        self.isWhiteBoard = isWhiteBoard
        self.avatarDisplayName = participantModel.displayName
        self.isSpeaking = participantModel.isSpeaking
        self.isHold = participantModel.status == .hold
        self.participantIdentifier = participantModel.userIdentifier
        self.isMuted = participantModel.isMuted && participantModel.status == .connected
        self.isCameraEnabled = isCameraEnabled
        self.isVideoEnableForLocalUser = participantModel.isVideoOnForMe
        self.isPinned = participantModel.isPinned
        self.onUserClicked = onUserClicked
        self.onResetReaction = onResetReaction
        self.avatarColor = participantModel.avatarColor
        self.isHandRaised = participantModel.isHandRaised
        self.videoViewModel = getDisplayingVideoStreamModel(participantModel)
        self.accessibilityLabel = getAccessibilityLabel(participantModel: participantModel)
        self.selectedReaction = participantModel.selectedReaction
    }
    
    func update(participantModel: ParticipantInfoModel) {
        self.participantIdentifier = participantModel.userIdentifier
        
        let videoViewModel = getDisplayingVideoStreamModel(participantModel)
        if self.videoViewModel?.videoStreamId != videoViewModel.videoStreamId ||
            self.videoViewModel?.videoStreamType != videoViewModel.videoStreamType {
            let newIsScreenSharing = videoViewModel.videoStreamType == .screenSharing
            if newIsScreenSharing {
                accessibilityProvider.postQueuedAnnouncement(
                    localizationProvider.getLocalizedString(.screenshareStartAccessibilityLabel))
            } else if self.isScreenSharing && !newIsScreenSharing {
                accessibilityProvider.postQueuedAnnouncement(
                    localizationProvider.getLocalizedString(.screenshareEndAccessibilityLabel))
            }
            self.isScreenSharing = newIsScreenSharing
            self.videoViewModel = ParticipantVideoViewInfoModel(videoStreamType: videoViewModel.videoStreamType,
                                                                videoStreamId: videoViewModel.videoStreamId)
        }
        
        if self.participantName != participantModel.displayName ||
            self.isMuted != participantModel.isMuted ||
            self.isSpeaking != participantModel.isSpeaking ||
            self.isCameraEnabled != participantModel.cameraVideoStreamModel?.videoStreamIdentifier.isEmpty ||
            self.isHold != (participantModel.status == .hold) {
            self.accessibilityLabel = getAccessibilityLabel(participantModel: participantModel)
        }
        
        if self.participantStatus != participantModel.status {
            self.participantStatus = participantModel.status
            updateParticipantNameIfNeeded(with: renderDisplayName)
            self.isMuted = participantModel.isMuted && participantModel.status == .connected
        }
        if self.participantName != participantModel.displayName {
            self.participantName = participantModel.displayName
            updateParticipantNameIfNeeded(with: renderDisplayName)
        }
        
        if self.isSpeaking != participantModel.isSpeaking {
            self.isSpeaking = participantModel.isSpeaking
        }
        
        if self.isMuted != participantModel.isMuted {
            self.isMuted = participantModel.isMuted && participantModel.status == .connected
        }
        
        let isOnHold = participantModel.status == .hold
        
        if self.isHold != isOnHold {
            self.isHold = isOnHold
            postParticipantStatusAccessibilityAnnouncements(isHold: self.isHold, participantModel: participantModel)
        }
        
        if self.isVideoEnableForLocalUser != participantModel.isVideoOnForMe {
            self.isVideoEnableForLocalUser = participantModel.isVideoOnForMe
        }
        
        if self.isPinned != participantModel.isPinned {
            self.isPinned = participantModel.isPinned
        }
        
        if self.avatarColor != participantModel.avatarColor {
            self.avatarColor = participantModel.avatarColor
        }
        
        if self.isHandRaised != participantModel.isHandRaised {
            self.isHandRaised = participantModel.isHandRaised
        }
        
        if self.selectedReaction != participantModel.selectedReaction {
            self.selectedReaction = participantModel.selectedReaction
            updateReactionTimer(reactionPayload: selectedReaction)
        }
    }
    
    func updateReactionTimer(reactionPayload: ReactionPayload?) {
        guard let reactionPayload = reactionPayload else {
            return
        }
        
        guard let receivedOn = reactionPayload.receivedOn else {
            return
        }
        
        // Calculate the remaining time until the reaction should end
        let currentTime = Date()
        
        // Calculate the duration between receivedOn and the current time
        let timeRemaining = receivedOn.addingTimeInterval(3.0).timeIntervalSince(currentTime)
        
        // If the timeRemaining is positive, start the timer; otherwise, clear the reaction immediately
        // If a reaction exists, invalidate the previous timer
        reactionTimer?.invalidate()
        
        if timeRemaining > 0 {
            // Start a new timer with dynamic duration
            reactionTimer = Timer.scheduledTimer(withTimeInterval: timeRemaining, repeats: false) { [weak self] _ in
                self?.onResetReaction()
            }
        } else {
            onResetReaction()
        }
    }
    
    func updateParticipantNameIfNeeded(with renderDisplayName: String?) {
        let isDisplayConnecting = ParticipantGridCellViewModel.isOutgoingCallDialingInProgress(
            callType: callType,
            participantStatus: participantStatus)
        if isDisplayConnecting {
            self.participantName = localizationProvider.getLocalizedString(LocalizationKey.callingCallMessage)
            self.displayName = self.participantName
            self.renderDisplayName = renderDisplayName
            self.avatarDisplayName = renderDisplayName
            return
        }
        self.renderDisplayName = renderDisplayName
        guard renderDisplayName != displayName else {
            return
        }
        
        let name: String
        if let renderDisplayName = renderDisplayName {
            let isRendererNameEmpty = renderDisplayName.trimmingCharacters(in: .whitespaces).isEmpty
            name = isRendererNameEmpty ? participantName : renderDisplayName
        } else {
            name = participantName
        }
        self.displayName = name
        self.avatarDisplayName = displayName
    }
    
    func getOnHoldString() -> String {
        localizationProvider.getLocalizedString(.onHold)
    }
    
    private func getAccessibilityLabel(participantModel: ParticipantInfoModel) -> String {
        let status = participantModel.status == .hold ? getOnHoldString() :
        localizationProvider.getLocalizedString(participantModel.isSpeaking ? .speaking :
                                                    participantModel.isMuted ? .muted : .unmuted)
        
        let videoStatus = (videoViewModel?.videoStreamId?.isEmpty ?? true) ?
        localizationProvider.getLocalizedString(.videoOff) :
        localizationProvider.getLocalizedString(.videoOn)
        return localizationProvider.getLocalizedString(.participantInformationAccessibilityLable,
                                                       participantModel.displayName, status, videoStatus)
    }
    
    private func getDisplayingVideoStreamModel(_ participantModel: ParticipantInfoModel)
    -> ParticipantVideoViewInfoModel {
        let screenShareVideoStreamIdentifier = participantModel.screenShareVideoStreamModel?.videoStreamIdentifier
        let cameraVideoStreamIdentifier = isCameraEnabled ?
        participantModel.cameraVideoStreamModel?.videoStreamIdentifier :
        nil
        
        let screenShareVideoStreamType = participantModel.screenShareVideoStreamModel?.mediaStreamType
        let cameraVideoStreamType = participantModel.cameraVideoStreamModel?.mediaStreamType
        return screenShareVideoStreamIdentifier != nil ?
        ParticipantVideoViewInfoModel(videoStreamType: screenShareVideoStreamType,
                                      videoStreamId: screenShareVideoStreamIdentifier) :
        ParticipantVideoViewInfoModel(videoStreamType: cameraVideoStreamType,
                                      videoStreamId: cameraVideoStreamIdentifier)
    }
    
    private static func isOutgoingCallDialingInProgress(callType: CompositeCallType,
                                                        participantStatus: ParticipantStatus?) -> Bool {
        return callType == .oneToNOutgoing &&
        (participantStatus == nil || participantStatus == .connecting || participantStatus == .ringing)
    }
    
    private func postParticipantStatusAccessibilityAnnouncements(isHold: Bool, participantModel: ParticipantInfoModel) {
        let holdResumeAccessibilityAnnouncement = isHold ?
        localizationProvider.getLocalizedString(.onHoldAccessibilityLabel, participantModel.displayName) :
        localizationProvider.getLocalizedString(.participantResumeAccessibilityLabel, participantModel.displayName)
        accessibilityProvider.postQueuedAnnouncement(holdResumeAccessibilityAnnouncement)
    }
    
    static func ==(lhs: ParticipantGridCellViewModel, rhs: ParticipantGridCellViewModel) -> Bool {
        return lhs.participantIdentifier == rhs.participantIdentifier // or use participantIdentifier if it's more suitable
    }
}
