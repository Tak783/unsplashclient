//
//  RemoteUnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

struct RemoteUnsplashPhotoImageURLsModel: Decodable {
    let full: URL?
    let regular: URL?
    let small: URL?
}

// MARK: - To Local Model Helpers
extension RemoteUnsplashPhotoImageURLsModel {
    func toLocalModel() -> UnsplashPhotoImageURLsModel {
        UnsplashPhotoImageURLsModel(
            full: full,
            regular: regular,
            small: small
        )
    }
}
