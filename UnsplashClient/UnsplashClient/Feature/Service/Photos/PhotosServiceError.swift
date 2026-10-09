//
//  PhotosServiceError.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

enum PhotosServiceError: Error, Equatable {
    case unauthorized
    case rateLimitExceeded
    case serverFailure
    case unexpectedStatusCode(Int)
    case invalidData
}

// MARK: - HTTPStatusCodeError
extension PhotosServiceError: HTTPStatusCodeError {
    init(statusCode: Int) {
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
extension PhotosServiceError: DataDecodingError {}
