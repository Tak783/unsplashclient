//
//  UnsplashPhotoModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

nonisolated struct UnsplashPhotoModel: Decodable, Sendable, Equatable {
    let id: String
    let description: String?
    let altDescription: String?
    let blurHash: String?
    let urls: UnsplashPhotoImageURLsModel?
}
