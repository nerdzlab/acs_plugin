//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import Combine
import SwiftUICore

class ParticipantGridViewModel: ObservableObject {
    private let compositeViewModelFactory: CompositeViewModelFactoryProtocol
    private let localizationProvider: LocalizationProviderProtocol
    private let accessibilityProvider: AccessibilityProviderProtocol
    private let isIpadInterface: Bool
    private let callType: CompositeCallType
    private var maximumParticipantsDisplayed: Int {
        return  self.visibilityStatus == .pipModeEntered ? 1 : isIpadInterface ? 9 : 6
    }
    
    private var lastUpdateTimeStamp = Date()
    private var lastDominantSpeakersUpdatedTimestamp = Date()
    private var visibilityStatus: VisibilityStatus = .visible
    private var appStatus: AppStatus = .foreground
    private(set) var participantsCellViewModelArr: [ParticipantGridCellViewModel] = []
    private var remoteParticipantsState: RemoteParticipantsState?
    
    var previousSpeaker: ParticipantGridCellViewModel?

    @Published var gridsCount: Int = 0
    @Published var displayedParticipantInfoModelArr: [ParticipantInfoModel] = []
    @Published var meetingLayoutState: LocalUserState.MeetingLayoutState = LocalUserState.MeetingLayoutState.init(operation: .grid)

    let rendererViewManager: RendererViewManager

    init(compositeViewModelFactory: CompositeViewModelFactoryProtocol,
         localizationProvider: LocalizationProviderProtocol,
         accessibilityProvider: AccessibilityProviderProtocol,
         isIpadInterface: Bool,
         remoteParticipantsState: RemoteParticipantsState,
         callType: CompositeCallType,
         rendererViewManager: RendererViewManager) {
        self.compositeViewModelFactory = compositeViewModelFactory
        self.localizationProvider = localizationProvider
        self.accessibilityProvider = accessibilityProvider
        self.isIpadInterface = isIpadInterface
        self.callType = callType
        self.rendererViewManager = rendererViewManager
        self.remoteParticipantsState = remoteParticipantsState
    }

    func update(callingState: CallingState,
                remoteParticipantsState: RemoteParticipantsState,
                visibilityState: VisibilityState,
                localUserState: LocalUserState,
                lifeCycleState: LifeCycleState) {

        guard lastUpdateTimeStamp != remoteParticipantsState.lastUpdateTimeStamp
                || lastDominantSpeakersUpdatedTimestamp != remoteParticipantsState.dominantSpeakersModifiedTimestamp
                || visibilityStatus != visibilityState.currentStatus
                || appStatus != lifeCycleState.currentStatus || self.remoteParticipantsState?.pinnedParticipantId != remoteParticipantsState.pinnedParticipantId || meetingLayoutState.operation != localUserState.meetingLayoutState.operation
        else {
            return
        }
                
        lastUpdateTimeStamp = remoteParticipantsState.lastUpdateTimeStamp
        lastDominantSpeakersUpdatedTimestamp = remoteParticipantsState.dominantSpeakersModifiedTimestamp
        visibilityStatus = visibilityState.currentStatus
        appStatus = lifeCycleState.currentStatus

        let remoteParticipants = remoteParticipantsState.participantInfoList
            .filter { participanInfoModel in
                participanInfoModel.status != .inLobby && participanInfoModel.status != .disconnected
            }
        let dominantSpeakers = remoteParticipantsState.dominantSpeakers
        let newDisplayedInfoModelArr = getDisplayedInfoViewModels(remoteParticipants, dominantSpeakers, visibilityState)
        let removedModels = getRemovedInfoModels(for: newDisplayedInfoModelArr)
        let addedModels = getAddedInfoModels(for: newDisplayedInfoModelArr)
        let orderedInfoModelArr = sortDisplayedInfoModels(newDisplayedInfoModelArr,
                                                          removedModels: removedModels,
                                                          addedModels: addedModels)
        //MTODO
//      vbvfv
        
        updateCellViewModel(for:orderedInfoModelArr , lifeCycleState: lifeCycleState)

        displayedParticipantInfoModelArr = orderedInfoModelArr
        if callingState.status == .connected
            || callingState.status == .remoteHold
            || (callType == .oneToNOutgoing
        && ( callingState.status == .connecting || callingState.status == .ringing)) {
            // announce participants list changes only if the user is already connected to the call
            postParticipantsListUpdateAccessibilityAnnouncements(removedModels: removedModels,
                                                                 addedModels: addedModels)
        }

        updateVideoViewManager(displayedRemoteInfoModelArr: displayedParticipantInfoModelArr)

        if gridsCount != displayedParticipantInfoModelArr.count {
            gridsCount = displayedParticipantInfoModelArr.count
        }
        
        // Try to find the current active speaker (the one who is speaking).
        let activeSpeaker = participantsCellViewModelArr.first(where: { $0.isSpeaking })

        // Check if the current speaker is the same as the previous speaker by comparing their identifiers.
        // If the previous speaker is not found, it means the active speaker has changed, and we may need to reset it.
        let isPreviousSpeaker = remoteParticipantsState.participantInfoList.first(where: { $0.userIdentifier == previousSpeaker?.participantIdentifier })

        // If the previous speaker is not found in the list, reset the previous speaker.
        if isPreviousSpeaker == nil {
            previousSpeaker = nil
        }

        // If there is a new active speaker, update the previous speaker to the current active speaker.
        if let activeSpeaker = activeSpeaker {
            previousSpeaker = activeSpeaker
        }
        
        // If the meeting layout state has changed (i.e., the operation differs from the current state),
        // reset the previous speaker and update the meeting layout state accordingly.
        if meetingLayoutState.operation != localUserState.meetingLayoutState.operation {
            previousSpeaker = nil  // Reset the previous speaker since the layout has changed.
            self.meetingLayoutState = localUserState.meetingLayoutState  // Update the layout state to the new state.
        }
    }

