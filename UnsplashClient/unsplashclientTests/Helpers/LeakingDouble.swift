//
//  LeakingDouble.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

final class DeliberatelyLeakingDouble {
    private var retainCycle: DeliberatelyLeakingDouble?

    func createRetainCycle() {
        retainCycle = self
    }
}
