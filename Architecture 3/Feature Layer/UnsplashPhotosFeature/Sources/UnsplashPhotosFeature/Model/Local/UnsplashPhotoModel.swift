//
//  UnsplashPhotoModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import CoreNetworking
import Foundation

public nonisolated struct UnsplashPhotoModel: Sendable, Equatable {
    public let id: String
    public let description: String?
    public let altDescription: String?
    public let blurHash: String?
    public let urls: UnsplashPhotoImageURLsModel?
}
