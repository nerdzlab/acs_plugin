//
//  RawVideoFrameView.swift
//  Pods
//
//  Created by Yriy Malyts on 01.05.2025.
//


import SwiftUI
import CoreVideo

struct RawVideoFrameView : UIViewRepresentable {
    @Binding var cvPixelBuffer: CVPixelBuffer?

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        return imageView
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        guard let pixelBuffer = cvPixelBuffer else {
            return
        }
        
        var ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        
        let w = ciImage.extent.width
        let h = ciImage.extent.height
        let viewW = uiView.bounds.width;
        let viewH = uiView.bounds.height;
        let scaleFactorX = viewW / w;
        let scaleFactorY = viewH / h;
        
        // Fit
        let scale = min(scaleFactorX, scaleFactorY)
        
        var transform = CGAffineTransform.identity
        transform = transform.scaledBy(x: scale, y: scale)
        
        ciImage = ciImage.transformed(by: transform)
        
        let uiImage = UIImage(ciImage: ciImage)
        uiView.image = uiImage
        uiView.contentMode = .scaleAspectFit
    }
}
