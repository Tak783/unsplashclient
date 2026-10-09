//
//  BlurHashImageStore.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import UIKit

actor BlurHashImageStore {
    static let shared = BlurHashImageStore()

    private static let decodedImageSize = CGSize(width: 32, height: 32)
    private static let maximumCachedImages = 600

    private var decodedImagesByBlurHash: [String: UIImage] = [:]

    func image(forBlurHash blurHash: String) -> UIImage? {
        if let alreadyDecodedImage = decodedImagesByBlurHash[blurHash] {
            return alreadyDecodedImage
        }

        guard let newlyDecodedImage = BlurHashDecoder.decode(
            blurHash,
            outputSize: Self.decodedImageSize
        ) else {
            return nil
        }

        if decodedImagesByBlurHash.count >= Self.maximumCachedImages {
            decodedImagesByBlurHash.removeAll(keepingCapacity: true)
        }
        decodedImagesByBlurHash[blurHash] = newlyDecodedImage
        return newlyDecodedImage
    }
}
