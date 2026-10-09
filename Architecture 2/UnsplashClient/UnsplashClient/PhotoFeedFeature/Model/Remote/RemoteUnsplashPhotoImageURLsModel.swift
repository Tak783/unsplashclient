//
//  RemoteUnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

nonisolated struct RemoteUnsplashPhotoImageURLsModel: Decodable {
    let full: URL?
    let regular: URL?
    let small: URL?
}

// MARK: - To Local Model Helpers
nonisolated extension RemoteUnsplashPhotoImageURLsModel {
    func toLocalModel() -> UnsplashPhotoImageURLsModel {
        UnsplashPhotoImageURLsModel(
            full: full,
            regular: regular,
            small: small
        )
    }
}
