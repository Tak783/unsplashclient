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
    let gridLayoutModel: GridLayoutModel
    let paginationModel: PaginationModel

    var isShowingErrorAlert = false
    var searchQuery = String() {
        didSet { searchQueryDidChange() }
    }

    private(set) var isLoadingNextPage = false
    private(set) var hasSearched = false
    private(set) var photoCellPresentationModels = [PhotoFeedCellPresentationModel]()
    private(set) var errorMessage: String?

    private var nextPageNumber = 1
    private var hasMorePagesToLoad = true
    private var activeQuery = String()
    private var searchGeneration = Int.zero
    private var alreadySeenPhotoIDs = Set<String>()
    private var photos = [UnsplashPhotoModel]()

    private let photosService: PhotosService
    private let searchQueryDebouncer = SearchQueryDebouncer()

    init(
        photosService: PhotosService,
        gridLayoutModel: GridLayoutModel,
        paginationModel: PaginationModel
    ) {
        self.photosService = photosService
        self.gridLayoutModel = gridLayoutModel
        self.paginationModel = paginationModel
    }
}

// MARK: - Searching
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

    private func startNewSearch(for query: String) async {
        searchGeneration += 1
        isLoadingNextPage = false
        activeQuery = query
        nextPageNumber = 1
        hasMorePagesToLoad = true
        alreadySeenPhotoIDs.removeAll()
        photos.removeAll()
        photoCellPresentationModels.removeAll()
        errorMessage = nil
        hasSearched = true

        await loadNextPage()
    }

    func photoDidAppear(atIndex photoIndex: Int) {
        let indexThatTriggersNextPage =
            photoCellPresentationModels.count - paginationModel.itemsFromEndThatTriggerNextPage
        guard photoIndex >= indexThatTriggersNextPage else { return }
        Task { await loadNextPage() }
    }

    private func loadNextPage() async {
        guard !activeQuery.isEmpty else { return }
        guard !isLoadingNextPage, hasMorePagesToLoad, errorMessage == nil else { return }

        let generationBeingLoaded = searchGeneration
        let queryBeingLoaded = activeQuery

        isLoadingNextPage = true
        defer {
            if generationBeingLoaded == searchGeneration {
                isLoadingNextPage = false
            }
        }

        do {
            let loadedPhotos = try await photosService.searchPhotos(
                query: queryBeingLoaded,
                pageNumber: nextPageNumber,
                photosPerPage: paginationModel.itemsPerPage
            )

            guard generationBeingLoaded == searchGeneration else { return }

            hasMorePagesToLoad = !loadedPhotos.isEmpty
            nextPageNumber += 1
            appendPhotosNotSeenBefore(loadedPhotos)
        } catch {
            guard !CancellationCheck.isCancellation(error) else { return }
            guard generationBeingLoaded == searchGeneration else { return }
            errorMessage = PhotosServiceErrorMessage.userFacingMessage(for: error)
            isShowingErrorAlert = true
        }
    }

    private func appendPhotosNotSeenBefore(_ loadedPhotos: [UnsplashPhotoModel]) {
        let photosNotSeenBefore = loadedPhotos.filter {
            alreadySeenPhotoIDs.insert($0.id).inserted
        }
        guard !photosNotSeenBefore.isEmpty else { return }

        photos.append(contentsOf: photosNotSeenBefore)
        photoCellPresentationModels.append(
            contentsOf: photosNotSeenBefore.map(Self.makePresentationModel)
        )
    }

    private func clearResults() {
        activeQuery = .init()
        photos.removeAll()
        photoCellPresentationModels.removeAll()
        alreadySeenPhotoIDs.removeAll()
        nextPageNumber = 1
        hasMorePagesToLoad = true
        errorMessage = nil
        hasSearched = false
    }
}

// MARK: - Load Feed
extension PhotoSearchViewModel {
    func retryLoadingNextPage() async {
        errorMessage = nil
        await loadNextPage()
    }

    func dismissErrorMessage() {
        errorMessage = nil
    }

    func cancelSearch() {
        searchQueryDebouncer.cancelPendingSearch()
        searchQuery = .init()
        clearResults()
    }

    func submitSearch() {
        searchQueryDebouncer.submitImmediately(searchQuery) { [weak self] query in
            await self?.startNewSearch(for: query)
        }
    }
}


// MARK: - Lookup
extension PhotoSearchViewModel {
    func photo(withID photoID: String) -> UnsplashPhotoModel? {
        photos.first { $0.id == photoID }
    }
}

// MARK: - Presentation Mapping
extension PhotoSearchViewModel {
    private static func makePresentationModel(
        for photo: UnsplashPhotoModel
    ) -> PhotoFeedCellPresentationModel {
        PhotoFeedCellPresentationModel(
            id: photo.id,
            caption: PhotoCaptionResolver.caption(for: photo),
            imageURL: photo.urls?.small,
            blurHash: photo.blurHash
        )
    }
}
