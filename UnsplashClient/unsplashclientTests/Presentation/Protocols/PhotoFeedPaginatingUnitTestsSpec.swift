//
//  PhotoFeedPaginatingUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol PhotoFeedPaginatingUnitTestsSpec {
    func test_appendPhotosNotSeenBefore_appendsToBothPhotosAndPresentationModels()
    func test_appendPhotosNotSeenBefore_skipsPhotosAlreadySeen()
    func test_appendPhotosNotSeenBefore_doesNothingWhenEveryPhotoIsADuplicate()
    func test_resetPaging_clearsEveryPieceOfPagingState()
    func test_dismissErrorMessage_clearsTheMessage()
    func test_photoWithID_returnsTheMatchingPhoto()
    func test_photoWithID_returnsNilWhenNoPhotoMatches()
    func test_makePresentationModel_mapsIDBlurHashAndSmallImageURL()
    func test_makePresentationModel_fallsBackFromAltDescriptionToDescription()
    func test_makePresentationModel_fallsBackToThePlaceholderWhenBothAreMissing()
}
