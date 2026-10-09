//
//  MemoryLeakTrackingUnitTests.swift
//  CoreTestingTests
//
//  Created on 09/10/2026.
//

import Testing
@testable import CoreTesting

private final class ObjectThatIsReleased {
    let identifier: String

    init(identifier: String) {
        self.identifier = identifier
    }
}

@Suite
struct MemoryLeakTrackingUnitTests {}

// MARK: - MemoryLeakTrackingUnitTestsSpec
extension MemoryLeakTrackingUnitTests: MemoryLeakTrackingUnitTestsSpec {
    @Test("an object with no retain cycle passes the check")
    func test_expectNoMemoryLeak_passesForAnInstanceThatIsReleased() throws {
        try expectNoMemoryLeak {
            ObjectThatIsReleased(identifier: "one")
        }
    }

    @Test("an object built with asynchronous work also passes the check")
    func test_expectNoMemoryLeak_passesForAnInstanceAwaitedBeforeRelease() async throws {
        try await expectNoMemoryLeak {
            let instance = ObjectThatIsReleased(identifier: "two")
            try await Task.sleep(for: .milliseconds(10))
            return instance
        }
    }
}
