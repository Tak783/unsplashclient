//
//  UnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

nonisolated struct UnsplashPhotoImageURLsModel: Sendable, Equatable {
    let full: URL?
    let regular: URL?
    let small: URL?
}
