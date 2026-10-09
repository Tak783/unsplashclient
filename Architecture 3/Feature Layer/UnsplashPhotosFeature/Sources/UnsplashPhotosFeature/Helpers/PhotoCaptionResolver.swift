//
//  PhotoCaptionResolver.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreNetworking
import Foundation

public nonisolated enum PhotoCaptionResolver {
    private static let missingCaptionPlaceholder = "Untitled photo"

    public static func caption(for photo: UnsplashPhotoModel) -> String {
        [photo.altDescription, photo.description]
            .compactMap { $0?.trimmingCharacters(in: .whitespacesAndNewlines) }
            .first { !$0.isEmpty } ?? missingCaptionPlaceholder
    }
}
