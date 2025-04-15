//import SwiftUI
//
//struct ParticipantGridLayoutView: View {
//    @ObservedObject var viewModel: ParticipantGridViewModel
//    let rendererViewManager: RendererViewManager?
//    let avatarViewManager: AvatarViewManagerProtocol
//    let screenSize: ScreenSizeClassType
//    let gridsMargin: CGFloat = 3
//    @Orientation var orientation: UIDeviceOrientation
//
//    var body: some View {
//        #if DEBUG
//        let _ = Self._printChanges()
//        #endif
//
//        Group {
//            if screenSize == .iphonePortraitScreenSize || orientation.isPortrait {
//                vGridLayout
//            } else {
//                hGridLayout
//            }
//        }
//    }
//
//    // MARK: - Helpers
//
//    var pinnedParticipant: ParticipantGridCellViewModel? {
//        cellViewModels.first(where: { $0.isPinned })
//    }
//
//    var cellViewModels: [ParticipantGridCellViewModel] {
//        viewModel.participantsCellViewModelArr
//    }
//
//    var unpinnedParticipants: [ParticipantGridCellViewModel] {
//        cellViewModels.filter { !$0.isPinned }
//    }
//
//    func getChunkedCellViewModelArray(from viewModels: [ParticipantGridCellViewModel]) -> [[ParticipantGridCellViewModel]] {
//        let cellCount = viewModels.count
//        let vGridLayout = true // Only supporting portrait for now
//
//        var screenBasedRowSize = 2
//        if pinnedParticipant != nil && cellCount == 2{
//            screenBasedRowSize = 2
//        } else if pinnedParticipant == nil && cellCount == 1 {
//            screenBasedRowSize = 1
//        } else if screenSize != .ipadScreenSize {
//            screenBasedRowSize = cellCount == 2 ? 1 : 2
//        } else if cellCount <= 2 {
//            screenBasedRowSize = cellCount == 2 ? 2 : 1
//        } else if cellCount % 2 == 0 {
//            screenBasedRowSize = 3
//        } else {
//            screenBasedRowSize = cellCount < 5 ? 2 : 3
//        }
//
//        return viewModels.chunkedAndReversed(into: screenBasedRowSize, vGridLayout: vGridLayout)
//    }
//
//    // MARK: - Layouts
//
//    var vGridLayout: some View {
//        if let pinned = pinnedParticipant {
//            var unpinnedVisibleParticipantsCount: Int = 0
//
//            if unpinnedParticipants.count > 2 {
//                unpinnedVisibleParticipantsCount = 1
//            } else {
//                unpinnedVisibleParticipantsCount = unpinnedParticipants.count
//            }
//
//            let unpinnedVisibleParticipants = Array(unpinnedParticipants.prefix(unpinnedVisibleParticipantsCount))
//            let chunkedArray = getChunkedCellViewModelArray(from: unpinnedVisibleParticipants)
//
//            return AnyView(
//                VStack(spacing: gridsMargin) {
//                    ParticipantGridCellView(
//                        viewModel: pinned,
//                        rendererViewManager: rendererViewManager,
//                        avatarViewManager: avatarViewManager
//                    )
//                    .frame(height: UIScreen.main.bounds.height * 0.60)
//                    .background(Color(UIColor.compositeColor(.lightPurple)))
//                    .clipShape(RoundedRectangle(cornerRadius: 12))
//
//                    ForEach(0..<chunkedArray.count, id: \.self) { index in
//                        HStack(spacing: gridsMargin) {
//                            getRowView(cellsViewModel: chunkedArray[index])
//                        }
//                    }
//
//                    if unpinnedParticipants.count > 2 {
//                        let remainingCount = unpinnedParticipants.count - 2
//                        MoreParticipantView(moreParticipantCount: remainingCount)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color(UIColor.compositeColor(.lightPurple)))
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                    }
//                }
//                .background(Color.white)
//                .accessibilityElement(children: .contain)
//            )
//        } else {
//            var unpinnedVisibleParticipantsCount: Int = 0
//
//            if unpinnedParticipants.count > 8 {
//                unpinnedVisibleParticipantsCount = 7
//            } else {
//                unpinnedVisibleParticipantsCount = unpinnedParticipants.count
//            }
//
//            let unpinnedVisibleParticipants = Array(unpinnedParticipants.prefix(unpinnedVisibleParticipantsCount))
//            let chunkedArray = getChunkedCellViewModelArray(from: unpinnedVisibleParticipants)
//
//
//            return AnyView(
//                VStack(spacing: gridsMargin) {
//                    ForEach(0..<chunkedArray.count, id: \.self) { index in
//                        HStack(spacing: gridsMargin) {
//                            getRowView(cellsViewModel: chunkedArray[index])
//                        }
//                    }
//
//                    if unpinnedParticipants.count > 8 {
//                        let remainingCount = unpinnedParticipants.count - 8
//                        MoreParticipantView(moreParticipantCount: remainingCount)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity)
//                            .background(Color(UIColor.compositeColor(.lightPurple)))
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                    }
//                }
//                .background(Color.white)
//                .accessibilityElement(children: .contain)
//            )
//        }
//    }
//
//
//
//    var hGridLayout: some View {
//        let chunkedArray = getChunkedCellViewModelArray(from: cellViewModels)
//
//        return HStack(spacing: gridsMargin) {
//            ForEach(0..<chunkedArray.count, id: \.self) { index in
//                VStack(spacing: gridsMargin) {
//                    getRowView(cellsViewModel: chunkedArray[index])
//                }
//            }
//        }
//        .background(Color.white)
//        .accessibilityElement(children: .contain)
//    }
//
//    func getRowView(cellsViewModel: [ParticipantGridCellViewModel]) -> some View {
//        ForEach(cellsViewModel) { vm in
//            ParticipantGridCellView(
//                viewModel: vm,
//                rendererViewManager: rendererViewManager,
//                avatarViewManager: avatarViewManager
//            )
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color(UIColor.compositeColor(.lightPurple)))
//            .clipShape(RoundedRectangle(cornerRadius: 12))
//            .accessibilityElement(children: .contain)
//        }
//    }
//}

