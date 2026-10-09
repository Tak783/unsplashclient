//
//  HTTPClient.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

protocol HTTPClient: Sendable {
    func performRequest(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse)
}
