//
//  DataDecodingError.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

protocol DataDecodingError: Error {
    static var invalidData: Self { get }
}
