//
//  HTTPClient.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

nonisolated protocol HTTPClient: Sendable {
    func performRequest(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse)
}
