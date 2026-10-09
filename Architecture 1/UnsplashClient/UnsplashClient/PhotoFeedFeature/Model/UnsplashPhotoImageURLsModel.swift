//
//  UnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

nonisolated struct UnsplashPhotoImageURLsModel: Decodable, Sendable, Equatable {
    let full: URL?
    let regular: URL?
    let small: URL?
}
