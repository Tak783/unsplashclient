//
//  UnsplashPhotoModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

struct UnsplashPhotoModel: Sendable, Equatable {
    let id: String
    let description: String?
    let altDescription: String?
    let blurHash: String?
    let urls: UnsplashPhotoImageURLsModel?
}
