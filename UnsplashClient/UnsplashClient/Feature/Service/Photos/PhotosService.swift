//
//  PhotosService.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

protocol PhotosService: Sendable {
    func loadPhotos(pageNumber: Int, photosPerPage: Int) async throws -> [UnsplashPhotoModel]

    func searchPhotos(
        query: String,
        pageNumber: Int,
        photosPerPage: Int
    ) async throws -> [UnsplashPhotoModel]
}
