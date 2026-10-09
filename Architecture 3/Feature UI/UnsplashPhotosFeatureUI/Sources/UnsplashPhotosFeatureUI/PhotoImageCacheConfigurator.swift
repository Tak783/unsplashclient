//
//  PhotoImageCacheConfigurator.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher

public enum PhotoImageCacheConfigurator {
    private static let memoryCacheLimitInBytes = 100 * 1024 * 1024

    public static func configure() {
        ImageCache.default.memoryStorage.config.totalCostLimit = memoryCacheLimitInBytes
    }
}
