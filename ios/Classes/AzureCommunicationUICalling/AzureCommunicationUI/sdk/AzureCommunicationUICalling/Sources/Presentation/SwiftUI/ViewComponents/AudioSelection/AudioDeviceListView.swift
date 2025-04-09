//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI
import FluentUI

internal struct AudioDevicesListView: View {
    @ObservedObject var viewModel: AudioDevicesListViewModel
    
    @State
    private var scrollViewContentSize: CGSize = .zero
    
    init(viewModel: AudioDevicesListViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        let halfScreenHeight = UIScreen.main.bounds.height * 0.5
        
        ScrollView {
            LazyVStack(spacing: 0, pinnedViews: .sectionHeaders) {
                HStack {
                    Spacer()
                    Text(viewModel.listTitle)
                        .foregroundColor(Color(UIColor.compositeColor(.textPrimary)))
                        .padding(.leading, DrawerListConstants.textPaddingLeading)
                        .font(AppFont.CircularStd.bold.font(size: 20))
                        .accessibilityAddTraits(.isHeader)
                    Spacer()
                }
                .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .background(Color(StyleProvider.color.drawerColor))
                
                ForEach(0..<viewModel.audioDevicesList.count, id: \.self) { itemIndex in
                    let item = viewModel.audioDevicesList[itemIndex]
                    AnyView(DrawerSelectableItemView(item: item))
                }
                
                Divider()
                    .padding(.horizontal, DrawerListConstants.optionPaddingHorizontal)
                
                if let noiseSuppressionViewModel = viewModel.noiseSuppressionViewModel { NoiseSuppressionToggleView(viewModel: noiseSuppressionViewModel)
                }
            }
            .padding([.bottom, .top], DrawerListConstants.listVerticalPadding)
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            DispatchQueue.main.async {
                                scrollViewContentSize = geometry.size
                            }
                        }
                        .onChange(of: geometry.size) { _ in
                            DispatchQueue.main.async {
                                withAnimation {
                                    scrollViewContentSize = geometry.size
                                }
                            }
                        }
                }
            )
        }
        .frame(maxHeight: min(scrollViewContentSize.height, halfScreenHeight))
    }
}
