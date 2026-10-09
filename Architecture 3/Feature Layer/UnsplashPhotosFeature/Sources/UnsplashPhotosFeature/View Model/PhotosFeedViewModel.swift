//
//  PhotosFeedViewModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@MainActor
@Observable
public final class PhotosFeedViewModel {
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

    private let photosService: PhotosService

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
extension PhotosFeedViewModel: PhotoFeedPaginating {
    public func loadPhotos(forPageNumber pageNumber: Int) async throws -> [UnsplashPhotoModel] {
        try await photosService.loadPhotos(
            pageNumber: pageNumber,
            photosPerPage: paginationModel.itemsPerPage
        )
    }
}

// MARK: - Load Feed
public extension PhotosFeedViewModel {
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
