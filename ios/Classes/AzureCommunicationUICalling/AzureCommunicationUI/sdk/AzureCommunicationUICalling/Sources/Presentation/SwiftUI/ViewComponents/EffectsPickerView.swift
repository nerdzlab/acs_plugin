//
//  BackgroundEffectsPickerView.swift
//  Pods
//
//  Created by Yriy Malyts on 18.04.2025.
//

import SwiftUI

struct EffectsPickerView: View {
    @ObservedObject var viewModel: EffectsPickerViewModel
    let topInset = UIApplication.shared.topSafeAreaHeight

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 3
    )

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Top padding for safe area
                Color.clear
                    .frame(height: topInset)

                ZStack {
                    Text(viewModel.title)
                        .font(AppFont.CircularStd.bold.font(size: 24))

                    HStack {
                        Spacer()
                        IconButton(viewModel: viewModel.dismissButtonViewModel)
                    }
                    .padding(.trailing)
                }
                .frame(height: 45)
                Spacer()

                // Grid in rounded container
                VStack {
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(viewModel.effects.indices, id: \.self) { index in
                            let effect = viewModel.effects[index]
                            ZStack {
                                effect.previewImage
                                    .resizable()
                                    .frame(height: 65)
                                    .clipped()
                                    .cornerRadius(8)

                                if viewModel.selectedEffect == effect {
                                    RoundedRectangle(
                                        cornerRadius: 8)
                                        .stroke(Color(UIColor.compositeColor(.purpleBlue)), lineWidth: 2)
                                    ImageProvider().getImage(for: .checkmarkEffects)
                                        .frame(width: 20, height: 20)
                                        .offset(x: 35, y: -15)
                                }
                            }
                            .onTapGesture {
                                viewModel.onEffects(effect)
                            }
                        }
                    }
                    .padding()
                }
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .padding(.bottom, 34)
                .shadow(radius: 4)
            }
        }
        .background(Color.clear)
    }


}


extension UIApplication {
    var topSafeAreaHeight: CGFloat {
        let keyWindow = connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        return keyWindow?.safeAreaInsets.top ?? 0
    }
}
