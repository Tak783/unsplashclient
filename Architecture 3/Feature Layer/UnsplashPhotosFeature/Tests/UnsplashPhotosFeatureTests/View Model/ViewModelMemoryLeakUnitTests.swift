//
//  ViewModelMemoryLeakUnitTests.swift
//  UnsplashPhotosFeatureTests
//
//  Created on 09/10/2026.
//

import CoreTestSupport
import Foundation
import Testing
@testable import UnsplashPhotosFeature

@Suite
@MainActor
struct ViewModelMemoryLeakUnitTests {}

// MARK: - ViewModelMemoryLeakUnitTestsSpec
extension ViewModelMemoryLeakUnitTests: ViewModelMemoryLeakUnitTestsSpec {
    @Test("the feed view model is released after it has loaded a page")
    func test_photosFeedViewModel_isReleasedAfterLoadingAPage() async throws {
        try await expectNoMemoryLeak {
            let viewModel = PhotosFeedViewModel(
                photosService: PhotosServiceStub(photosToReturn: anyPhotos()),
                gridLayoutModel: .init(),
                paginationModel: .init()
            )

            await viewModel.loadFirstPageIfNeeded()
            #expect(viewModel.photos.count == 2)

            return viewModel
        }
    }

    @Test("the search view model is released after it has run a search")
    func test_photoSearchViewModel_isReleasedAfterASearch() async throws {
        try await expectNoMemoryLeak {
            let viewModel = PhotoSearchViewModel(
                photosService: PhotosServiceStub(photosToReturn: anyPhotos()),
                gridLayoutModel: .init(),
                paginationModel: .init()
            )

            viewModel.searchQuery = "tigers"
            try? await Task.sleep(for: .seconds(1))
            #expect(viewModel.photos.count == 2)

            return viewModel
        }
    }

    @Test("the detail view model is released once it is no longer referenced")
    func test_photoDetailViewModel_isReleasedAfterBeingBuilt() throws {
        try expectNoMemoryLeak {
            PhotoDetailViewModel(photo: anyPhoto(id: "one"))
        }
    }
}

// MARK: - Factory
extension ViewModelMemoryLeakUnitTests {
    private func anyPhotos() -> [UnsplashPhotoModel] {
        [anyPhoto(id: "one"), anyPhoto(id: "two")]
    }

    private func anyPhoto(id: String) -> UnsplashPhotoModel {
        UnsplashPhotoModel(
            id: id,
            description: nil,
            altDescription: nil,
            blurHash: "ANY-BLUR-HASH",
            urls: UnsplashPhotoImageURLsModel(
                full: URL(string: "https://images.unsplash.com/full"),
                regular: URL(string: "https://images.unsplash.com/regular"),
                small: URL(string: "https://images.unsplash.com/small")
            )
        )
    }
}