import SwiftUI

struct ParticipantGridLayoutView: View {
    @ObservedObject var viewModel: ParticipantGridViewModel
    let rendererViewManager: RendererViewManager?
    let avatarViewManager: AvatarViewManagerProtocol
    let screenSize: ScreenSizeClassType
    let gridsMargin: CGFloat = 3
    @Orientation var orientation: UIDeviceOrientation
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        Group {
            if screenSize == .iphonePortraitScreenSize || orientation.isPortrait {
                vGridLayout
            } else {
                hGridLayout
            }
        }
    }
    
    // MARK: - Helpers
    
    var pinnedParticipant: ParticipantGridCellViewModel? {
        cellViewModels.first(where: { $0.isPinned })
    }
    
    var cellViewModels: [ParticipantGridCellViewModel] {
        viewModel.participantsCellViewModelArr
    }
    
    var unpinnedParticipants: [ParticipantGridCellViewModel] {
        cellViewModels.filter { !$0.isPinned }
    }
    
    func getChunkedCellViewModelArray(from viewModels: [ParticipantGridCellViewModel]) -> [[ParticipantGridCellViewModel]] {
        let cellCount = viewModels.count
        let vGridLayout = true // Only supporting portrait for now
        
        var screenBasedRowSize = 2
        if pinnedParticipant != nil && cellCount == 2 {
            screenBasedRowSize = 2
        } else if pinnedParticipant == nil && cellCount == 1 {
            screenBasedRowSize = 1
        } else if screenSize != .ipadScreenSize {
            screenBasedRowSize = cellCount == 2 ? 1 : 2
        } else if cellCount <= 2 {
            screenBasedRowSize = cellCount == 2 ? 2 : 1
        } else if cellCount % 2 == 0 {
            screenBasedRowSize = 3
        } else {
            screenBasedRowSize = cellCount < 5 ? 2 : 3
        }
        
        return viewModels.chunkedAndReversed(into: screenBasedRowSize, vGridLayout: vGridLayout)
    }
    
    // MARK: - Layouts
    
    var vGridLayout: some View {
        
        if let pinned = pinnedParticipant {
            let maxVisible = 2
            let visibleCount = min(unpinnedParticipants.count, maxVisible)
            var hiddenCount = 0
            
            if visibleCount == unpinnedParticipants.count {
                hiddenCount = 0
            } else {
                hiddenCount = unpinnedParticipants.count - visibleCount + 1
            }
            
            let visibleUnpinned = Array(unpinnedParticipants.prefix(visibleCount))
            let chunkedArray = getChunkedCellViewModelArray(from: visibleUnpinned)
            
            return AnyView(
                VStack(spacing: gridsMargin) {
                    ParticipantGridCellView(
                        viewModel: pinned,
                        rendererViewManager: rendererViewManager,
                        avatarViewManager: avatarViewManager
                    )
                    .id(pinned.id)
                    .frame(height: UIScreen.main.bounds.height * 0.60)
                    .background(Color(UIColor.compositeColor(.lightPurple)))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    ForEach(0..<chunkedArray.count, id: \.self) { index in
                        getRowView(
                            cellsViewModel: chunkedArray[index],
                            isLastRow: index == chunkedArray.count - 1,
                            totalRemainingHiddenParticipants: hiddenCount
                        )
                    }
                }
                    .background(Color.white)
                    .accessibilityElement(children: .contain)
            )
        } else {
            let maxVisible = 8
            let visibleCount = min(unpinnedParticipants.count, maxVisible)
            var hiddenCount = 0
            
            if visibleCount == unpinnedParticipants.count {
                hiddenCount = 0
            } else {
                hiddenCount = unpinnedParticipants.count - visibleCount + 1
            }
            
            let visibleUnpinned = Array(unpinnedParticipants.prefix(visibleCount))
            let chunkedArray = getChunkedCellViewModelArray(from: visibleUnpinned)
            
            return AnyView(
                VStack(spacing: gridsMargin) {
                    ForEach(0..<chunkedArray.count, id: \.self) { index in
                        getRowView(
                            cellsViewModel: chunkedArray[index],
                            isLastRow: index == chunkedArray.count - 1,
                            totalRemainingHiddenParticipants: hiddenCount
                        )
                    }
                }
                    .background(Color.white)
                    .accessibilityElement(children: .contain)
            )
        }
    }
    
    var hGridLayout: some View {
        let chunkedArray = getChunkedCellViewModelArray(from: cellViewModels)
        return HStack(spacing: gridsMargin) {
            ForEach(0..<chunkedArray.count, id: \.self) { index in
                VStack(spacing: gridsMargin) {
                    getRowView(
                        cellsViewModel: chunkedArray[index],
                        isLastRow: false,
                        totalRemainingHiddenParticipants: 0
                    )
                }
            }
        }
        .background(Color.white)
        .accessibilityElement(children: .contain)
    }
    
    func getRowView(
        cellsViewModel: [ParticipantGridCellViewModel],
        isLastRow: Bool,
        totalRemainingHiddenParticipants: Int
    ) -> some View {
        HStack(spacing: gridsMargin) {
            ForEach(0..<cellsViewModel.count, id: \.self) { index in
                if isLastRow,
                   index == cellsViewModel.count - 1,
                   totalRemainingHiddenParticipants > 0 {
                    MoreParticipantView(moreParticipantCount: totalRemainingHiddenParticipants)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(UIColor.compositeColor(.lightPurple)))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    ParticipantGridCellView(
                        viewModel: cellsViewModel[index],
                        rendererViewManager: rendererViewManager,
                        avatarViewManager: avatarViewManager
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.compositeColor(.lightPurple)))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .contain)
                    .id(cellsViewModel[index].id)
                }
            }
        }
    }
}
