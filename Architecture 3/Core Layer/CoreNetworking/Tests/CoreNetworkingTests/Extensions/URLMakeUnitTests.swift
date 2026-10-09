//
//  URLMakeUnitTests.swift
//  CoreNetworkingTests
//
//  Created on 09/10/2026.
//

import Foundation
import Testing
@testable import CoreNetworking

@Suite
struct URLMakeUnitTests {
    let anyHost = "api.unsplash.com"
}

// MARK: - URLMakeUnitTestsSpec
extension URLMakeUnitTests: URLMakeUnitTestsSpec {
    @Test("a URL is built from the scheme, host and path")
    func test_make_buildsURLFromSchemeHostAndPath() throws {
        let sut = try #require(
            URL.make(scheme: .https, host: anyHost, path: "/photos")
        )

        #expect(sut.absoluteString == "https://api.unsplash.com/photos")
    }

    @Test("query items are appended in the order given")
    func test_make_appendsQueryItemsInOrder() throws {
        let sut = try #require(
            URL.make(
                scheme: .https,
                host: anyHost,
                path: "/photos",
                queryItems: [
                    URLQueryItem(name: "page", value: "2"),
                    URLQueryItem(name: "per_page", value: "30")
                ]
            )
        )

        #expect(sut.absoluteString == "https://api.unsplash.com/photos?page=2&per_page=30")
    }

    @Test("a query value containing a space is percent encoded")
    func test_make_percentEncodesQueryItemValues() throws {
        let sut = try #require(
            URL.make(
                scheme: .https,
                host: anyHost,
                path: "/search/photos",
                queryItems: [URLQueryItem(name: "query", value: "red fox")]
            )
        )

        #expect(sut.absoluteString.contains("query=red%20fox"))
    }

    @Test("no query items means no question mark in the URL")
    func test_make_omitsTheQueryStringWhenNoItemsAreGiven() throws {
        let sut = try #require(
            URL.make(scheme: .https, host: anyHost, path: "/photos")
        )

        #expect(sut.query == nil)
        #expect(!sut.absoluteString.contains("?"))
    }

    @Test("URLScheme raw values match their case names")
    func test_urlScheme_rawValuesMatchTheirNames() {
        #expect(URLScheme.https.rawValue == "https")
        #expect(URLScheme.http.rawValue == "http")
    }
}
