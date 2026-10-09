//
//  RemoteUnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import CoreNetworking
import Foundation

public nonisolated struct RemoteUnsplashPhotoImageURLsModel: Decodable {
    public let full: URL?
    public let regular: URL?
    public let small: URL?
}

// MARK: - To Local Model Helpers
public nonisolated extension RemoteUnsplashPhotoImageURLsModel {
    func toLocalModel() -> UnsplashPhotoImageURLsModel {
        UnsplashPhotoImageURLsModel(
            full: full,
            regular: regular,
            small: small
        )
    }
}
