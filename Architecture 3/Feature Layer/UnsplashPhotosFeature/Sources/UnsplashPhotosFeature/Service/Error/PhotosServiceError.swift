//
//  PhotosServiceError.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//
import CoreNetworking

public nonisolated enum PhotosServiceError: Error, Equatable {
    case unauthorized
    case rateLimitExceeded
    case serverFailure
    case unexpectedStatusCode(Int)
    case invalidData
}

// MARK: - HTTPStatusCodeError
nonisolated extension PhotosServiceError: HTTPStatusCodeError {
    public init(statusCode: Int) {
        switch statusCode {
        case 401:
            self = .unauthorized
        case 403, 429:
            self = .rateLimitExceeded
        case 500...599:
            self = .serverFailure
        default:
            self = .unexpectedStatusCode(statusCode)
        }
    }
}

// MARK: - DataDecodingError
nonisolated extension PhotosServiceError: DataDecodingError {}
