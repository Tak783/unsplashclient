//
//  PhotosFeedViewModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

@MainActor
@Observable
final class PhotosFeedViewModel {
    let gridLayoutModel: GridLayoutModel
    let paginationModel: PaginationModel

    var isShowingErrorAlert = false
    
    private var nextPageNumber = 1
    private var hasMorePagesToLoad = true
    private var alreadySeenPhotoIDs = Set<String>()
    private var photos = [UnsplashPhotoModel]()
    private let photosService: PhotosService

    private(set) var isLoadingNextPage = false
    private(set) var errorMessage: String?
    private(set) var photoCellPresentationModels = [PhotoFeedCellPresentationModel]()

    init(
        photosService: PhotosService,
        gridLayoutModel: GridLayoutModel,
        paginationModel: PaginationModel
    ) {
        self.gridLayoutModel = gridLayoutModel
        self.photosService = photosService
        self.paginationModel = paginationModel
    }
}

// MARK: - Load Feed
extension PhotosFeedViewModel {
    func loadFirstPageIfNeeded() async {
        guard photos.isEmpty else { return }
        await loadNextPage()
    }

    func retryLoadingNextPage() async {
        errorMessage = nil
        await loadNextPage()
    }

    func dismissErrorMessage() {
        errorMessage = nil
    }

    func refresh() async {
        guard !isLoadingNextPage else { return }
        nextPageNumber = 1
        hasMorePagesToLoad = true
        alreadySeenPhotoIDs.removeAll()
        photos.removeAll()
        photoCellPresentationModels.removeAll()
        errorMessage = nil
        await loadNextPage()
    }

   private func loadNextPage() async {
        guard !isLoadingNextPage, hasMorePagesToLoad, errorMessage == nil else {
            return
        }

        isLoadingNextPage = true
        defer {
            isLoadingNextPage = false
        }

        do {
            let loadedPhotos = try await photosService.loadPhotos(
                pageNumber: nextPageNumber,
                photosPerPage: paginationModel.itemsPerPage
            )
            hasMorePagesToLoad = !loadedPhotos.isEmpty
            nextPageNumber += 1
            appendPhotosNotSeenBefore(loadedPhotos)
        } catch {
            guard !CancellationCheck.isCancellation(error) else { return }
            errorMessage = PhotosServiceErrorMessage.userFacingMessage(for: error)
            isShowingErrorAlert = true
        }
    }

    private func reloadFeedIfNeeded(lastPhotoIndexSeen: Int) {
        let itemsFromEndThatTriggerNextPage = paginationModel.itemsFromEndThatTriggerNextPage
        let indexThatTriggersNextPage = photos.count - itemsFromEndThatTriggerNextPage
        let feedNeedsToReload = lastPhotoIndexSeen >= indexThatTriggersNextPage
        guard feedNeedsToReload else { return }
        Task {
            await loadNextPage()
        }
    }

    private func appendPhotosNotSeenBefore(_ loadedPhotos: [UnsplashPhotoModel]) {
        let photosNotSeenBefore = loadedPhotos.filter {
            alreadySeenPhotoIDs.insert($0.id).inserted
        }
        guard !photosNotSeenBefore.isEmpty else { return }
        photos.append(contentsOf: photosNotSeenBefore)
        photoCellPresentationModels.append(
            contentsOf: photosNotSeenBefore.map(makePresentationModel)
        )
    }
}

// MARK: - Presentation Mapping
extension PhotosFeedViewModel {
    private func makePresentationModel(
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

// MARK: - Photo Lookup
extension PhotosFeedViewModel {
    func photo(withID photoID: String) -> UnsplashPhotoModel? {
        photos.first { $0.id == photoID }
    }
}

// MARK: - View Events
extension PhotosFeedViewModel {
    func photoDidAppear(atIndex photoIndex: Int) {
        reloadFeedIfNeeded(lastPhotoIndexSeen: photoIndex)
    }
}

