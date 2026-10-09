//
//  RemoteUnsplashSearchPhotosResponseModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

nonisolated struct RemoteUnsplashSearchPhotosResponseModel: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [RemoteUnsplashPhotoModel]?
}
