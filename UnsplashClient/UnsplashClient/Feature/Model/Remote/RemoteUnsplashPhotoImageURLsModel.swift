//
//  RemoteUnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

struct RemoteUnsplashPhotoImageURLsModel: Decodable {
    let regular: URL?
    let small: URL?
    let thumb: URL?
}

// MARK: - To Local Model Helpers
extension RemoteUnsplashPhotoImageURLsModel {
    func toLocalModel() -> UnsplashPhotoImageURLsModel {
        UnsplashPhotoImageURLsModel(
            regular: regular,
            small: small,
            thumb: thumb
        )
    }
}
