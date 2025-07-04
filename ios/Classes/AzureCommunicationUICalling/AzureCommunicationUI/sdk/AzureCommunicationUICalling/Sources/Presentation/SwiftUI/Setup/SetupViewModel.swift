//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Combine
import Foundation
import SwiftUI

class SetupViewModel: ObservableObject {
    private let logger: Logger
    private let store: Store<AppState, Action>
    private let localizationProvider: LocalizationProviderProtocol
    private let callType: CompositeCallType
    private var callingStatus: CallingStatus = .none
    
    let isRightToLeft: Bool
    let previewAreaViewModel: PreviewAreaViewModel
    let initialDisplayName: String?
    var title: String
    var subTitle: String?
    var textFieldPLaceholder: String
    
    var networkManager: NetworkManager
    var audioSessionManager: AudioSessionManagerProtocol
    var errorInfoViewModel: ErrorInfoViewModel
    var dismissButtonViewModel: IconButtonViewModel!
    var joinCallButtonViewModel: AppPrimaryButtonViewModel!
    var setupControlBarViewModel: SetupControlBarViewModel!
    var joiningCallActivityViewModel: JoiningCallActivityViewModel!
    var cancellables = Set<AnyCancellable>()
    var audioDeviceListViewModel: AudioDevicesListViewModel!
    
    @Published var isJoinRequested = false
    var updatedDisplayName: String?
    
    init(compositeViewModelFactory: CompositeViewModelFactoryProtocol,
         logger: Logger,
         store: Store<AppState, Action>,
         networkManager: NetworkManager,
         audioSessionManager: AudioSessionManagerProtocol,
         localizationProvider: LocalizationProviderProtocol,
         setupScreenViewData: SetupScreenViewData? = nil,
         callType: CompositeCallType
    ) {
        let actionDispatch: ActionDispatch = store.dispatch
        self.store = store
        self.networkManager = networkManager
        self.networkManager.startMonitor()
        self.audioSessionManager = audioSessionManager
        self.localizationProvider = localizationProvider
        self.isRightToLeft = localizationProvider.isRightToLeft
        self.logger = logger
        self.callType = callType
        self.initialDisplayName = store.state.localUserState.initialDisplayName
        
        if let title = setupScreenViewData?.title, !title.isEmpty {
            // if title is not nil/empty, use given title and optional subtitle
            self.title = title
            self.subTitle = setupScreenViewData?.subtitle
        } else {
            // else if title is nil/empty, use default title
            self.title = self.localizationProvider.getLocalizedString(.setupTitle)
            self.subTitle = self.localizationProvider.getLocalizedString(.setupSubTitle)
        }
        
        self.textFieldPLaceholder = self.localizationProvider.getLocalizedString(.setupScreenTextfieldPlaceholder)
        
        previewAreaViewModel = compositeViewModelFactory.makePreviewAreaViewModel(dispatchAction: store.dispatch)
        var joiningButtonLocalization = LocalizationKey.joiningCall
        if self.callType == .oneToNOutgoing {
            joiningButtonLocalization = LocalizationKey.startingCall
        }
        joiningCallActivityViewModel = compositeViewModelFactory.makeJoiningCallActivityViewModel(
            title: self.localizationProvider.getLocalizedString(joiningButtonLocalization))
        errorInfoViewModel = compositeViewModelFactory.makeErrorInfoViewModel(title: "",
                                                                              subtitle: "")
        
        audioDeviceListViewModel = compositeViewModelFactory.makeAudioDevicesListViewModel(
            dispatchAction: actionDispatch,
            localUserState: store.state.localUserState,
            isPreviewSettings: true
        )
        
        let callButtonLocalization = LocalizationKey.startCall
        
        joinCallButtonViewModel = compositeViewModelFactory.makeAppPrimaryButtonViewModel(
            buttonStyle: .primaryFilled,
            buttonLabel: self.localizationProvider
                .getLocalizedString(callButtonLocalization).uppercased(),
            isDisabled: false) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.endEditing()
                store.dispatch(action: .localUserAction(.changeDisplayNameRequested(displayName: updatedDisplayName)))
                self.joinCallButtonTapped()
            }
        
