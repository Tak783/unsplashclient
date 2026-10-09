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
    private static let captionLineLimit = 2
    private static let captionHorizontalPadding: CGFloat = 6
    private static let captionBottomPadding: CGFloat = 6
    private static let captionTopPaddingForGradient: CGFloat = 30
    private static let captionBackgroundMidOpacity = 0.55
    private static let captionBackgroundBottomOpacity = 0.95

    let cellWidth: CGFloat
    let cellHeight: CGFloat
    let photo: PhotoFeedCellPresentationModel

    var body: some View {
        ZStack(alignment: .bottom) {
            photoImage
            captionOverlay
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

    private var captionOverlay: some View {
        Text(photo.caption)
            .font(.caption2)
            .foregroundStyle(.white)
            .lineLimit(Self.captionLineLimit)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, Self.captionHorizontalPadding)
            .padding(.bottom, Self.captionBottomPadding)
            .padding(.top, Self.captionTopPaddingForGradient)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: .clear, location: 0),
                        .init(
                            color: .black.opacity(Self.captionBackgroundMidOpacity),
                            location: 0.45
                        ),
                        .init(
                            color: .black.opacity(Self.captionBackgroundBottomOpacity),
                            location: 1
                        )
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
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
