//
//  PhotosFeedViewModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@MainActor
@Observable
final class PhotosFeedViewModel {
    let gridLayoutModel = GridLayoutModel()
    let paginationModel = PaginationModel()

    var isShowingErrorAlert = false
    var photos = [UnsplashPhotoModel]()
    var photoCellPresentationModels = [PhotoFeedCellPresentationModel]()
    var alreadySeenPhotoIDs = Set<String>()
    var nextPageNumber = 1
    var hasMorePagesToLoad = true
    var photoIDThatTriggersNextPage: String?
    var isLoadingNextPage = false
    var errorMessage: String?

    private let photosService = UnsplashPhotosService(
        httpClient: URLSessionHTTPClient(),
        apiKeyProvider: UnsplashAPIKeyProvider()
    )
}

// MARK: - PhotoFeedPaginating
extension PhotosFeedViewModel: PhotoFeedPaginating {
    func loadPhotos(forPageNumber pageNumber: Int) async throws -> [UnsplashPhotoModel] {
        try await photosService.loadPhotos(
            pageNumber: pageNumber,
            photosPerPage: paginationModel.itemsPerPage
        )
    }
}

// MARK: - Load Feed
extension PhotosFeedViewModel {
    func loadFirstPageIfNeeded() async {
        guard photos.isEmpty else { return }
        await loadNextPage()
    }

    func refresh() async {
        guard !isLoadingNextPage else { return }
        resetPaging()
        await loadNextPage()
    }
}
