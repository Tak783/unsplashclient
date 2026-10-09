//
//  PhotoDetailViewModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@MainActor
@Observable
public final class PhotoDetailViewModel {
    public let photoPresentationModel: PhotoDetailPresentationModel

    public init(photo: UnsplashPhotoModel) {
        photoPresentationModel = PhotoDetailPresentationModel(
            id: photo.id,
            caption: PhotoCaptionResolver.caption(for: photo),
            imageURL: photo.urls?.full ?? photo.urls?.regular,
            blurHash: photo.blurHash
        )
    }
}
