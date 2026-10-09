//
//  MemoryLeakTracking.swift
//  CoreTestSupport
//
//  Created on 09/10/2026.
//

import Testing

public func expectNoMemoryLeak<Instance: AnyObject>(
    sourceLocation: SourceLocation = #_sourceLocation,
    whenBuildingAndUsing buildAndUseInstance: () throws -> Instance
) throws {
    weak var instanceThatShouldHaveBeenReleased: Instance?

    instanceThatShouldHaveBeenReleased = try buildAndUseInstance()

    expectInstanceWasReleased(
        instanceThatShouldHaveBeenReleased,
        sourceLocation: sourceLocation
    )
}

public func expectNoMemoryLeak<Instance: AnyObject>(
    isolation: isolated (any Actor)? = #isolation,
    sourceLocation: SourceLocation = #_sourceLocation,
    whenBuildingAndUsing buildAndUseInstance: () async throws -> Instance
) async throws {
    weak var instanceThatShouldHaveBeenReleased: Instance?

    instanceThatShouldHaveBeenReleased = try await buildAndUseInstance()

    expectInstanceWasReleased(
        instanceThatShouldHaveBeenReleased,
        sourceLocation: sourceLocation
    )
}

// MARK: - Expectation
private func expectInstanceWasReleased<Instance: AnyObject>(
    _ instanceThatShouldHaveBeenReleased: Instance?,
    sourceLocation: SourceLocation
) {
    #expect(
        instanceThatShouldHaveBeenReleased == nil,
        "\(Instance.self) was still in memory after the last reference to it went away.",
        sourceLocation: sourceLocation
    )
}
