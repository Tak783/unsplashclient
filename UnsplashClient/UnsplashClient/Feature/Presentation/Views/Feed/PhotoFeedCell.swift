//
//  PhotoFeedCell.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher
import SwiftUI

struct PhotoFeedCell: View {
    private static let fadeInDurationInSeconds = 0.15

    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let photo: PhotoFeedCellPresentationModel

    var body: some View {
        ZStack(alignment: .bottom) {
            photoImage
            PhotoCaptionOverlay(caption: photo.caption, style: .grid)
        }
        .frame(width: cellWidth, height: cellHeight)
        .clipped()
    }
}

// MARK: - Subviews
extension PhotoFeedCell {
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
extension PhotoFeedCell: Equatable {
    static func == (lhs: PhotoFeedCell, rhs: PhotoFeedCell) -> Bool {
        lhs.photo == rhs.photo
        && lhs.cellWidth == rhs.cellWidth
        && lhs.cellHeight == rhs.cellHeight
    }
}
