//
//  APIKeyProviding.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

#warning("Scheduled for removal. API calls will be handled by the backend to protect the API Key")
public nonisolated protocol APIKeyProviding: Sendable {
    var accessKey: String { get }
}
