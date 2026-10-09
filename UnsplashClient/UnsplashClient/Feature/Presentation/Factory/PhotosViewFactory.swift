//
//  PhotosViewFactory.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

enum PhotosViewFactory {
    static func makePhotosRootView() -> some View {
        PhotosRootView(feedViewModel: makePhotosFeedViewModel())
    }

    static func makePhotoSearchView() -> some View {
        PhotoSearchView(
            viewModel: makePhotoSearchViewModel()
        )
    }
}

// MARK: - View Models
extension PhotosViewFactory {
    private static func makePhotosFeedViewModel() -> PhotosFeedViewModel {
        PhotosFeedViewModel(
            photosService: makePhotosService(),
            gridLayoutModel: .init(),
            paginationModel: .init()
        )
    }

    private static func makePhotoSearchViewModel() -> PhotoSearchViewModel {
        PhotoSearchViewModel(
            photosService: makePhotosService(),
            gridLayoutModel: .init(),
            paginationModel: .init()
        )
    }
}

// MARK: - Services
extension PhotosViewFactory {
    private static func makePhotosService() -> PhotosService {
        RemotePhotosService(
            httpClient: URLSessionHTTPClient(),
            apiKeyProvider: UnsplashAPIKeyProvider()
        )
    }
}
