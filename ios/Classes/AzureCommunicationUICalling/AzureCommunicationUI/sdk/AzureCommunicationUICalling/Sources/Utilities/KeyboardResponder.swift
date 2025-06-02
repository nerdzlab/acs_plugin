//
//  KeyboardResponder.swift
//  Pods
//
//  Created by Yriy Malyts on 09.04.2025.
//


import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)

        willShow
            .merge(with: willHide)
            .sink { notification in
                guard let userInfo = notification.userInfo else { return }

                let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
                let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? .zero
                let curveRaw = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt ?? 0
                _ = UIView.AnimationCurve(rawValue: Int(curveRaw)) ?? .easeInOut
                let height = notification.name == UIResponder.keyboardWillHideNotification ? 0 : endFrame.height

                withAnimation(.easeOut(duration: duration)) {
                    self.currentHeight = height
                }
            }
            .store(in: &cancellableSet)
    }
}
