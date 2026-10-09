//
//  UnsplashURLPoolUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol UnsplashURLPoolUnitTestsSpec {
    func test_photosFeedRequest_configuresURLCorrectly() throws
    func test_photosFeedRequest_attachesAuthorizationAndVersionHeaders() throws
    func test_searchPhotosRequest_configuresURLCorrectly() throws
    func test_searchPhotosRequest_percentEncodesQueryWithSpaces() throws
}
