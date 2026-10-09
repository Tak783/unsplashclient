//
//  RemotePhotosService.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

struct RemotePhotosService: Sendable {
    private let httpClient: HTTPClient
    private let apiKeyProvider: APIKeyProviding

    init(httpClient: HTTPClient, apiKeyProvider: APIKeyProviding) {
        self.httpClient = httpClient
        self.apiKeyProvider = apiKeyProvider
    }
}

// MARK: - PhotosService
extension RemotePhotosService: PhotosService {
    func loadPhotos(pageNumber: Int, photosPerPage: Int) async throws -> [UnsplashPhotoModel] {
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
}
