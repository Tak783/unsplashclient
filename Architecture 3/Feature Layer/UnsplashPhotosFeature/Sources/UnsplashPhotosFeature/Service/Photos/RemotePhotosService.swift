//
//  RemotePhotosService.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreNetworking
import Foundation

public nonisolated struct RemotePhotosService: Sendable {
    private let httpClient: HTTPClient
    private let apiKeyProvider: APIKeyProviding

    public init(httpClient: HTTPClient, apiKeyProvider: APIKeyProviding) {
        self.httpClient = httpClient
        self.apiKeyProvider = apiKeyProvider
    }
}

// MARK: - PhotosService
nonisolated extension RemotePhotosService: PhotosService {
    public func loadPhotos(pageNumber: Int, photosPerPage: Int) async throws -> [UnsplashPhotoModel] {
        let urlRequest = try UnsplashURLPool.photosFeedRequest(
            pageNumber: pageNumber,
            photosPerPage: photosPerPage,
            accessKey: apiKeyProvider.accessKey
        )

        let (responseData, httpResponse) = try await httpClient.performRequest(urlRequest)
        try httpResponse.validateStatusCode(throwing: PhotosServiceError.self)

        let remotePhotos: [RemoteUnsplashPhotoModel] = try responseData.decodeJSON(
            throwing: PhotosServiceError.self
        )
        return remotePhotos.toLocalModels()
    }

    public func searchPhotos(
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

        let searchResponse: RemoteUnsplashSearchPhotosResponseModel = try responseData.decodeJSON(
            throwing: PhotosServiceError.self
        )
        return (searchResponse.results ?? []).toLocalModels()
    }
}