        updateAccessibilityLabel()
        dismissButtonViewModel = compositeViewModelFactory.makeIconButtonViewModel(
            iconName: .callClose,
            buttonType: .backNavigation,
            isDisabled: false,
            renderAsOriginal: true, isVisible: true) { [weak self] in
                guard let self = self else {
                    return
                }
                self.endEditing()
                self.dismissButtonTapped()
            }
        dismissButtonViewModel.update(
            accessibilityLabel: self.localizationProvider.getLocalizedString(.dismissAccessibilityLabel))
        
        setupControlBarViewModel = compositeViewModelFactory
            .makeSetupControlBarViewModel(dispatchAction: store.dispatch,
                                          localUserState: store.state.localUserState,
                                          buttonViewDataState: store.state.buttonViewDataState)
        
        store.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.receive(state)
            }.store(in: &cancellables)
        
        $isJoinRequested.sink { [weak self] value in
            self?.setupControlBarViewModel.update(isJoinRequested: value)
        }.store(in: &cancellables)
    }
    
    func updateAccessibilityLabel() {
        if joinCallButtonViewModel.isDisabled {
            // Update the accessibility label for the disabled state
            var key = LocalizationKey.joinCallDiableStateAccessibilityLabel
            if callType == .oneToNOutgoing {
                key = LocalizationKey.startCallDiableStateAccessibilityLabel
            }
            joinCallButtonViewModel.update(accessibilityLabel:
                                            self.localizationProvider.getLocalizedString(key))
        } else {
            // Update the accessibility label for the normal state
            var key = LocalizationKey.startCall
            
            joinCallButtonViewModel.update(accessibilityLabel: self.localizationProvider.getLocalizedString(key))
        }
    }
    
    deinit {
        networkManager.stopMonitor()
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    func joinCallButtonTapped() {
        guard networkManager.isConnected else {
            handleOffline()
            return
        }
        guard audioSessionManager.isAudioUsedByOther() else {
            handleMicUnavailableEvent()
            return
        }
        isJoinRequested = true
        store.dispatch(action: .callingAction(.callStartRequested))
    }
    
    func dismissButtonTapped() {
        let isJoining = callingStatus != .none
        let action: Action = isJoining ? .callingAction(.callEndRequested) : .compositeExitAction
        store.dispatch(action: action)
    }
    
    func receive(_ state: AppState) {
        let newCallingStatus = state.callingState.status
        if callingStatus != newCallingStatus,
           newCallingStatus == .none {
            isJoinRequested = false
        }
        
        callingStatus = newCallingStatus
        let localUserState = state.localUserState
        let permissionState = state.permissionState
        let callingState = state.callingState
        
        previewAreaViewModel.update(localUserState: localUserState,
                                    permissionState: permissionState,
                                    visibilityState: state.visibilityState)
        
        setupControlBarViewModel.update(localUserState: localUserState,
                                        permissionState: permissionState,
                                        callingState: callingState,
                                        buttonViewDataState: state.buttonViewDataState)
        joinCallButtonViewModel.update(isDisabled: permissionState.audioPermission == .denied)
        updateAccessibilityLabel()
        errorInfoViewModel.update(errorState: state.errorState)
        audioDeviceListViewModel.update(
            audioDeviceStatus: state.localUserState.audioState.device,
            navigationState: state.navigationState,
            localUserState: state.localUserState,
            visibilityState: state.visibilityState
        )
        objectWillChange.send()
    }
    
    func shouldShowSetupControlBarView() -> Bool {
        let cameraStatus = store.state.localUserState.cameraState.operation
        return cameraStatus == .off || !isJoinRequested
    }
    
    func dismissDrawer() {
        store.dispatch(action: .hideDrawer)
    }
    
    private func handleOffline() {
        store.dispatch(
            action: .errorAction(
                .statusErrorAndCallReset(internalError: .callJoinConnectionFailed, error: nil)))
        // only show banner again when user taps on button explicitly
        // banner would not reappear when other events^1 send identical error state again
        // 1: camera on/off, audio on/off, switch to background/foreground, etc.
        errorInfoViewModel.show()
    }
    
    private func handleMicUnavailableEvent() {
        store.dispatch(action: .errorAction(.statusErrorAndCallReset(internalError: .micNotAvailable,
                                                                     error: nil)))
        // only show banner again when user taps on button explicitly
        // banner would not reappear when other events^1 send identical error state again
        // 1: camera on/off, audio on/off, switch to background/foreground, etc.
        errorInfoViewModel.show()
    }
}
