//
//  CancellationCheck.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

public nonisolated enum CancellationCheck {
    public static func isCancellation(_ error: Error) -> Bool {
        if error is CancellationError {
            return true
        }
        if let urlError = error as? URLError, urlError.code == .cancelled {
            return true
        }
        return false
    }
}
