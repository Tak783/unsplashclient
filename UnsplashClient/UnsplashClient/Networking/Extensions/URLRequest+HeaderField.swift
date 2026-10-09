//
//  URLRequest+HeaderField.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

extension URLRequest {
    mutating func setValue(_ value: String, for headerFieldName: HTTPHeaderFieldName) {
        setValue(value, forHTTPHeaderField: headerFieldName.rawValue)
    }
}
