//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import AVFoundation

internal class AudioDevicesListViewModel: ObservableObject {
    @Published var audioDevicesList: [DrawerSelectableItemViewModel] = []
    @Published var isDisplayed = false

    private var audioDeviceStatus: LocalUserState.AudioDeviceSelectionStatus
    private var previousConnectedDevice: AudioDeviceType?
    private let dispatch: ActionDispatch
    private let localizationProvider: LocalizationProviderProtocol
    private let compositeViewModelFactory: CompositeViewModelFactoryProtocol
    private var localUserState: LocalUserState
    private let isPreviewSettings: Bool
    
    private(set) var noiseSuppressionViewModel: NoiseSuppressionItemViewModel?
    
    var listTitle: String {
        return localizationProvider.getLocalizedString(.chooseAudioHeader)
    }

    init(compositeViewModelFactory: CompositeViewModelFactoryProtocol,
         dispatchAction: @escaping ActionDispatch,
         localUserState: LocalUserState,
         localizationProvider: LocalizationProviderProtocol,
         isPreviewSettings: Bool
    ) {
        self.localUserState = localUserState
        self.dispatch = dispatchAction
        self.audioDeviceStatus = localUserState.audioState.device
        self.localizationProvider = localizationProvider
        self.compositeViewModelFactory = compositeViewModelFactory
        self.isPreviewSettings = isPreviewSettings
        self.noiseSuppressionViewModel = getNoiseSuppressionViewModel()
    }

    func update(audioDeviceStatus: LocalUserState.AudioDeviceSelectionStatus,
                navigationState: NavigationState,
                localUserState: LocalUserState,
                visibilityState: VisibilityState) {
        
        if audioDeviceStatus != self.audioDeviceStatus || audioDevicesList.isEmpty || localUserState.incomingAudioState.operation != self.localUserState.incomingAudioState.operation,
           LocalUserState.AudioDeviceSelectionStatus.isSelected(for: audioDeviceStatus) {
            self.localUserState = localUserState
            
            self.audioDeviceStatus = audioDeviceStatus
            self.audioDevicesList = getAvailableAudioDevices(audioDeviceStatus: audioDeviceStatus)
        }
        
        self.localUserState = localUserState
        
        self.noiseSuppressionViewModel = getNoiseSuppressionViewModel()
        
        isDisplayed = visibilityState.currentStatus == .visible && navigationState.audioSelectionVisible
    }

    private func getNoiseSuppressionViewModel() -> NoiseSuppressionItemViewModel {
        return NoiseSuppressionItemViewModel(title: localizationProvider.getLocalizedString(.noiseSuppressionTitle), icon: CompositeIcon.noiseSuppresion, isOn: localUserState.noiseSuppressionState.operation == .on) { [weak self] isOn in
            if isOn {
                (self?.isPreviewSettings == true) ? self?.dispatch(.localUserAction(.noiseSuppressionPreviewOn)) : self?.dispatch(.localUserAction(.noiseSuppressionCallOn))
            } else {
                (self?.isPreviewSettings == true) ? self?.dispatch(.localUserAction(.noiseSuppressionPreviewOff)) : self?.dispatch(.localUserAction(.noiseSuppressionCallOff))
            }
        }
    }

