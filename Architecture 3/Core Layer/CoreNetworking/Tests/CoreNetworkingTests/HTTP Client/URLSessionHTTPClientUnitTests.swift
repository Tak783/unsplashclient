//
//  URLSessionHTTPClientUnitTests.swift
//  CoreNetworkingTests
//
//  Created on 09/10/2026.
//

import CoreTestSupport
import Foundation
import Testing
@testable import CoreNetworking

@Suite
struct URLSessionHTTPClientUnitTests {}

// MARK: - URLSessionHTTPClientUnitTestsSpec
extension URLSessionHTTPClientUnitTests: URLSessionHTTPClientUnitTestsSpec {
    @Test("the client is released once the last reference to it goes away")
    func test_init_doesNotLeakTheClient() throws {
        try expectNoMemoryLeak {
            URLSessionHTTPClient(urlSession: .shared)
        }
    }
}
