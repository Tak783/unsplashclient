//
//  UnsplashImageURL.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@available(
    *,
    deprecated,
    message: "Scheduled for removal. `urlWhenResizedAsASquare` was built to return a perfect square image for the grid. However the image turned out larger image than Unsplash's own `small` size, so it takes longer to load. Please use the urls i.e. `small` on UnsplashPhotoModel instead."
)
nonisolated struct UnsplashImageURL: Sendable, Equatable {
    private let sourceURL: URL

    init(sourceURL: URL) {
        self.sourceURL = sourceURL
    }
}

// MARK: - Resizing
@available(*, deprecated)
nonisolated extension UnsplashImageURL {
    /// Returns URL for the Image as a square, unsplashes backend returns the image as a squaree
    /// - Parameters:
    ///   - cellWidthAndHeight: cellWidthAndHeight
    ///   - displayScale: displayScale
    /// - Returns: displayScale
    func urlWhenResizedAsASquare(
        cellWidthAndHeight: CGFloat,
        displayScale: CGFloat
    ) -> URL {
        guard var urlComponents = URLComponents(
            url: sourceURL,
            resolvingAgainstBaseURL: false
        ) else {
            return sourceURL
        }

        let cellWidthAndHeightInPixels = Int((cellWidthAndHeight * displayScale).rounded())
        let resizeAsSquareQueryItems = [
            URLQueryItem(name: "w", value: String(cellWidthAndHeightInPixels)),
            URLQueryItem(name: "h", value: String(cellWidthAndHeightInPixels)),
            URLQueryItem(name: "fit", value: "crop"),
            URLQueryItem(name: "crop", value: "entropy"),
            URLQueryItem(name: "q", value: "75"),
            URLQueryItem(name: "fm", value: "jpg")
        ]

        let queryItemNamesWeAreReplacing = Set(resizeAsSquareQueryItems.map(\.name))
        let queryItemsWorthKeeping = (urlComponents.queryItems ?? [])
            .filter { !queryItemNamesWeAreReplacing.contains($0.name) }

        urlComponents.queryItems = queryItemsWorthKeeping + resizeAsSquareQueryItems
        return urlComponents.url ?? sourceURL
    }
}
