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
    private let photosService: PhotosService

    private(set) var isLoadingNextPage = false
    private(set) var errorMessage: String?
    private(set) var photos: [UnsplashPhotoModel] = []

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
            errorMessage = Self.userFacingMessage(for: error)
            isShowingErrorAlert = true
        }
    }

    private func reloadFeedIfNeeded(lastPhotoIndexSeen: Int) {
        let indexThatTriggersNextPage = photos.count - paginationModel.itemsFromEndThatTriggerNextPage
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
    }
}

// MARK: - View Events
extension PhotosFeedViewModel {
    func photoDidAppear(atIndex photoIndex: Int) {
        reloadFeedIfNeeded(lastPhotoIndexSeen: photoIndex)
    }
}

// MARK: - Error Helpers
extension PhotosFeedViewModel {
    private static func userFacingMessage(for error: Error) -> String {
        guard let photosServiceError = error as? PhotosServiceError else {
            return "Something went wrong. Please try again."
        }
        switch photosServiceError {
        case .rateLimitExceeded:
            return "Unsplash rate limit reached. Try again in a little while."
        case .unauthorized:
            return "The Unsplash access key was rejected."
        case .serverFailure:
            return "Unsplash is having trouble. Please try again."
        case .invalidData:
            return "That response could not be read."
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected response from Unsplash (\(statusCode))."
        }
    }
}
