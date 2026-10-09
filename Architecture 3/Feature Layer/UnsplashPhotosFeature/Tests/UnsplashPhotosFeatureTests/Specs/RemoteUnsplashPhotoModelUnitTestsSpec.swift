//
//  RemoteUnsplashPhotoModelUnitTestsSpec.swift
//  UnsplashPhotosFeature
//
//  Created on 09/10/2026.
//

protocol RemoteUnsplashPhotoModelUnitTestsSpec {
    func test_decoding_successfullyDecodesJSONDataToModel() throws
    func test_toLocalModel_copiesEveryFieldAcross() throws
    func test_toLocalModel_keepsNilURLsWhenTheURLsObjectIsMissing()
    func test_toLocalModels_convertsEveryRemotePhoto()
}
