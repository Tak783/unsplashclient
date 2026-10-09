//
//  URL+Make.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

extension URL {
    static func make(
        scheme: URLScheme,
        host: String,
        path: String,
        queryItems: [URLQueryItem]? = nil
    ) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme.rawValue
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
}
