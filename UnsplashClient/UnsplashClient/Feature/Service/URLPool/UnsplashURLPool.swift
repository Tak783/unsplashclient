//
//  UnsplashURLPool.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

enum UnsplashURLPool {}

// MARK: - URL Components
extension UnsplashURLPool {
    private static let scheme = URLScheme.https
    private static let host = "api.unsplash.com"
    private static let apiVersion = "v1"

    private enum Endpoint: String {
        case photos = "/photos"
        case searchPhotos = "/search/photos"
    }
}

// MARK: - Requests
extension UnsplashURLPool: UnsplashAPIURLPoolable {
    static func photosFeedRequest(
        pageNumber: Int,
        photosPerPage: Int,
        accessKey: String
    ) throws -> URLRequest {
        guard let url = URL.make(
            scheme: scheme,
            host: host,
            path: Endpoint.photos.rawValue,
            queryItems: [
                URLQueryItem(name: "page", value: String(pageNumber)),
                URLQueryItem(name: "per_page", value: String(photosPerPage))
            ]
        ) else {
            throw URLPoolError.couldNotBuildURL
        }

        return authenticatedGetRequest(url: url, accessKey: accessKey)
    }

    static func searchPhotosRequest(
        query: String,
        pageNumber: Int,
        photosPerPage: Int,
        accessKey: String
    ) throws -> URLRequest {
        guard let url = URL.make(
            scheme: scheme,
            host: host,
            path: Endpoint.searchPhotos.rawValue,
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(pageNumber)),
                URLQueryItem(name: "per_page", value: String(photosPerPage))
            ]
        ) else {
            throw URLPoolError.couldNotBuildURL
        }

        return authenticatedGetRequest(url: url, accessKey: accessKey)
    }
}

// MARK: - Authenticated Requests
extension UnsplashURLPool {
    private static func authenticatedGetRequest(
        url: URL,
        accessKey: String
    ) -> URLRequest {
        var urlRequest = URLRequest(method: .get, url: url)
        urlRequest.setValue("Client-ID \(accessKey)", for: .authorization)
        urlRequest.setValue(apiVersion, for: .acceptVersion)
        return urlRequest
    }
}
