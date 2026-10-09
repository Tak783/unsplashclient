//
//  PhotoDetailPresentationModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreNetworking
import Foundation

public nonisolated struct PhotoDetailPresentationModel: Sendable, Equatable {
    public let id: String
    public let caption: String
    public let imageURL: URL?
    public let blurHash: String?
}
