//
//  ParticipantMenuViewModel.swift
//  Pods
//
//  Created by Yriy Malyts on 14.04.2025.
//


internal class ParticipantOptionsViewModel: ObservableObject {
    private let localizationProvider: LocalizationProviderProtocol
    private let onPinUser: (ParticipantInfoModel) -> Void
    private let onUnpinUser: (ParticipantInfoModel) -> Void
    private let onShowVideo: (ParticipantInfoModel) -> Void
    private let onHideVideo: (ParticipantInfoModel) -> Void
    private var participantInfoModel: ParticipantInfoModel?
    
    var isDisplayed: Bool
    @Published var items: [DrawerListItemViewModel] = []
    
    init(
        localUserState: LocalUserState,
        localizationProvider: LocalizationProviderProtocol,
        onPinUser: @escaping (ParticipantInfoModel) -> Void,
        onUnpinUser: @escaping (ParticipantInfoModel) -> Void,
        onShowVieo: @escaping (ParticipantInfoModel) -> Void,
        onHideVideo: @escaping (ParticipantInfoModel) -> Void,
        isPinEnable: Bool,
        isDisplayed: Bool) {
            
            self.localizationProvider = localizationProvider
            self.isDisplayed = false
            self.onPinUser = onPinUser
            self.onUnpinUser = onUnpinUser
            self.onHideVideo = onHideVideo
            self.onShowVideo = onShowVieo
            
            let pinDrawer = DrawerListItemViewModel(title: (participantInfoModel?.isPinned ?? false) ? localizationProvider.getLocalizedString(.participantOptionsUnpin) : localizationProvider.getLocalizedString(.participantOptionsPin),
                                                    icon: (participantInfoModel?.isPinned ?? false) ? .pinIcon : .unpinIcon,
                                                    action: pinAction,
                                                    isEnabled: isPinEnable)
            
            let videoDrawer = DrawerListItemViewModel(title: (participantInfoModel?.isVideoOnForMe ?? false) ? localizationProvider.getLocalizedString(.participantOptionsHideVideo) : localizationProvider.getLocalizedString(.participantOptionsShowVideo),
                                                      icon: (participantInfoModel?.isVideoOnForMe ?? false) ? .videoOn : .videoOff,
                                                      action: videoAction,
                                                      isEnabled: true)
            
            
            items = [pinDrawer, videoDrawer]
        }
    
    private func pinAction() {
        guard let pim = participantInfoModel else {
            return
        }
        
        (participantInfoModel?.isPinned ?? false) ?  self.onUnpinUser(pim) : self.onPinUser(pim)
    }
    
    private func videoAction() {
        guard let pim = participantInfoModel else {
            return
        }
        
        (participantInfoModel?.isVideoOnForMe ?? false) ?  self.onHideVideo(pim) : self.onShowVideo(pim)
    }
    
    func update(localUserState: LocalUserState, isDisplayed: Bool, participantInfoModel: ParticipantInfoModel?, isPinEnable: Bool) {
        self.isDisplayed = isDisplayed
        
        guard let participantInfoModel = participantInfoModel else {
            return
        }
        
        self.participantInfoModel = participantInfoModel
        
        
        let pinDrawer = DrawerListItemViewModel(title: participantInfoModel.isPinned ? localizationProvider.getLocalizedString(.participantOptionsUnpin) : localizationProvider.getLocalizedString(.participantOptionsPin),
                                                icon: participantInfoModel.isPinned ? .unpinIcon : .pinIcon, action: pinAction,
                                                isEnabled: isPinEnable)
        
        let videoDrawer = DrawerListItemViewModel(title: participantInfoModel.isVideoOnForMe ? localizationProvider.getLocalizedString(.participantOptionsHideVideo) : localizationProvider.getLocalizedString(.participantOptionsShowVideo),
                                                  icon: participantInfoModel.isVideoOnForMe ? .videoOff : .videoOn, action: videoAction,
                                                  isEnabled: true)
        
        
        items = [pinDrawer, videoDrawer]
        
    }
    
    func getParticipantName() -> String {
        return participantInfoModel?.displayName ?? ""
    }
}
