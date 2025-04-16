//
//  LayoutOptionsViewModel.swift
//  Pods
//
//  Created by Yriy Malyts on 15.04.2025.
//

internal class LayoutOptionsViewModel: ObservableObject {
    private let localizationProvider: LocalizationProviderProtocol
    private let onGridSelected: () -> Void
    private let onSpeakerSelected: () -> Void
    
    var isDisplayed: Bool
    @Published var items: [DrawerSelectableItemViewModel] = []
    
    init(
        localUserState: LocalUserState,
        localizationProvider: LocalizationProviderProtocol,
        onGridSelected: @escaping () -> Void,
        onSpeakerSelected: @escaping () -> Void,
        isDisplayed: Bool) {
            
            self.localizationProvider = localizationProvider
            self.isDisplayed = false
            self.onGridSelected = onGridSelected
            self.onSpeakerSelected = onSpeakerSelected
          
            
            let gridDrawer = DrawerSelectableItemViewModel(
                icon: .gridIcon,
                title: localizationProvider.getLocalizedString(.galleryOptionTitle),
                accessibilityIdentifier: "",
                accessibilityLabel: "",
                isSelected: localUserState.meetingLayoutState.operation == .grid,
                action: onGridSelected
            )
            
            let speakerDrawer = DrawerSelectableItemViewModel(
                icon: .speakerIcon,
                title: localizationProvider.getLocalizedString(.speakerOptionTitle),
                accessibilityIdentifier: "",
                accessibilityLabel: "",
                isSelected: localUserState.meetingLayoutState.operation == .speaker,
                action: onSpeakerSelected
            )
            
            
            items = [gridDrawer, speakerDrawer]
        }
    
    func update(localUserState: LocalUserState, isDisplayed: Bool) {
        self.isDisplayed = isDisplayed
        
        let gridDrawer = DrawerSelectableItemViewModel(
            icon: .gridIcon,
            title: localizationProvider.getLocalizedString(.galleryOptionTitle),
            accessibilityIdentifier: "",
            accessibilityLabel: "",
            isSelected: localUserState.meetingLayoutState.operation == .grid,
            action: onGridSelected
        )
        
        let speakerDrawer = DrawerSelectableItemViewModel(
            icon: .speakerIcon,
            title: localizationProvider.getLocalizedString(.speakerOptionTitle),
            accessibilityIdentifier: "",
            accessibilityLabel: "",
            isSelected: localUserState.meetingLayoutState.operation == .speaker,
            action: onSpeakerSelected
        )
        
        items = [gridDrawer, speakerDrawer]
    }
    
    func getOptionsTitle() -> String {
        localizationProvider.getLocalizedString(.layoutOptionsTitle)
    }
}
