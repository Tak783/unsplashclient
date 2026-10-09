//
//  RemoteUnsplashSearchPhotosResponseModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

struct RemoteUnsplashSearchPhotosResponseModel: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [RemoteUnsplashPhotoModel]?
}
