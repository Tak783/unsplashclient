//
//  BlurHashImageStoreUnitTests.swift
//  UnsplashPhotosFeatureUITests
//
//  Created on 09/10/2026.
//

import CoreTesting
import Testing
@testable import UnsplashPhotosFeatureUI

@Suite
struct BlurHashImageStoreUnitTests {}

// MARK: - BlurHashImageStoreUnitTestsSpec
extension BlurHashImageStoreUnitTests: BlurHashImageStoreUnitTestsSpec {
    @Test("a store of its own is released once the last reference to it goes away")
    func test_init_doesNotLeakTheStore() async throws {
        try await expectNoMemoryLeak {
            let store = BlurHashImageStore()

            _ = await store.image(forBlurHash: "LEHV6nWB2yk8pyo0adR*.7kCMdnj")

            return store
        }
    }
}
