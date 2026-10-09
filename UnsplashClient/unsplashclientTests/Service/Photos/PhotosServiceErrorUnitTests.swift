//
//  PhotosServiceErrorUnitTests.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Testing
@testable import UnsplashClient

@Suite
struct PhotosServiceErrorUnitTests {}

// MARK: - PhotosServiceErrorUnitTestsSpec
extension PhotosServiceErrorUnitTests: PhotosServiceErrorUnitTestsSpec {
    @Test("401 maps to unauthorized")
    func test_init_mapsUnauthorizedStatusCode() {
        #expect(PhotosServiceError(statusCode: 401) == .unauthorized)
    }

    @Test(
        "403 and 429 both map to rate limit exceeded",
        arguments: [403, 429]
    )
    func test_init_mapsRateLimitStatusCodes(statusCode: Int) {
        #expect(PhotosServiceError(statusCode: statusCode) == .rateLimitExceeded)
    }

    @Test(
        "5xx status codes map to server failure",
        arguments: [500, 503, 599]
    )
    func test_init_mapsServerStatusCodes(statusCode: Int) {
        #expect(PhotosServiceError(statusCode: statusCode) == .serverFailure)
    }

    @Test(
        "an unrecognised status code is kept so it can be shown",
        arguments: [301, 418, 600]
    )
    func test_init_mapsUnrecognisedStatusCodeAndKeepsIt(statusCode: Int) {
        #expect(PhotosServiceError(statusCode: statusCode) == .unexpectedStatusCode(statusCode))
    }

    @Test("invalidData satisfies the DataDecodingError requirement")
    func test_invalidData_isAvailableAsDataDecodingError() {
        #expect(PhotosServiceError.invalidData == .invalidData)
    }
}

// MARK: - Spec Conformance Without Arguments
extension PhotosServiceErrorUnitTests {
    func test_init_mapsRateLimitStatusCodes() {
        test_init_mapsRateLimitStatusCodes(statusCode: 403)
    }

    func test_init_mapsServerStatusCodes() {
        test_init_mapsServerStatusCodes(statusCode: 500)
    }

    func test_init_mapsUnrecognisedStatusCodeAndKeepsIt() {
        test_init_mapsUnrecognisedStatusCodeAndKeepsIt(statusCode: 418)
    }
}
