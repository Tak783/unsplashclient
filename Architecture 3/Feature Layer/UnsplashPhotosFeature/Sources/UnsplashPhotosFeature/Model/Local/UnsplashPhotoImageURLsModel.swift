//
//  UnsplashPhotoImageURLsModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation
import CoreNetworking

public nonisolated struct UnsplashPhotoImageURLsModel: Sendable, Equatable {
    public let full: URL?
    public let regular: URL?
    public let small: URL?
}
