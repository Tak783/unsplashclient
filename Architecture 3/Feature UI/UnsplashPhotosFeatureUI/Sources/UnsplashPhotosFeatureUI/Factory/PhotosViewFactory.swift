//
//  PhotosViewFactory.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI
import CoreNetworking
import UnsplashPhotosFeature

@MainActor
public enum PhotosViewFactory {
    public static func makePhotosRootView() -> some View {
        PhotosRootView(feedViewModel: makePhotosFeedViewModel())
    }

    public static func makePhotoSearchView(
        isSearchPresented: Binding<Bool>
    ) -> some View {
        PhotoSearchView(
            viewModel: makePhotoSearchViewModel(),
            isSearchPresented: isSearchPresented
        )
    }
}

// MARK: - View Models
public extension PhotosViewFactory {
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
public extension PhotosViewFactory {
    private static func makePhotosService() -> PhotosService {
        RemotePhotosService(
            httpClient: URLSessionHTTPClient(),
            apiKeyProvider: UnsplashAPIKeyProvider()
        )
    }
}
