//
//  HTTPHeaderFieldNameUnitTests.swift
//  CoreNetworkingTests
//
//  Created on 09/10/2026.
//

import Testing
@testable import CoreNetworking

@Suite
struct HTTPHeaderFieldNameUnitTests {}

// MARK: - HTTPHeaderFieldNameUnitTestsSpec
extension HTTPHeaderFieldNameUnitTests: HTTPHeaderFieldNameUnitTestsSpec {
    @Test("header field raw values match the exact HTTP spelling")
    func test_rawValues_matchTheHTTPHeaderSpelling() {
        #expect(HTTPHeaderFieldName.authorization.rawValue == "Authorization")
        #expect(HTTPHeaderFieldName.acceptVersion.rawValue == "Accept-Version")
    }
}