    private func updateVideoViewManager(displayedRemoteInfoModelArr: [ParticipantInfoModel]) {
        
           let videoCacheIds: [RemoteParticipantVideoViewId] = displayedRemoteInfoModelArr.compactMap {
               let screenShareVideoStreamIdentifier = $0.screenShareVideoStreamModel?.videoStreamIdentifier
               let cameraVideoStreamIdentifier = $0.cameraVideoStreamModel?.videoStreamIdentifier
               guard let videoStreamIdentifier = screenShareVideoStreamIdentifier ?? cameraVideoStreamIdentifier else {
                   return nil
               }
               return RemoteParticipantVideoViewId(userIdentifier: $0.userIdentifier,
                                                   videoStreamIdentifier: videoStreamIdentifier)
           }

           rendererViewManager.updateDisplayedRemoteVideoStream(videoCacheIds)
       }

    private func getDisplayedInfoViewModels(_ infoModels: [ParticipantInfoModel],
                                            _ dominantSpeakers: [String],
                                            _ visibilityState: VisibilityState) -> [ParticipantInfoModel] {
        if let presentingParticipant = infoModels.first(where: { $0.screenShareVideoStreamModel != nil }) {
            return [presentingParticipant]
        }

        if infoModels.count <= maximumParticipantsDisplayed {
            return infoModels
        }
        var dominantSpeakersOrder = [String: Int]()
        for idx in 0..<min(maximumParticipantsDisplayed, dominantSpeakers.count) {
            dominantSpeakersOrder[dominantSpeakers[idx]] = idx
        }
        let sortedInfoList = infoModels.sorted(by: {
            if let order1 = dominantSpeakersOrder[$0.userIdentifier],
                let order2 = dominantSpeakersOrder[$1.userIdentifier] {
                return order1 < order2
            }
            if dominantSpeakersOrder[$0.userIdentifier] != nil {
                return true
            }
            if dominantSpeakersOrder[$1.userIdentifier] != nil {
                return false
            }
            if ($0.cameraVideoStreamModel != nil && $1.cameraVideoStreamModel != nil)
                || ($0.cameraVideoStreamModel == nil && $1.cameraVideoStreamModel == nil) {
                return true
            }
            if $0.cameraVideoStreamModel != nil {
                return true
            } else {
                return false
            }
        })
        let newDisplayRemoteParticipant = sortedInfoList.prefix(maximumParticipantsDisplayed)
        // Need to filter if the user is on the lobby or not
        return Array(newDisplayRemoteParticipant)
    }

    private func getRemovedInfoModels(for newInfoModels: [ParticipantInfoModel]) -> [ParticipantInfoModel] {
        return displayedParticipantInfoModelArr.filter { old in
            !newInfoModels.contains(where: { new in
                new.userIdentifier == old.userIdentifier
            })
        }
    }

    private func getAddedInfoModels(for newInfoModels: [ParticipantInfoModel]) -> [ParticipantInfoModel] {
        return newInfoModels.filter { new in
            !displayedParticipantInfoModelArr.contains(where: { old in
                new.userIdentifier == old.userIdentifier
            })
        }
    }

