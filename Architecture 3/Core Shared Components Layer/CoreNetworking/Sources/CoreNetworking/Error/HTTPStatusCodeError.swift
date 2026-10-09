//
//  HTTPStatusCodeError.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

public nonisolated protocol HTTPStatusCodeError: Error {
    init(statusCode: Int)
}
