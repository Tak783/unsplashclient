//
//  UnsplashSearchPhotosResponseModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

nonisolated struct UnsplashSearchPhotosResponseModel: Decodable {
    let total: Int?
    let totalPages: Int?
    let results: [UnsplashPhotoModel]?
}
