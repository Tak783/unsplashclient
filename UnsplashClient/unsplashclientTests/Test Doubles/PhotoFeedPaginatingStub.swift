//
//  PhotoFeedPaginatingStub.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Foundation
@testable import UnsplashClient

@MainActor
final class PhotoFeedPaginatingStub: PhotoFeedPaginating {
    let gridLayoutModel: GridLayoutModel
    let paginationModel: PaginationModel

    var isShowingErrorAlert = false
    var photos = [UnsplashPhotoModel]()
    var photoCellPresentationModels = [PhotoFeedCellPresentationModel]()
    var alreadySeenPhotoIDs = Set<String>()
    var nextPageNumber = 1
    var hasMorePagesToLoad = true
    var photoIDThatTriggersNextPage: String?
    var isLoadingNextPage = false
    var errorMessage: String?

    var photosToReturn = [UnsplashPhotoModel]()
    var errorToThrow: Error?
    private(set) var pageNumbersRequested = [Int]()

    init(
        gridLayoutModel: GridLayoutModel = .init(),
        paginationModel: PaginationModel = .init()
    ) {
        self.gridLayoutModel = gridLayoutModel
        self.paginationModel = paginationModel
    }

    func loadPhotos(forPageNumber pageNumber: Int) async throws -> [UnsplashPhotoModel] {
        pageNumbersRequested.append(pageNumber)
        if let errorToThrow {
            throw errorToThrow
        }
        return photosToReturn
    }
}
