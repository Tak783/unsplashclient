//
//  UnsplashClientApp.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher
import SwiftUI

@main
struct UnsplashClientApp: App {
    init() {
        Self.configureImageMemoryCache()
    }

    var body: some Scene {
        WindowGroup {
            PhotosRootView()
                .preferredColorScheme(.dark)
        }
    }
}

// MARK: - Image Cache
extension UnsplashClientApp {
    private static func configureImageMemoryCache() {
        ImageCache.default.memoryStorage.config.totalCostLimit = 100 * 1024 * 1024
    }
}
