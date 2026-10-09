//
//  RemoteUnsplashPhotoModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation
import CoreNetworking

public nonisolated struct RemoteUnsplashPhotoModel: Decodable {
    public let id: String
    public let description: String?
    public let altDescription: String?
    public let blurHash: String?
    public let urls: RemoteUnsplashPhotoImageURLsModel?
}

// MARK: - To Local Model Helpers
public nonisolated extension RemoteUnsplashPhotoModel {
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
public nonisolated extension Array where Element == RemoteUnsplashPhotoModel {
    func toLocalModels() -> [UnsplashPhotoModel] {
        map { $0.toLocalModel() }
    }
}
