//
//  PhotoRoutes.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

public nonisolated struct FeedPhotoRoute: Hashable, Sendable {
    public let photoID: String

    public init(photoID: String) {
        self.photoID = photoID
    }
}

public nonisolated struct SearchPhotoRoute: Hashable, Sendable {
    public let photoID: String

    public init(photoID: String) {
        self.photoID = photoID
    }
}
