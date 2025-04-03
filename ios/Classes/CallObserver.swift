//
//  CallHandler.swift
//  Pods
//
//  Created by Yriy Malyts on 27.03.2025.
//

import Foundation
import AzureCommunicationCalling
import AVFoundation
import Flutter

public class CallObserver : NSObject, CallDelegate {
    private var firstTimeCallConnected: Bool = true
    private weak var callService: CallService?
    
    init(callService: CallService) {
        self.callService = callService
        super.init()
    }
    
    public func call(_ call: Call, didChangeState args: PropertyChangedEventArgs) {
        let internalError = call.callEndReason.toCompositeInternalError(callService?.wasCallConnected() ?? false)?.toCallCompositeErrorCode()
        
        if (call.state == CallState.disconnected) {
            callService?.leaveRoomCall(result: { _ in
                AcsPlugin.shared.sendParticipantList()
                AcsPlugin.shared.sendError(FlutterError(code: "CALL_ERROR", message: "Call disconnected \(internalError ?? "")", details: nil))
            })
        }
        else if (call.state == CallState.connected) {
            if(self.firstTimeCallConnected) {
                self.handleInitialCallState(call: call);
            }
            self.firstTimeCallConnected = false;
        }
        
        callService?.callState = call.state
    }
    
    public func handleInitialCallState(call: Call) {
        var participants = [Participant]()
        
        // Add existing participants to the list
        participants.append(contentsOf: callService?.participants ?? [])
        
        // Clear the existing participants list before updating
        callService?.participants.removeAll()
        
        // Add new participants
        for remoteParticipant in call.remoteParticipants {
            let mri = Utilities.toMri(remoteParticipant.identifier)
            let found = participants.contains { $0.getMri() == mri }
            
            // If the participant is not already in the list, add it
            if !found {
                let participant = Participant(call, remoteParticipant)
                participants.append(participant)
            }
        }
        
        // Update the call service with the new list of participants
        callService?.participants = participants
        
        // Send the updated participant list to the plugin
        AcsPlugin.shared.sendParticipantList()
    }
    
    public func call(_ call: Call, didUpdateRemoteParticipant args: ParticipantsUpdatedEventArgs) {
        var participants = callService?.participants ?? []
        
        // Remove deleted participants from the collection
        args.removedParticipants.forEach { member in
            let mri = Utilities.toMri(member.identifier)
            participants.removeAll { $0.getMri() == mri }
        }
        
        // Add new participants to the collection
        for remoteParticipant in args.addedParticipants {
            let mri = Utilities.toMri(remoteParticipant.identifier)
            let found = participants.contains { $0.getMri() == mri }
            
            if !found {
                let participant = Participant(call, remoteParticipant)
                participants.append(participant)
            }
        }
        
        // Update the service's participant list
        callService?.participants = participants
        
        AcsPlugin.shared.sendParticipantList()
    }
}
