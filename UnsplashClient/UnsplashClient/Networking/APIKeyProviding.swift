//
//  APIKeyProviding.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

protocol APIKeyProviding: Sendable {
    var accessKey: String { get }
}
