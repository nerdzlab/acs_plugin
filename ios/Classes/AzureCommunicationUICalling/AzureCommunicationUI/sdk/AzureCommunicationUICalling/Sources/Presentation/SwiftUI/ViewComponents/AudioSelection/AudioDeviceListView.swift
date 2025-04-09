//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation
import SwiftUI
import FluentUI

//internal struct AudioDevicesListView: View {
//    @ObservedObject var viewModel: AudioDevicesListViewModel
//    let avatarManager: AvatarViewManagerProtocol
//
//    init(viewModel: AudioDevicesListViewModel,
//         avatarManager: AvatarViewManagerProtocol) {
//        self.viewModel = viewModel
//        self.avatarManager = avatarManager
//    }
//
//    var body: some View {
//#if DEBUG
//        let _ = Self._printChanges()
//#endif
//        
//        DrawerListView(sections: [DrawerListSection(header: nil, items: viewModel.audioDevicesList)],
//                       avatarManager: avatarManager)
//    }
//}

//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

internal struct AudioDevicesListView: View {
    @ObservedObject var viewModel: AudioDevicesListViewModel
    let avatarManager: AvatarViewManagerProtocol
    
    @State
    private var scrollViewContentSize: CGSize = .zero
    
    init(viewModel: AudioDevicesListViewModel,
         avatarManager: AvatarViewManagerProtocol) {
        self.viewModel = viewModel
        self.avatarManager = avatarManager
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
                    inflateView(for: item, avatarManager: avatarManager)
                        .accessibilityElement(children: .combine)
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
    
    func inflateView(for item: BaseDrawerItemViewModel, avatarManager: AvatarViewManagerProtocol) -> some View {
        if let selectableItem = item as? DrawerSelectableItemViewModel {
            return AnyView(DrawerSelectableItemView(item: selectableItem))
        } else if let titleItem = item as? TitleDrawerListItemViewModel {
            return AnyView(DrawerTitleView(item: titleItem))
        } else if let bodyItem = item as? BodyTextDrawerListItemViewModel {
            return AnyView(DrawerBodyTextView(item: bodyItem))
        } else if let participantItem = item as? ParticipantsListCellViewModel {
            return AnyView(DrawerParticipantView(item: participantItem, avatarManager: avatarManager))
        } else if let drawerItem = item as? DrawerGenericItemViewModel {
            return AnyView(DrawerGenericItemView(item: drawerItem))
        } else if let drawerItem = item as? BodyTextWithActionDrawerListItemViewModel {
            return AnyView(DrawerBodyWithActionTextView(item: drawerItem))
        }
        return AnyView(EmptyView())
    }
}

