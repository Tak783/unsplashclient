//
//  RemoteUnsplashSearchPhotosResponseModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreNetworking
public nonisolated struct RemoteUnsplashSearchPhotosResponseModel: Decodable {
    public let total: Int?
    public let totalPages: Int?
    public let results: [RemoteUnsplashPhotoModel]?
}
