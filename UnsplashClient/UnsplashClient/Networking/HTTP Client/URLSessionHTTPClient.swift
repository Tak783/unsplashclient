//
//  URLSessionHTTPClient.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

final class URLSessionHTTPClient: Sendable {
    private let urlSession: URLSession

    enum HTTPClientError: Error, Equatable {
        case unexpectedResponseType
    }

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
}

// MARK: - HTTPClient
extension URLSessionHTTPClient: HTTPClient {
    func performRequest(_ urlRequest: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let (responseData, urlResponse) = try await urlSession.data(for: urlRequest)
        guard let httpResponse = urlResponse as? HTTPURLResponse else {
            throw HTTPClientError.unexpectedResponseType
        }
        return (responseData, httpResponse)
    }
}
