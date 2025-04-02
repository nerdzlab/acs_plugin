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
        let state = CallObserver.callStateToString(state:call.state)
        callService?.callState = state
        
        if (call.state == CallState.disconnected) {
            //TODO need to add logic to return result that leave room
            callService?.leaveRoomCall(result: { _ in
                
            })
        }
        else if (call.state == CallState.connected) {
            if(self.firstTimeCallConnected) {
                self.handleInitialCallState(call: call);
            }
            self.firstTimeCallConnected = false;
        }
    }
    
    public func handleInitialCallState(call: Call) {
        // We want to build a matrix with max 2 columns
        
        callService?.callState = CallObserver.callStateToString(state: call.state)
        var participants = [Participant]()
        
        // Add older/existing participants
        callService?.participants.forEach { (existingParticipants: [Participant]) in
            participants.append(contentsOf: existingParticipants)
        }
        callService?.participants.removeAll()
        
        // Add new participants to the collection
        for remoteParticipant in call.remoteParticipants {
            let mri = Utilities.toMri(remoteParticipant.identifier)
            let found = participants.contains { (participant) -> Bool in
                participant.getMri() == mri
            }
            
            if !found {
                let participant = Participant(call, remoteParticipant)
                participants.append(participant)
            }
        }
        
        // Convert 1-D array into a 2-D array with 2 columns
        var indexOfParticipant = 0
        
        while indexOfParticipant < participants.count {
            var newParticipants = [Participant]()
            newParticipants.append(participants[indexOfParticipant])
            indexOfParticipant += 1
            if (indexOfParticipant < participants.count) {
                newParticipants.append(participants[indexOfParticipant])
                indexOfParticipant += 1
            }
            callService?.participants.append(newParticipants)
        }
    }
    
    public func call(_ call: Call, didUpdateRemoteParticipant args: ParticipantsUpdatedEventArgs) {
        var participants = [Participant]()
        // Add older/existing participants
        callService?.participants.forEach { (existingParticipants: [Participant]) in
            participants.append(contentsOf: existingParticipants)
        }
        callService?.participants.removeAll()
        
        // Remove deleted participants from the collection
        args.removedParticipants.forEach { member in
            let mri = Utilities.toMri(member.identifier)
            
            participants.removeAll { (participant) -> Bool in
                participant.getMri() == mri
            }
        }
        
        // Add new participants to the collection
        for remoteParticipant in args.addedParticipants {
            let mri = Utilities.toMri(remoteParticipant.identifier)
            let found = participants.contains { (view) -> Bool in
                view.getMri() == mri
            }
            
            if !found {
                let participant = Participant(call, remoteParticipant)
                participants.append(participant)
            }
        }
        
        // Convert 1-D array into a 2-D array with 2 columns
        var indexOfParticipant = 0
        
        while indexOfParticipant < participants.count {
            var array = [Participant]()
            array.append(participants[indexOfParticipant])
            indexOfParticipant += 1
            if (indexOfParticipant < participants.count) {
                array.append(participants[indexOfParticipant])
                indexOfParticipant += 1
            }
            callService?.participants.append(array)
        }
    }
    
    private static func callStateToString(state:CallState) -> String {
        switch state {
        case .connected: return "Connected"
        case .connecting: return "Connecting"
        case .disconnected: return "Disconnected"
        case .disconnecting: return "Disconnecting"
        case .none: return "None"
        default: return "Unknown"
        }
    }
}
