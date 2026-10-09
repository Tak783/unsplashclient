//
//  PhotosServiceStub.swift
//  UnsplashPhotosFeatureTests
//
//  Created on 09/10/2026.
//

import Foundation
@testable import UnsplashPhotosFeature

struct PhotosServiceStub: PhotosService {
    let photosToReturn: [UnsplashPhotoModel]

    init(photosToReturn: [UnsplashPhotoModel] = []) {
        self.photosToReturn = photosToReturn
    }

    func loadPhotos(pageNumber: Int, photosPerPage: Int) async throws -> [UnsplashPhotoModel] {
        photosToReturn
    }

    func searchPhotos(
        query: String,
        pageNumber: Int,
        photosPerPage: Int
    ) async throws -> [UnsplashPhotoModel] {
        photosToReturn
    }
}
