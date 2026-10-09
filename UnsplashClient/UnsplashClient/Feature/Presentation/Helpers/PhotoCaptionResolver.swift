//
//  PhotoCaptionResolver.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

enum PhotoCaptionResolver {
    private static let missingCaptionPlaceholder = "Untitled photo"

    static func caption(for photo: UnsplashPhotoModel) -> String {
        [photo.altDescription, photo.description]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty } ?? missingCaptionPlaceholder
    }
}
