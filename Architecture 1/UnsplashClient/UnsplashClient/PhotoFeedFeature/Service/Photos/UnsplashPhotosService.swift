//
//  UnsplashPhotosService.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

nonisolated struct UnsplashPhotosService: Sendable {
    private let httpClient: HTTPClient
    private let apiKeyProvider: APIKeyProviding

    init(httpClient: HTTPClient, apiKeyProvider: APIKeyProviding) {
        self.httpClient = httpClient
        self.apiKeyProvider = apiKeyProvider
    }
}

// MARK: - PhotosService
nonisolated extension UnsplashPhotosService: PhotosService {
    func loadPhotos(pageNumber: Int, photosPerPage: Int) async throws -> [UnsplashPhotoModel] {
        let urlRequest = try UnsplashURLPool.photosFeedRequest(
            pageNumber: pageNumber,
            photosPerPage: photosPerPage,
            accessKey: apiKeyProvider.accessKey
        )

        let (responseData, httpResponse) = try await httpClient.performRequest(urlRequest)
        try httpResponse.validateStatusCode(throwing: PhotosServiceError.self)

        return try responseData.decodeJSON(
            as: [UnsplashPhotoModel].self,
            throwing: PhotosServiceError.self
        )
    }

    func searchPhotos(
        query: String,
        pageNumber: Int,
        photosPerPage: Int
    ) async throws -> [UnsplashPhotoModel] {
        let urlRequest = try UnsplashURLPool.searchPhotosRequest(
            query: query,
            pageNumber: pageNumber,
            photosPerPage: photosPerPage,
            accessKey: apiKeyProvider.accessKey
        )

        let (responseData, httpResponse) = try await httpClient.performRequest(urlRequest)
        try httpResponse.validateStatusCode(throwing: PhotosServiceError.self)

        let searchResponse: UnsplashSearchPhotosResponseModel = try responseData.decodeJSON(
            throwing: PhotosServiceError.self
        )
        return searchResponse.results ?? []
    }
}
