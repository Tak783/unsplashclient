//
//  PhotoFeedCell.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher
import SwiftUI
import CoreNetworking
import UnsplashPhotosFeature

public struct PhotoFeedCell: View {
    private static let fadeInDurationInSeconds = 0.15

    public let cellWidth: CGFloat
    public let cellHeight: CGFloat
    public let photo: PhotoFeedCellPresentationModel

    public var body: some View {
        ZStack(alignment: .bottom) {
            photoImage
            PhotoCaptionOverlay(caption: photo.caption, style: .grid)
        }
        .frame(width: cellWidth, height: cellHeight)
        .clipped()
    }
}

// MARK: - Subviews
public extension PhotoFeedCell {
    private var photoImage: some View {
        KFImage(photo.imageURL)
            .placeholder { BlurredImagePlaceholderView(blurHash: photo.blurHash) }
            .backgroundDecode()
            .cancelOnDisappear(true)
            .fade(duration: Self.fadeInDurationInSeconds)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: cellWidth, height: cellHeight)
            .clipped()
    }
}

// MARK: - Equatable
extension PhotoFeedCell: @MainActor Equatable {
    public nonisolated static func == (lhs: PhotoFeedCell, rhs: PhotoFeedCell) -> Bool {
        lhs.photo == rhs.photo
        && lhs.cellWidth == rhs.cellWidth
        && lhs.cellHeight == rhs.cellHeight
    }
}
