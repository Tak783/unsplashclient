//
//  DataDecodingError.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

public nonisolated protocol DataDecodingError: Error {
    static var invalidData: Self { get }
}
