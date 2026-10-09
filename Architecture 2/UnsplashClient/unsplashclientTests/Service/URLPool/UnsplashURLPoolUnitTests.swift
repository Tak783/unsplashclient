//
//  UnsplashURLPoolUnitTests.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Foundation
import Testing
@testable import UnsplashClient

@Suite
struct UnsplashURLPoolUnitTests {
    let expectedScheme = "https"
    let expectedHost = "api.unsplash.com"
    let anyAccessKey = "ANY-ACCESS-KEY"

    @Test("photosFeedRequest builds the photos URL with paging query items")
    func test_photosFeedRequest_configuresURLCorrectly() throws {
        let sut = try UnsplashURLPool.photosFeedRequest(
            pageNumber: 2,
            photosPerPage: 30,
            accessKey: anyAccessKey
        )

        let components = try #require(urlComponents(of: sut))

        #expect(components.scheme == expectedScheme)
        #expect(components.host == expectedHost)
        #expect(components.path == "/photos")
        #expect(queryItemValue(named: "page", in: components) == "2")
        #expect(queryItemValue(named: "per_page", in: components) == "30")
        #expect(sut.httpMethod == URLRequest.HTTPMethod.get.rawValue)
    }

    @Test("photosFeedRequest attaches the Client-ID authorization and API version")
    func test_photosFeedRequest_attachesAuthorizationAndVersionHeaders() throws {
        let sut = try UnsplashURLPool.photosFeedRequest(
            pageNumber: 1,
            photosPerPage: 10,
            accessKey: anyAccessKey
        )

        let headerFields = try #require(sut.allHTTPHeaderFields)

        #expect(headerFields[HTTPHeaderFieldName.authorization.rawValue] == "Client-ID \(anyAccessKey)")
        #expect(headerFields[HTTPHeaderFieldName.acceptVersion.rawValue] == "v1")
    }

    @Test("searchPhotosRequest builds the search URL with the query and paging")
    func test_searchPhotosRequest_configuresURLCorrectly() throws {
        let sut = try UnsplashURLPool.searchPhotosRequest(
            query: "tigers",
            pageNumber: 3,
            photosPerPage: 20,
            accessKey: anyAccessKey
        )

        let components = try #require(urlComponents(of: sut))

        #expect(components.path == "/search/photos")
        #expect(queryItemValue(named: "query", in: components) == "tigers")
        #expect(queryItemValue(named: "page", in: components) == "3")
        #expect(queryItemValue(named: "per_page", in: components) == "20")
    }

    @Test("searchPhotosRequest percent encodes a query containing spaces")
    func test_searchPhotosRequest_percentEncodesQueryWithSpaces() throws {
        let sut = try UnsplashURLPool.searchPhotosRequest(
            query: "red fox",
            pageNumber: 1,
            photosPerPage: 10,
            accessKey: anyAccessKey
        )

        let absoluteString = try #require(sut.url?.absoluteString)
        let components = try #require(urlComponents(of: sut))

        #expect(absoluteString.contains("query=red%20fox"))
        #expect(queryItemValue(named: "query", in: components) == "red fox")
    }
}

// MARK: - Helpers
extension UnsplashURLPoolUnitTests {
    private func urlComponents(of urlRequest: URLRequest) -> URLComponents? {
        guard let url = urlRequest.url else { return nil }
        return URLComponents(url: url, resolvingAgainstBaseURL: false)
    }

    private func queryItemValue(
        named name: String,
        in components: URLComponents
    ) -> String? {
        components.queryItems?.first { $0.name == name }?.value
    }
}
