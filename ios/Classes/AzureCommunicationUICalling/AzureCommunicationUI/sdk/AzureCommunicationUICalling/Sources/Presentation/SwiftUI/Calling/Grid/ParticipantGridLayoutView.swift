
import SwiftUI

struct ParticipantGridLayoutView: View {
    @ObservedObject var viewModel: ParticipantGridViewModel
    let rendererViewManager: RendererViewManager?
    let avatarViewManager: AvatarViewManagerProtocol
    let screenSize: ScreenSizeClassType
    let gridsMargin: CGFloat = 3
    @Orientation var orientation: UIDeviceOrientation
    
    //We need to have this value to leave previous layout
    //If user speaking and stop speak, and in this case we have no active speaker
    //But we need to leave layout as it now, so base on this we build layout as for active speake
    var previousSpeaker: ParticipantGridCellViewModel?
    
    var meetingLayoutState: LocalUserState.MeetingLayoutState {
        viewModel.meetingLayoutState
    }
    
    var activeSpeaker: ParticipantGridCellViewModel? {
        previousSpeaker ?? cellViewModels.first(where: { $0.isSpeaking })
    }
    
    var notActiveParticipants: [ParticipantGridCellViewModel] {
        var notActive = cellViewModels.filter { !$0.isSpeaking }
        
        //As we rely to logic with previousSpeaker, we need to remove it from notActiveParticipants
        if let previousSpeaker = previousSpeaker {
            notActive.removeAll(where: {$0.participantIdentifier == previousSpeaker.participantIdentifier})
        }
        
        return notActive
    }
    
    var body: some View {
#if DEBUG
        let _ = Self._printChanges()
#endif
        
        Group {
            if screenSize == .iphonePortraitScreenSize || orientation.isPortrait {
                verticalLayout
            } else {
                horizontalLayout
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
        if (pinnedParticipant != nil || (activeSpeaker != nil && meetingLayoutState.operation == .speaker)) && cellCount == 2 {
            screenBasedRowSize = 2
        } else if (pinnedParticipant == nil || activeSpeaker == nil) && cellCount == 1 {
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
    
    var verticalLayout: some View {
        switch meetingLayoutState.operation {
        case .grid:
            return AnyView(gridView)
            
        case .speaker:
            return AnyView(speakerView)
        }
    }
    
    var gridView: some View {
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
                    .background(Color(UIColor.compositeColor(.lightPurple)))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .if(unpinnedParticipants.count != 0) { view in
                        view.frame(height: UIScreen.main.bounds.height * 0.60)
                    }
                    
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
    
    var speakerView: some View {
        
        if cellViewModels.count == 1 {
            return AnyView(gridView)
        } else {
            if let activeSpeaker = activeSpeaker {
                let maxVisible = 2
                let visibleCount = min(notActiveParticipants.count, maxVisible)
                var hiddenCount = 0
                
                if visibleCount == notActiveParticipants.count {
                    hiddenCount = 0
                } else {
                    hiddenCount = notActiveParticipants.count - visibleCount + 1
                }
                
                var visibleNotActive: [ParticipantGridCellViewModel]
                
                if let pinned = pinnedParticipant, activeSpeaker != pinnedParticipant {
                    // Move pinned participant to the front and append the rest
                    visibleNotActive = [pinned] + notActiveParticipants.filter { $0.participantIdentifier != pinned.participantIdentifier }
                    visibleNotActive = Array(visibleNotActive.prefix(visibleCount))
                } else {
                    // If no pinned participant exists, take the first `visibleCount` participants
                    visibleNotActive = Array(notActiveParticipants.prefix(visibleCount))
                }
                
                let chunkedArray = getChunkedCellViewModelArray(from: visibleNotActive)
                
                return AnyView(
                    VStack(spacing: gridsMargin) {
                        ParticipantGridCellView(
                            viewModel: activeSpeaker,
                            rendererViewManager: rendererViewManager,
                            avatarViewManager: avatarViewManager
                        )
                        .id(activeSpeaker.id)
                        .background(Color(UIColor.compositeColor(.lightPurple)))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .frame(height: UIScreen.main.bounds.height * 0.60)
                        
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
                //If we have changed to speaker layout, but don't have active speaker
                //We stay on grid layout
                return AnyView(gridView)
            }
        }
    }
    
    var horizontalLayout: some View {
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
                    let isNeedCenteredCell = isLastRow && cellsViewModel.count == 1 && (viewModel.participantsCellViewModelArr.count > 2 || (pinnedParticipant != nil || (meetingLayoutState.operation == .speaker && activeSpeaker != nil && viewModel.participantsCellViewModelArr.count != 1)) )
                    
                    if isNeedCenteredCell {
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width * 0.25)
                    }
                    
                    
                    ParticipantGridCellView(
                        viewModel: cellsViewModel[index],
                        rendererViewManager: rendererViewManager,
                        avatarViewManager: avatarViewManager
                    )
                    .background(Color(UIColor.compositeColor(.lightPurple)))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityElement(children: .contain)
                    .id(cellsViewModel[index].id)
                    
                    if isNeedCenteredCell {
                        Spacer()
                            .frame(width: UIScreen.main.bounds.width * 0.25)
                    }
                }
            }
        }
    }
}


extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
