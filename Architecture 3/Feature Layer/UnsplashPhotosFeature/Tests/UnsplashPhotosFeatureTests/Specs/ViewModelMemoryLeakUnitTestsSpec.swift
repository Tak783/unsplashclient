//
//  ViewModelMemoryLeakUnitTestsSpec.swift
//  UnsplashPhotosFeature
//
//  Created on 09/10/2026.
//

@MainActor
protocol ViewModelMemoryLeakUnitTestsSpec {
    func test_photosFeedViewModel_isReleasedAfterLoadingAPage() async throws
    func test_photoSearchViewModel_isReleasedAfterASearch() async throws
    func test_photoDetailViewModel_isReleasedAfterBeingBuilt() throws
}
