//
//  PhotosServiceErrorUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol PhotosServiceErrorUnitTestsSpec {
    func test_init_mapsUnauthorizedStatusCode()
    func test_init_mapsRateLimitStatusCodes()
    func test_init_mapsServerStatusCodes()
    func test_init_mapsUnrecognisedStatusCodeAndKeepsIt()
    func test_invalidData_isAvailableAsDataDecodingError()
}
