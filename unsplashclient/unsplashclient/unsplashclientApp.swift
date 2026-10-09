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
    private static let imageMemoryCacheLimitInBytes = 100 * 1024 * 1024

    init() {
        ImageCache.default.memoryStorage.config.totalCostLimit = Self.imageMemoryCacheLimitInBytes
    }

    var body: some Scene {
        WindowGroup {
            PhotosFeedView(viewModel: Self.makePhotosFeedViewModel())
                .preferredColorScheme(.dark)
        }
    }

    private static func makePhotosFeedViewModel() -> PhotosFeedViewModel {
        let photosService = RemotePhotosService(
            httpClient: URLSessionHTTPClient(),
            apiKeyProvider: UnsplashAPIKeyProvider()
        )
        return PhotosFeedViewModel(
            photosService: photosService,
            gridLayoutModel: .init(),
            paginationModel: .init()
        )
    }
}