    private func sortDisplayedInfoModels(_ newInfoModels: [ParticipantInfoModel],
                                         removedModels: [ParticipantInfoModel],
                                         addedModels: [ParticipantInfoModel]) -> [ParticipantInfoModel] {
        var localCacheInfoModelArr = displayedParticipantInfoModelArr
        guard removedModels.count == addedModels.count else {
            // when there is a gridType change
            // we just directly update the order based on the latest sorting
            return newInfoModels
        }

        var replacedIndex = [Int]()
        // Otherwise, we keep those existed participant in same position when there is any update
        for (index, item) in removedModels.enumerated() {
            if let removeIndex = localCacheInfoModelArr.firstIndex(where: {
                $0.userIdentifier == item.userIdentifier
            }) {
                localCacheInfoModelArr[removeIndex] = addedModels[index]
                replacedIndex.append(removeIndex)
            }
        }

        // To update existed participantInfoModel
        for (index, item) in localCacheInfoModelArr.enumerated() {
            if !replacedIndex.contains(index),
               let newItem = newInfoModels.first(where: {$0.userIdentifier == item.userIdentifier}) {
                localCacheInfoModelArr[index] = newItem
            }
        }

        return localCacheInfoModelArr
    }

    private func updateCellViewModel(for displayedRemoteParticipants: [ParticipantInfoModel],
                                     lifeCycleState: LifeCycleState) {
        
        if participantsCellViewModelArr.count == displayedRemoteParticipants.count {
            updateOrderedCellViewModels(for: displayedRemoteParticipants, lifeCycleState: lifeCycleState)
        } else {
            updateAndReorderCellViewModels(for: displayedRemoteParticipants, lifeCycleState: lifeCycleState)
        }
    }
    
    func makeMockParticipants(count: Int, pinIndex: Int? = nil) -> [ParticipantInfoModel] {
        var participants: [ParticipantInfoModel] = []
        
        for index in 0..<count {
            let isSpeaking = false
            let isMuted = false
            let isPinned = false
            let isVideoOnForMe = false
            let userIdentifier = "user\(index + 1)"
            
            let participant = ParticipantInfoModel(
                displayName: "User \(index + 1)",
                isSpeaking: isSpeaking,
                isMuted: isMuted,
                isPinned: isPinned,
                isVideoOnForMe: isVideoOnForMe,
                avatarColor: Color(UIColor.avatarColors.randomElement()!),
                isRemoteUser: true,
                userIdentifier: userIdentifier,
                status: .connected,
                screenShareVideoStreamModel: nil,
                cameraVideoStreamModel: nil
            )
            
            participants.append(participant)
        }
        
        return participants
    }

    private func updateOrderedCellViewModels(for displayedRemoteParticipants: [ParticipantInfoModel],
                                             lifeCycleState: LifeCycleState) {
        //MTODO
//        guard participantsCellViewModelArr.count == displayedRemoteParticipants.count else {
//            return
//        }
        for (index, infoModel) in displayedRemoteParticipants.enumerated() {
            let cellViewModel = participantsCellViewModelArr[index]
            cellViewModel.update(participantModel: infoModel)
        }
    }

    private func updateAndReorderCellViewModels(for displayedRemoteParticipants: [ParticipantInfoModel],
                                                lifeCycleState: LifeCycleState) {
        var newCellViewModelArr = [ParticipantGridCellViewModel]()
        for infoModel in displayedRemoteParticipants {
            if let viewModel = participantsCellViewModelArr.first(where: {
                $0.participantIdentifier == infoModel.userIdentifier
            }) {
                viewModel.update(participantModel: infoModel)
                newCellViewModelArr.append(viewModel)
            } else {
                let cellViewModel = compositeViewModelFactory
                    .makeParticipantCellViewModel(participantModel: infoModel)
                newCellViewModelArr.append(cellViewModel)
            }
        }

        participantsCellViewModelArr = newCellViewModelArr
    }

    private func postParticipantsListUpdateAccessibilityAnnouncements(removedModels: [ParticipantInfoModel],
                                                                      addedModels: [ParticipantInfoModel]) {
        if !removedModels.isEmpty {
            if removedModels.count == 1 {
                accessibilityProvider.postQueuedAnnouncement(
                    localizationProvider.getLocalizedString(.onePersonLeft, removedModels.first!.displayName))
            } else {
                accessibilityProvider.postQueuedAnnouncement(
                    localizationProvider.getLocalizedString(.multiplePeopleLeft, removedModels.count))
            }
        }
        if !addedModels.isEmpty {
            if addedModels.count == 1 {
                accessibilityProvider.postQueuedAnnouncement(
                    localizationProvider.getLocalizedString(.onePersonJoined, addedModels.first!.displayName))
            } else {
                accessibilityProvider.postQueuedAnnouncement(
                    localizationProvider.getLocalizedString(.multiplePeopleJoined, addedModels.count))
            }
        }
    }
}
