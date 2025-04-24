//
//  NoiseSuppressionItemViewModel.swift
//  Pods
//
//  Created by Yriy Malyts on 09.04.2025.
//

internal class NoiseSuppressionItemViewModel: BaseDrawerItemViewModel {
    var title: String
    let icon: CompositeIcon
    var isOn: Bool
    var toggleAction: (Bool) -> Void
    
    init(title: String,
         icon: CompositeIcon,
         isOn: Bool,
         toggleAction: @escaping (Bool) -> Void) {
        self.title = title
        self.icon = icon
        self.isOn = isOn
        self.toggleAction = toggleAction
    }
}
