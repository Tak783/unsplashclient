//
//  PhotoSearchViewModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreFoundational
import CoreNetworking
import CoreSearch
import Foundation

@MainActor
@Observable
public final class PhotoSearchViewModel {
    public let gridLayoutModel: GridLayoutModel
    public let paginationModel: PaginationModel

    public var isShowingErrorAlert = false
    public var photos = [UnsplashPhotoModel]()
    public var photoCellPresentationModels = [PhotoFeedCellPresentationModel]()
    public var alreadySeenPhotoIDs = Set<String>()
    public var nextPageNumber = 1
    public var hasMorePagesToLoad = true
    public var photoIDThatTriggersNextPage: String?
    public var isLoadingNextPage = false
    public var errorMessage: String?

    public var searchQuery = String.empty {
        didSet { searchQueryDidChange() }
    }

    public private(set) var hasSearched = false

    private var activeQuery = String.empty
    private var searchGeneration = 0

    private let photosService: PhotosService
    private let searchQueryDebouncer = SearchQueryDebouncer()

    public init(
        photosService: PhotosService,
        gridLayoutModel: GridLayoutModel,
        paginationModel: PaginationModel
    ) {
        self.photosService = photosService
        self.gridLayoutModel = gridLayoutModel
        self.paginationModel = paginationModel
    }
}

// MARK: - PhotoFeedPaginating
extension PhotoSearchViewModel: PhotoFeedPaginating {
    public func loadPhotos(forPageNumber pageNumber: Int) async throws -> [UnsplashPhotoModel] {
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
public extension PhotoSearchViewModel {
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
public extension PhotoSearchViewModel {
    private func startNewSearch(for query: String) async {
        searchGeneration += 1
        isLoadingNextPage = false
        activeQuery = query
        hasSearched = true
        resetPaging()

        safePrint("Searching for \(query)")
        
        await loadNextPage()
    }

    private func clearResults() {
        searchGeneration += 1
        activeQuery = .empty
        hasSearched = false
        resetPaging()
        safePrint("Search results cleared")
    }
}
