//
//  PhotoDetailViewModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@MainActor
@Observable
final class PhotoDetailViewModel {
    let photoPresentationModel: PhotoDetailPresentationModel

    init(photo: UnsplashPhotoModel) {
        photoPresentationModel = PhotoDetailPresentationModel(
            id: photo.id,
            caption: PhotoCaptionResolver.caption(for: photo),
            imageURL: photo.urls?.full ?? photo.urls?.regular,
            blurHash: photo.blurHash
        )
    }
}
