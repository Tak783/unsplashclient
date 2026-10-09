//
//  URLSessionHTTPClientUnitTestsSpec.swift
//  CoreNetworking
//
//  Created on 09/10/2026.
//

protocol URLSessionHTTPClientUnitTestsSpec {
    func test_init_doesNotLeakTheClient() throws
}
