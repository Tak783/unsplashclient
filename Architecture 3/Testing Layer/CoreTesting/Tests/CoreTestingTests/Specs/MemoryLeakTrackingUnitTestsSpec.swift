//
//  MemoryLeakTrackingUnitTestsSpec.swift
//  CoreTesting
//
//  Created on 09/10/2026.
//

protocol MemoryLeakTrackingUnitTestsSpec {
    func test_expectNoMemoryLeak_passesForAnInstanceThatIsReleased() throws
    func test_expectNoMemoryLeak_passesForAnInstanceAwaitedBeforeRelease() async throws
}
