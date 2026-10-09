//
//  PhotoFeedCell.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher
import SwiftUI

struct PhotoFeedCell: View {
    let cellWidthAndHeight: CGFloat
    let photo: UnsplashPhotoModel

    private static let fadeInDurationInSeconds = 0.15

    var body: some View {
        KFImage(photo.urls?.small)
            .placeholder {
                BlurredImagePlaceholderView(blurHash: photo.blurHash)
            }
            .backgroundDecode()
            .cancelOnDisappear(true)
            .fade(duration: Self.fadeInDurationInSeconds)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: cellWidthAndHeight, height: cellWidthAndHeight)
            .clipped()
    }
}

// MARK: - Equatable
extension PhotoFeedCell: Equatable {
    static func == (lhs: PhotoFeedCell, rhs: PhotoFeedCell) -> Bool {
        lhs.photo.id == rhs.photo.id
        && lhs.cellWidthAndHeight == rhs.cellWidthAndHeight
    }
}
