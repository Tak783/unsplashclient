//
//  PhotoFeedCellPresentationModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

nonisolated struct PhotoFeedCellPresentationModel: Sendable, Equatable {
    let id: String
    let caption: String
    let imageURL: URL?
    let blurHash: String?
}
