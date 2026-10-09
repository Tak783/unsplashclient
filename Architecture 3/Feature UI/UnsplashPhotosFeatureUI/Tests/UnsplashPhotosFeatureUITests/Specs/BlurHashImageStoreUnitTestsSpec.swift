//
//  BlurHashImageStoreUnitTestsSpec.swift
//  UnsplashPhotosFeatureUI
//
//  Created on 09/10/2026.
//

protocol BlurHashImageStoreUnitTestsSpec {
    func test_init_doesNotLeakTheStore() async throws
}
