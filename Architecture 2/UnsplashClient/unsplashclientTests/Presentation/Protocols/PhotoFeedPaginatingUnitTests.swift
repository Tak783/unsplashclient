//
//  PhotoFeedPaginatingUnitTests.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Foundation
import Testing
@testable import UnsplashClient

@Suite
@MainActor
struct PhotoFeedPaginatingUnitTests {
    @Test("appending adds to both the photo array and the presentation models")
    func test_appendPhotosNotSeenBefore_appendsToBothPhotosAndPresentationModels() {
        let sut = PhotoFeedPaginatingStub()

        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one"), anyPhoto(id: "two")])

        #expect(sut.photos.count == 2)
        #expect(sut.photoCellPresentationModels.count == 2)
        #expect(sut.photoCellPresentationModels.map(\.id) == ["one", "two"])
        #expect(sut.alreadySeenPhotoIDs == ["one", "two"])
    }

    @Test("a photo already seen is skipped, because Unsplash repeats photos across pages")
    func test_appendPhotosNotSeenBefore_skipsPhotosAlreadySeen() {
        let sut = PhotoFeedPaginatingStub()
        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one")])

        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one"), anyPhoto(id: "two")])

        #expect(sut.photos.map(\.id) == ["one", "two"])
        #expect(sut.photoCellPresentationModels.count == 2)
    }

    @Test("appending only duplicates leaves everything untouched")
    func test_appendPhotosNotSeenBefore_doesNothingWhenEveryPhotoIsADuplicate() {
        let sut = PhotoFeedPaginatingStub()
        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one")])

        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one")])

        #expect(sut.photos.count == 1)
        #expect(sut.photoCellPresentationModels.count == 1)
    }

    @Test("resetting clears the photos, the seen ids, the page number and the error")
    func test_resetPaging_clearsEveryPieceOfPagingState() {
        let sut = PhotoFeedPaginatingStub()
        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one")])
        sut.nextPageNumber = 5
        sut.hasMorePagesToLoad = false
        sut.errorMessage = "Something went wrong"

        sut.resetPaging()

        #expect(sut.photos.isEmpty)
        #expect(sut.photoCellPresentationModels.isEmpty)
        #expect(sut.alreadySeenPhotoIDs.isEmpty)
        #expect(sut.nextPageNumber == 1)
        #expect(sut.hasMorePagesToLoad)
        #expect(sut.errorMessage == nil)
    }

    @Test("dismissing the error clears the message")
    func test_dismissErrorMessage_clearsTheMessage() {
        let sut = PhotoFeedPaginatingStub()
        sut.errorMessage = "Something went wrong"

        sut.dismissErrorMessage()

        #expect(sut.errorMessage == nil)
    }

    @Test("looking up a photo by id returns the matching photo")
    func test_photoWithID_returnsTheMatchingPhoto() {
        let sut = PhotoFeedPaginatingStub()
        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one"), anyPhoto(id: "two")])

        #expect(sut.photo(withID: "two")?.id == "two")
    }

    @Test("looking up an unknown id returns nil")
    func test_photoWithID_returnsNilWhenNoPhotoMatches() {
        let sut = PhotoFeedPaginatingStub()
        sut.appendPhotosNotSeenBefore([anyPhoto(id: "one")])

        #expect(sut.photo(withID: "missing") == nil)
    }

    @Test("the presentation model carries the id, blur hash and small image url")
    func test_makePresentationModel_mapsIDBlurHashAndSmallImageURL() {
        let photo = anyPhoto(id: "one", altDescription: "An alt description")

        let sut = PhotoFeedPaginatingStub.makePresentationModel(for: photo)

        #expect(sut.id == "one")
        #expect(sut.blurHash == "ANY-BLUR-HASH")
        #expect(sut.imageURL?.absoluteString == "https://images.unsplash.com/small")
        #expect(sut.caption == "An alt description")
    }

    @Test("with no alt description the caption falls back to the description")
    func test_makePresentationModel_fallsBackFromAltDescriptionToDescription() {
        let photo = anyPhoto(
            id: "one",
            description: "A description",
            altDescription: nil
        )

        let sut = PhotoFeedPaginatingStub.makePresentationModel(for: photo)

        #expect(sut.caption == "A description")
    }

    @Test("with neither description the caption falls back to the placeholder")
    func test_makePresentationModel_fallsBackToThePlaceholderWhenBothAreMissing() {
        let photo = anyPhoto(id: "one", description: nil, altDescription: nil)

        let sut = PhotoFeedPaginatingStub.makePresentationModel(for: photo)

        #expect(sut.caption == "Untitled photo")
    }
}

// MARK: - Factory
extension PhotoFeedPaginatingUnitTests {
    private func anyPhoto(
        id: String,
        description: String? = nil,
        altDescription: String? = nil
    ) -> UnsplashPhotoModel {
        UnsplashPhotoModel(
            id: id,
            description: description,
            altDescription: altDescription,
            blurHash: "ANY-BLUR-HASH",
            urls: UnsplashPhotoImageURLsModel(
                full: URL(string: "https://images.unsplash.com/full"),
                regular: URL(string: "https://images.unsplash.com/regular"),
                small: URL(string: "https://images.unsplash.com/small")
            )
        )
    }
}
