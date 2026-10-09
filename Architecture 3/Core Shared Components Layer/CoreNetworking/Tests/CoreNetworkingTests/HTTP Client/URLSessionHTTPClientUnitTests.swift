//
//  URLSessionHTTPClientUnitTests.swift
//  CoreNetworkingTests
//
//  Created on 09/10/2026.
//

@testable import CoreNetworking
import CoreTesting
import Foundation
import Testing

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
