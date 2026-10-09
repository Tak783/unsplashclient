//
//  HTTPStatusCodeError.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

protocol HTTPStatusCodeError: Error {
    init(statusCode: Int)
}
