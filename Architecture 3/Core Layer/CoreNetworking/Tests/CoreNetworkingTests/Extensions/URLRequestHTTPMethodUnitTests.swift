//
//  URLRequestHTTPMethodUnitTests.swift
//  CoreNetworkingTests
//
//  Created on 09/10/2026.
//

import Foundation
import Testing
@testable import CoreNetworking

@Suite
struct URLRequestHTTPMethodUnitTests {
    let anyURL = URL(string: "https://api.unsplash.com/photos")!
}

// MARK: - URLRequestHTTPMethodUnitTestsSpec
extension URLRequestHTTPMethodUnitTests: URLRequestHTTPMethodUnitTestsSpec {
    @Test("HTTPMethod raw values are uppercased")
    func test_httpMethodRawValues_areUppercased() {
        #expect(URLRequest.HTTPMethod.get.rawValue == "GET")
    }

    @Test("the convenience initialiser sets both the method and the URL")
    func test_initWithMethod_setsHTTPMethodAndURL() throws {
        let sut = URLRequest(method: .get, url: anyURL)

        #expect(sut.httpMethod == URLRequest.HTTPMethod.get.rawValue)
        #expect(sut.url == anyURL)
    }

    @Test("setValue for a header field name writes the header under its raw value")
    func test_setValueForHeaderFieldName_setsTheNamedHeader() throws {
        var sut = URLRequest(method: .get, url: anyURL)

        sut.setValue("ANY-VALUE", for: .authorization)

        let headerFields = try #require(sut.allHTTPHeaderFields)
        #expect(headerFields["Authorization"] == "ANY-VALUE")
    }
}
