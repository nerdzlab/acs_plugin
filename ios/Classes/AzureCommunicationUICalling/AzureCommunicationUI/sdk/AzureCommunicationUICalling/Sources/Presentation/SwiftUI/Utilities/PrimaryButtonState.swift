//
//  ButtonState 2.swift
//  Pods
//
//  Created by Yriy Malyts on 08.04.2025.
//


//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

protocol PrimaryButtonState: Equatable {
    var iconName: CompositeIcon { get }
}



enum CameraButtonState: PrimaryButtonState {
    case videoOn
    case videoOff
    
    var iconName: CompositeIcon {
        switch self {
        case .videoOn:
            return .videoOn
        case .videoOff:
            return .videoOff
        }
    }
}

enum MicButtonState: PrimaryButtonState {
    case micOn
    case micOff
    
    var iconName: CompositeIcon {
        switch self {
        case .micOn:
            return .micOn
        case .micOff:
            return .micOff
        }
    }
}

enum BackgroundEffectButtonState: PrimaryButtonState {
    case on
    case off
    
    var iconName: CompositeIcon {
        return .backgroundEffectOn
    }
}

enum SwitchCameraButtonState: PrimaryButtonState {
    case `default`
    
    var iconName: CompositeIcon {
        return .cameraSwitch
    }
}

enum AudioButtonState: PrimaryButtonState {
    case speaker
    case receiver
    case bluetooth
    case headphones
    case incomingAudioMuted
    
    var iconName: CompositeIcon {
        switch self {
        case .bluetooth:
            return .speakerBluetooth
        case .headphones:
            return .speakerRegular
        case .receiver:
            return .speakerRegular
        case .speaker:
            return .speakerFilled
        case .incomingAudioMuted:
            return .volumeOff
        }
    }
    
    var localizationKey: LocalizationKey {
        switch self {
        case .bluetooth:
            return AudioDeviceType.bluetooth.name
        case .headphones:
            return AudioDeviceType.headphones.name
        case .receiver:
            return AudioDeviceType.receiver.name
        case .speaker:
            return AudioDeviceType.speaker.name
        case .incomingAudioMuted:
            return AudioDeviceType.speaker.name
        }
    }
    
    static func getButtonState(from audioDeviceStatus: LocalUserState.AudioDeviceSelectionStatus) -> AudioButtonState {
        switch audioDeviceStatus {
        case .speakerSelected,
                .speakerRequested:
            return .speaker
        case .receiverSelected,
                .receiverRequested:
            return .receiver
        case .bluetoothSelected,
                .bluetoothRequested:
            return .bluetooth
        case .headphonesSelected,
                .headphonesRequested:
            return .headphones
        }
    }
}
