//
//  UnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

struct UnsplashPhotoImageURLsModel: Sendable, Equatable {
    let regular: URL?
    let small: URL?
    let thumb: URL?
}
