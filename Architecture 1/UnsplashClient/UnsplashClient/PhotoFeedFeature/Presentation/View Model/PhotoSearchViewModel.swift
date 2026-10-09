//
//  PhotoSearchViewModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@MainActor
@Observable
final class PhotoSearchViewModel {
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

    var searchQuery = String() {
        didSet { searchQueryDidChange() }
    }

    private(set) var hasSearched = false

    private var activeQuery = String()
    private var searchGeneration = 0

    private let photosService = UnsplashPhotosService(
        httpClient: URLSessionHTTPClient(),
        apiKeyProvider: UnsplashAPIKeyProvider()
    )

    private let searchQueryDebouncer = SearchQueryDebouncer()
}

// MARK: - PhotoFeedPaginating
extension PhotoSearchViewModel: PhotoFeedPaginating {
    func loadPhotos(forPageNumber pageNumber: Int) async throws -> [UnsplashPhotoModel] {
        guard !activeQuery.isEmpty else { return [] }

        let generationBeingLoaded = searchGeneration
        let loadedPhotos = try await photosService.searchPhotos(
            query: activeQuery,
            pageNumber: pageNumber,
            photosPerPage: paginationModel.itemsPerPage
        )

        guard generationBeingLoaded == searchGeneration else { return [] }

        return loadedPhotos
    }
}

// MARK: - Typing
extension PhotoSearchViewModel {
    private func searchQueryDidChange() {
        searchQueryDebouncer.queryDidChange(
            searchQuery,
            perform: { [weak self] query in
                await self?.startNewSearch(for: query)
            },
            onQueryTooShort: { [weak self] in
                self?.clearResults()
            }
        )
    }
}

// MARK: - Searching
extension PhotoSearchViewModel {
    private func startNewSearch(for query: String) async {
        searchGeneration += 1
        isLoadingNextPage = false
        activeQuery = query
        hasSearched = true
        resetPaging()

        await loadNextPage()
    }

    private func clearResults() {
        searchGeneration += 1
        activeQuery = .init()
        hasSearched = false
        resetPaging()
    }
}
