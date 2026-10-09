//
//  PhotosServiceErrorUnitTestsSpec.swift
//  UnsplashPhotosFeature
//
//  Created on 09/10/2026.
//

protocol PhotosServiceErrorUnitTestsSpec {
    func test_init_mapsUnauthorizedStatusCode()
    func test_init_mapsRateLimitStatusCodes(statusCode: Int)
    func test_init_mapsServerStatusCodes(statusCode: Int)
    func test_init_mapsUnrecognisedStatusCodeAndKeepsIt(statusCode: Int)
    func test_invalidData_isAvailableAsDataDecodingError()
}
