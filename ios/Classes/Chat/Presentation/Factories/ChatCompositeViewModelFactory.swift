//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import Foundation

protocol ChatCompositeViewModelFactoryProtocol {
    // MARK: CompositeViewModels
    func getChatViewModel() -> ChatViewModel

    // MARK: ComponentViewModels
    func makeIconButtonViewModel(iconName: ChatCompositeIcon,
                                 buttonType: ChatIconButtonViewModel.ButtonType,
                                 isDisabled: Bool,
                                 action: @escaping (() -> Void)) -> ChatIconButtonViewModel

    // MARK: ChatViewModels
    func makeTopBarViewModel(dispatch: @escaping ChatActionDispatch,
                             participantsState: ChatParticipantsState) -> TopBarViewModel
    func makeMessageListViewModel(dispatch: @escaping ChatActionDispatch) -> MessageListViewModel
    func makeBottomBarViewModel(dispatch: @escaping ChatActionDispatch) -> BottomBarViewModel
    func makeTypingParticipantsViewModel() -> TypingParticipantsViewModel
}

class ChatCompositeViewModelFactory: ChatCompositeViewModelFactoryProtocol {
    private let logger: Logger
    private let localizationProvider: ChatLocalizationProviderProtocol
    private let messageRepositoryManager: MessageRepositoryManagerProtocol
    private let store: Store<ChatAppState, ActionChat>

    private weak var chatViewModel: ChatViewModel?

    // unit test needed
    // - only skeleton code to show view, class not finalized yet
    init(logger: Logger,
         localizationProvider: ChatLocalizationProviderProtocol,
         messageRepositoryManager: MessageRepositoryManagerProtocol,
         store: Store<ChatAppState, ActionChat>) {
        self.logger = logger
        self.localizationProvider = localizationProvider
        self.messageRepositoryManager = messageRepositoryManager
        self.store = store
    }

    // MARK: CompositeViewModels
    func getChatViewModel() -> ChatViewModel {
        guard let viewModel = self.chatViewModel else {
            let viewModel = ChatViewModel(compositeViewModelFactory: self,
                                          logger: logger,
                                          store: store)
            self.chatViewModel = viewModel
            return viewModel
        }
        return viewModel
    }

    // MARK: ComponentViewModels
    func makeIconButtonViewModel(iconName: ChatCompositeIcon,
                                 buttonType: ChatIconButtonViewModel.ButtonType = .controlButton,
                                 isDisabled: Bool,
                                 action: @escaping (() -> Void)) -> ChatIconButtonViewModel {
        ChatIconButtonViewModel(iconName: iconName,
                            buttonType: buttonType,
                            isDisabled: isDisabled,
                            action: action)
    }

    // MARK: ChatViewModels
    func makeTopBarViewModel(dispatch: @escaping ChatActionDispatch,
                             participantsState: ChatParticipantsState) -> TopBarViewModel {
        TopBarViewModel(compositeViewModelFactory: self,
                        localizationProvider: localizationProvider,
                        dispatch: dispatch,
                        participantsState: participantsState)
    }

    func makeMessageListViewModel(dispatch: @escaping ChatActionDispatch) -> MessageListViewModel {
        MessageListViewModel(compositeViewModelFactory: self,
                             messageRepositoryManager: messageRepositoryManager,
                             logger: logger,
                             dispatch: store.dispatch)
    }

    func makeBottomBarViewModel(dispatch: @escaping ChatActionDispatch) -> BottomBarViewModel {
        BottomBarViewModel(compositeViewModelFactory: self,
                           logger: logger,
                           dispatch: dispatch)
    }

    func makeTypingParticipantsViewModel() -> TypingParticipantsViewModel {
        TypingParticipantsViewModel(logger: logger,
                                    localizationProvider: localizationProvider)
    }
}
