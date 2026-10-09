//
//  UnsplashAPIKeyProvider.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

#warning("Scheduled for removal. The Unsplash API call will be handled by the backend to protect the API Key")
struct UnsplashAPIKeyProvider: APIKeyProviding {
    let accessKey: String

    init(accessKey: String = "maXlR0w6Cl5wejKXhlo1SJhsuTJZeHnSSPEe2XV4I9E") {
        self.accessKey = accessKey
    }
}
