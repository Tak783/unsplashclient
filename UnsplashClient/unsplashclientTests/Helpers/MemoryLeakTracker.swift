//
//  MemoryLeakTracker.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Testing

final class MemoryLeakTracker {
    private var trackedReferences = [TrackedReference]()

    func trackForMemoryLeaks(
        _ instance: AnyObject,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        trackedReferences.append(
            TrackedReference(
                instance: instance,
                typeName: String(describing: type(of: instance)),
                sourceLocation: sourceLocation
            )
        )
    }

    deinit {
        for trackedReference in trackedReferences where trackedReference.instance != nil {
            Issue.record(
                """
                Potential memory leak: \(trackedReference.typeName) was still in \
                memory after the test finished.
                """,
                sourceLocation: trackedReference.sourceLocation
            )
        }
    }
}

// MARK: - Tracked Reference
extension MemoryLeakTracker {
    private struct TrackedReference {
        weak var instance: AnyObject?
        let typeName: String
        let sourceLocation: SourceLocation
    }
}
