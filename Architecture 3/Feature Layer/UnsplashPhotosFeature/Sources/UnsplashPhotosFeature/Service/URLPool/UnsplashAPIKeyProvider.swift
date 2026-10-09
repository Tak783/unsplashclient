//
//  UnsplashAPIKeyProvider.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//
import CoreNetworking

#warning("Scheduled for removal. The Unsplash API call will be handled by the backend to protect the API Key")
public nonisolated struct UnsplashAPIKeyProvider: APIKeyProviding {
    public let accessKey: String

    public init(accessKey: String = "maXlR0w6Cl5wejKXhlo1SJhsuTJZeHnSSPEe2XV4I9E") {
        self.accessKey = accessKey
    }
}
