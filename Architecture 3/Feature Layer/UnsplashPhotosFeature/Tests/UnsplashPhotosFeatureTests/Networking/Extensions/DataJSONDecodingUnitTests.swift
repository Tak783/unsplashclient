//
//  DataJSONDecodingUnitTests.swift
//  UnsplashPhotosFeatureTests
//
//  Created on 09/10/2026.
//

import CoreNetworking
import Foundation
import Testing
@testable import UnsplashPhotosFeature

@Suite
struct DataJSONDecodingUnitTests {}

// MARK: - DataJSONDecodingUnitTestsSpec
extension DataJSONDecodingUnitTests: DataJSONDecodingUnitTestsSpec {
    @Test("valid JSON decodes into the requested type")
    func test_decodeJSON_decodesValidJSONIntoTheRequestedType() throws {
        let sut = try anyPhotoJSON().decodeJSON(
            as: RemoteUnsplashPhotoModel.self,
            throwing: PhotosServiceError.self
        )

        #expect(sut.id == "photo-id")
        #expect(sut.description == "A description")
    }

    @Test("snake case keys are converted to camel case properties")
    func test_decodeJSON_convertsSnakeCaseKeysToCamelCase() throws {
        let sut = try anyPhotoJSON().decodeJSON(
            as: RemoteUnsplashPhotoModel.self,
            throwing: PhotosServiceError.self
        )

        #expect(sut.altDescription == "An alt description")
        #expect(sut.blurHash == "ANY-BLUR-HASH")
    }

    @Test("data that is not JSON throws the given failure")
    func test_decodeJSON_throwsTheGivenFailureWhenDataIsNotJSON() {
        let notJSON = Data("not json at all".utf8)

        #expect(throws: PhotosServiceError.invalidData) {
            _ = try notJSON.decodeJSON(
                as: RemoteUnsplashPhotoModel.self,
                throwing: PhotosServiceError.self
            )
        }
    }

    @Test("JSON missing a required key throws the given failure")
    func test_decodeJSON_throwsTheGivenFailureWhenARequiredKeyIsMissing() {
        let jsonWithoutID = Data(#"{"description": "A description"}"#.utf8)

        #expect(throws: PhotosServiceError.invalidData) {
            _ = try jsonWithoutID.decodeJSON(
                as: RemoteUnsplashPhotoModel.self,
                throwing: PhotosServiceError.self
            )
        }
    }
}

// MARK: - Factory
extension DataJSONDecodingUnitTests {
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
}
