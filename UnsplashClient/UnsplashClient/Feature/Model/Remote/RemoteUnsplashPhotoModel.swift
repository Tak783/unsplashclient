//
//  RemoteUnsplashPhotoModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

nonisolated struct RemoteUnsplashPhotoModel: Decodable {
    let id: String
    let description: String?
    let altDescription: String?
    let blurHash: String?
    let urls: RemoteUnsplashPhotoImageURLsModel?
}

// MARK: - To Local Model Helpers
nonisolated extension RemoteUnsplashPhotoModel {
    func toLocalModel() -> UnsplashPhotoModel {
        UnsplashPhotoModel(
            id: id,
            description: description,
            altDescription: altDescription,
            blurHash: blurHash,
            urls: urls?.toLocalModel()
        )
    }
}

// MARK: - To Local Model Array Helpers
nonisolated extension Array where Element == RemoteUnsplashPhotoModel {
    func toLocalModels() -> [UnsplashPhotoModel] {
        map { $0.toLocalModel() }
    }
}