    private func getAvailableAudioDevices(audioDeviceStatus: LocalUserState.AudioDeviceSelectionStatus)
    -> [DrawerSelectableItemViewModel] {
        let systemDefaultAudio: AudioDeviceType
        switch audioDeviceStatus {
        case .bluetoothSelected:
            systemDefaultAudio = .bluetooth
        case .headphonesSelected:
            systemDefaultAudio = .headphones
        case .receiverSelected:
            systemDefaultAudio = .receiver
        default:
            if let availableInputs = AVAudioSession.sharedInstance().availableInputs {
                let availableInputPorts = Set(availableInputs.map({ $0.portType }))
                let isBluetoothConnected = !availableInputPorts.isDisjoint(with: bluetoothAudioPorts)
                let isHeadphonesConnected = !availableInputPorts.isDisjoint(with: headphonesAudioPorts)

                if isBluetoothConnected,
                   isHeadphonesConnected,
                   let previousConnectedDevice = previousConnectedDevice {
                    systemDefaultAudio = previousConnectedDevice
                } else if isBluetoothConnected {
                    systemDefaultAudio = .bluetooth
                } else if isHeadphonesConnected {
                    systemDefaultAudio = .headphones
                } else {
                    systemDefaultAudio = .receiver
                }
            } else {
                systemDefaultAudio = .receiver
            }
        }
        previousConnectedDevice = systemDefaultAudio

        var audioDeviceOptions = [DrawerSelectableItemViewModel]()
        audioDeviceOptions.append(getAudioDeviceOption(for: systemDefaultAudio))
        audioDeviceOptions.append(getAudioDeviceOption(for: .speaker))
        audioDeviceOptions.append(getMuteAudioOption())
        return audioDeviceOptions
    }

    private func getAudioDeviceOption(for audioDeviceType: AudioDeviceType) -> DrawerSelectableItemViewModel {
        let isSelected = isAudioDeviceSelected(audioDeviceType, selectedDevice: audioDeviceStatus)
        let action = LocalUserAction.audioDeviceChangeRequested(device: audioDeviceType)
        let audioDeviceOption = DrawerSelectableItemViewModel(
            icon: getAudioDeviceIcon(audioDeviceType),
            title: getAudioDeviceTitle(audioDeviceType),
            accessibilityIdentifier: "",
            accessibilityLabel: isSelected ?
            localizationProvider.getLocalizedString(.selected, getAudioDeviceTitle(audioDeviceType)) :
                getAudioDeviceTitle(audioDeviceType),
            isSelected: isSelected,
            action: { [weak self] in self?.dispatch(.localUserAction(action)) })
        return audioDeviceOption
    }
    
    private func getMuteAudioOption() -> DrawerSelectableItemViewModel {
        let isSelected = localUserState.incomingAudioState.operation == .muted
        
        let action = LocalUserAction.muteIncomingAudioRequested
        
        let audioDeviceOption = DrawerSelectableItemViewModel(
            icon: CompositeIcon.volumeOff,
            title: localizationProvider.getLocalizedString(.muteIncomingAudio),
            accessibilityIdentifier: "",
            accessibilityLabel: "",
            isSelected: isSelected,
            action: { [weak self] in self?.dispatch(.localUserAction(action)) })
        return audioDeviceOption
    }

    private func getAudioDeviceTitle(_ audioDeviceType: AudioDeviceType) -> String {
        switch audioDeviceType {
        case .bluetooth:
            return audioDeviceType.getBluetoothName() ?? localizationProvider
                .getLocalizedString(audioDeviceType.name)
        default:
            return localizationProvider.getLocalizedString(audioDeviceType.name)
        }
    }

    private func getAudioDeviceIcon(_ audioDeviceType: AudioDeviceType) -> CompositeIcon {
        switch audioDeviceType {
        case .bluetooth:
            return .speakerBluetooth
        case .speaker:
            return .speakerFilled
        default:
            return .speakerRegular
        }
    }

    private func isAudioDeviceSelected(_ audioDeviceType: AudioDeviceType,
                                       selectedDevice: LocalUserState.AudioDeviceSelectionStatus) -> Bool {
        if localUserState.incomingAudioState.operation == .muted {
            return false
        }
        
        switch selectedDevice {
        case .bluetoothSelected where audioDeviceType == .bluetooth,
             .headphonesSelected where audioDeviceType == .headphones,
             .receiverSelected where audioDeviceType == .receiver,
             .speakerSelected where audioDeviceType == .speaker:
            return true
        default:
            return false
        }
    }
}
