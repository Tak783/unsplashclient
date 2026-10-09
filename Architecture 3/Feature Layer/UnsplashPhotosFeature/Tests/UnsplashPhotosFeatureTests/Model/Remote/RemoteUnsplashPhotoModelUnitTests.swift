//
//  RemoteUnsplashPhotoModelUnitTests.swift
//  UnsplashPhotosFeatureTests
//
//  Created on 09/10/2026.
//

import Foundation
import Testing
@testable import UnsplashPhotosFeature

@Suite
struct RemoteUnsplashPhotoModelUnitTests {}

// MARK: - RemoteUnsplashPhotoModelUnitTestsSpec
extension RemoteUnsplashPhotoModelUnitTests: RemoteUnsplashPhotoModelUnitTestsSpec {
    @Test("a full photo payload decodes into the remote model")
    func test_decoding_successfullyDecodesJSONDataToModel() throws {
        let sut = try decodedPhoto(from: anyPhotoJSON())

        #expect(sut.id == "photo-id")
        #expect(sut.description == "A description")
        #expect(sut.altDescription == "An alt description")
        #expect(sut.blurHash == "ANY-BLUR-HASH")
        #expect(sut.urls?.small?.absoluteString == "https://images.unsplash.com/small")
    }

    @Test("converting to the local model copies every field across")
    func test_toLocalModel_copiesEveryFieldAcross() throws {
        let remotePhoto = try decodedPhoto(from: anyPhotoJSON())

        let sut = remotePhoto.toLocalModel()

        #expect(sut.id == remotePhoto.id)
        #expect(sut.description == remotePhoto.description)
        #expect(sut.altDescription == remotePhoto.altDescription)
        #expect(sut.blurHash == remotePhoto.blurHash)
        #expect(sut.urls?.full == remotePhoto.urls?.full)
        #expect(sut.urls?.regular == remotePhoto.urls?.regular)
        #expect(sut.urls?.small == remotePhoto.urls?.small)
    }

    @Test("a photo with no urls object still converts, with nil urls")
    func test_toLocalModel_keepsNilURLsWhenTheURLsObjectIsMissing() {
        let remotePhoto = RemoteUnsplashPhotoModel(
            id: "photo-id",
            description: nil,
            altDescription: nil,
            blurHash: nil,
            urls: nil
        )

        let sut = remotePhoto.toLocalModel()

        #expect(sut.id == "photo-id")
        #expect(sut.urls == nil)
    }

    @Test("converting an array converts every photo in it")
    func test_toLocalModels_convertsEveryRemotePhoto() {
        let sut = anyRemotePhotos().toLocalModels()

        #expect(sut.count == 2)
        #expect(sut[0].id == "first-id")
        #expect(sut[1].id == "second-id")
    }
}

// MARK: - Helpers
extension RemoteUnsplashPhotoModelUnitTests {
    private func decodedPhoto(from data: Data) throws -> RemoteUnsplashPhotoModel {
        try data.decodeJSON(
            as: RemoteUnsplashPhotoModel.self,
            throwing: PhotosServiceError.self
        )
    }
}

// MARK: - Factory
extension RemoteUnsplashPhotoModelUnitTests {
    private func anyPhotoJSON() -> Data {
        Data(
            #"""
            {
                "id": "photo-id",
                "description": "A description",
                "alt_description": "An alt description",
                "blur_hash": "ANY-BLUR-HASH",
                "urls": {
                    "full": "https://images.unsplash.com/full",
                    "regular": "https://images.unsplash.com/regular",
                    "small": "https://images.unsplash.com/small"
                }
            }
            """#.utf8
        )
    }

    private func anyRemotePhotos() -> [RemoteUnsplashPhotoModel] {
        [
            .init(
                id: "first-id",
                description: nil,
                altDescription: nil,
                blurHash: nil,
                urls: nil
            ),
            .init(
                id: "second-id",
                description: nil,
                altDescription: nil,
                blurHash: nil,
                urls: nil
            )
        ]
    }
}
