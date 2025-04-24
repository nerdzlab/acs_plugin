//
//  NoiseSuppressionToggleView.swift
//  Pods
//
//  Created by Yriy Malyts on 09.04.2025.
//
import SwiftUI

internal struct NoiseSuppressionToggleView: View {
    var viewModel: NoiseSuppressionItemViewModel
    
    @State private var isOn: Bool
    
    init(viewModel: NoiseSuppressionItemViewModel) {
        self.viewModel = viewModel
        self._isOn = State(initialValue: viewModel.isOn)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Icon(name: viewModel.icon, size: DrawerListConstants.iconSize, renderAsOriginal: true)
                
                // Text
                Text(viewModel.title)
                    .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                    .padding(.leading, DrawerListConstants.textPaddingLeading)
                    .font(AppFont.CircularStd.book.font(size: 16))
                
                Spacer()
                
                // Toggle on right side
                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .onChange(of: isOn) { newValue in
                        viewModel.toggleAction(newValue)
                    }
            }
            .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
            .padding(.vertical, DrawerListConstants.optionPaddingVertical)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
        }
    }
}
