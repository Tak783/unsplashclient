//
//  BlurHashPlaceholder.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import SwiftUI
import CoreNetworking
import UnsplashPhotosFeature

public struct BlurredImagePlaceholderView: View {
    public let blurHash: String?

    @State private var decodedBlurHashImage: UIImage?

    public var body: some View {
        Group {
            if let decodedBlurHashImage {
                Image(uiImage: decodedBlurHashImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Color.secondary.opacity(0.15)
            }
        }
        .task(id: blurHash) {
            guard let blurHash else { return }
            decodedBlurHashImage = await BlurHashImageStore.shared.image(forBlurHash: blurHash)
        }
    }
}
