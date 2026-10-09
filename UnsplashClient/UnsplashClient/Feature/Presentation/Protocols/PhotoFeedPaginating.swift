//
//  PhotoFeedPaginating.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

@MainActor
protocol PhotoFeedPaginating: PhotoFeedPresenting {
    var paginationModel: PaginationModel { get }

    var photos: [UnsplashPhotoModel] { get set }
    var photoCellPresentationModels: [PhotoFeedCellPresentationModel] { get set }
    var alreadySeenPhotoIDs: Set<String> { get set }
    var nextPageNumber: Int { get set }
    var hasMorePagesToLoad: Bool { get set }
    var photoIDThatTriggersNextPage: String? { get set }
    var isLoadingNextPage: Bool { get set }
    var errorMessage: String? { get set }

    func loadPhotos(forPageNumber pageNumber: Int) async throws -> [UnsplashPhotoModel]
}

// MARK: - Paging
extension PhotoFeedPaginating {
    func loadNextPage() async {
        guard !isLoadingNextPage, hasMorePagesToLoad, errorMessage == nil else {
            return
        }

        isLoadingNextPage = true
        defer {
            isLoadingNextPage = false
        }

        do {
            let loadedPhotos = try await loadPhotos(forPageNumber: nextPageNumber)
            hasMorePagesToLoad = !loadedPhotos.isEmpty
            nextPageNumber += 1
            appendPhotosNotSeenBefore(loadedPhotos)
        } catch {
            guard !CancellationCheck.isCancellation(error) else { return }
            errorMessage = PhotosServiceErrorMessage.userFacingMessage(for: error)
            isShowingErrorAlert = true
        }
    }

    func appendPhotosNotSeenBefore(_ loadedPhotos: [UnsplashPhotoModel]) {
        let photosNotSeenBefore = loadedPhotos.filter {
            alreadySeenPhotoIDs.insert($0.id).inserted
        }
        guard !photosNotSeenBefore.isEmpty else { return }

        photos.append(contentsOf: photosNotSeenBefore)
        photoCellPresentationModels.append(
            contentsOf: photosNotSeenBefore.map { Self.makePresentationModel(for: $0) }
        )
        updatePhotoIDThatTriggersNextPage()
    }

    func updatePhotoIDThatTriggersNextPage() {
        let triggerIndex =
            photoCellPresentationModels.count - paginationModel.itemsFromEndThatTriggerNextPage

        photoIDThatTriggersNextPage = photoCellPresentationModels.indices.contains(triggerIndex)
            ? photoCellPresentationModels[triggerIndex].id
            : photoCellPresentationModels.first?.id
    }

    func resetPaging() {
        nextPageNumber = 1
        hasMorePagesToLoad = true
        alreadySeenPhotoIDs.removeAll()
        photos.removeAll()
        photoCellPresentationModels.removeAll()
        photoIDThatTriggersNextPage = nil
        errorMessage = nil
    }
}

// MARK: - View Events
extension PhotoFeedPaginating {
    func photoDidAppear(withID photoID: String) {
        guard photoID == photoIDThatTriggersNextPage else { return }

        Task {
            await loadNextPage()
        }
    }

    func retryLoadingNextPage() async {
        errorMessage = nil
        await loadNextPage()
    }

    func dismissErrorMessage() {
        errorMessage = nil
    }
}

// MARK: - Photo Lookup
extension PhotoFeedPaginating {
    func photo(withID photoID: String) -> UnsplashPhotoModel? {
        photos.first { $0.id == photoID }
    }
}

// MARK: - Presentation Model Factory
extension PhotoFeedPaginating {
    nonisolated static func makePresentationModel(
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
