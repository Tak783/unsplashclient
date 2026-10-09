//
//  URLRequest+HTTPMethod.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

nonisolated extension URLRequest {
    enum HTTPMethod: String {
        case get = "GET"
    }

    init(method: HTTPMethod, url: URL) {
        self.init(url: url)
        httpMethod = method.rawValue
    }
}
