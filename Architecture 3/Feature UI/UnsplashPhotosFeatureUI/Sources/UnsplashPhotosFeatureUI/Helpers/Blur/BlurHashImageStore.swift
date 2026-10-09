//
//  BlurHashImageStore.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import UIKit
import UnsplashPhotosFeature

public actor BlurHashImageStore {
    public static let shared = BlurHashImageStore()

    private static let decodedImageSize = CGSize(width: 32, height: 32)
    private static let maximumCachedImages = 600

    private var decodedImagesByBlurHash: [String: UIImage] = [:]
    private var blurHashesLeastRecentlyUsedFirst: [String] = []

    public func image(forBlurHash blurHash: String) -> UIImage? {
        if let alreadyDecodedImage = decodedImagesByBlurHash[blurHash] {
            markAsMostRecentlyUsed(blurHash)
            return alreadyDecodedImage
        }

        guard let newlyDecodedImage = BlurHashDecoder.decode(
            blurHash,
            outputSize: Self.decodedImageSize
        ) else {
            return nil
        }

        evictLeastRecentlyUsedImageIfFull()
        decodedImagesByBlurHash[blurHash] = newlyDecodedImage
        blurHashesLeastRecentlyUsedFirst.append(blurHash)
        return newlyDecodedImage
    }
}

// MARK: - Eviction
public extension BlurHashImageStore {
    private func markAsMostRecentlyUsed(_ blurHash: String) {
        guard let currentPosition = blurHashesLeastRecentlyUsedFirst.firstIndex(of: blurHash) else {
            return
        }
        blurHashesLeastRecentlyUsedFirst.remove(at: currentPosition)
        blurHashesLeastRecentlyUsedFirst.append(blurHash)
    }

    private func evictLeastRecentlyUsedImageIfFull() {
        guard decodedImagesByBlurHash.count >= Self.maximumCachedImages else { return }
        guard !blurHashesLeastRecentlyUsedFirst.isEmpty else { return }

        let leastRecentlyUsedBlurHash = blurHashesLeastRecentlyUsedFirst.removeFirst()
        decodedImagesByBlurHash.removeValue(forKey: leastRecentlyUsedBlurHash)
    }
}
