//
//  MemoryLeakTrackerUnitTests.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Testing
@testable import UnsplashClient

@Suite
final class MemoryLeakTrackerUnitTests {
    private let memoryLeakTracker = MemoryLeakTracker()

    @Test("an object that deallocates normally records no issue")
    func test_trackForMemoryLeaks_recordsNothingForAnObjectThatDeallocates() {
        let doubleThatDeallocates = DeliberatelyLeakingDouble()
        memoryLeakTracker.trackForMemoryLeaks(doubleThatDeallocates)
    }
}
