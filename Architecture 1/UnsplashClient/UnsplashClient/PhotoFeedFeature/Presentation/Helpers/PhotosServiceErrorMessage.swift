//
//  PhotosServiceErrorMessage.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

nonisolated enum PhotosServiceErrorMessage {
    static func userFacingMessage(for error: Error) -> String {
        guard let photosServiceError = error as? PhotosServiceError else {
            return "Something went wrong. Please try again."
        }
        switch photosServiceError {
        case .rateLimitExceeded:
            return "Unsplash rate limit reached. Try again in a little while."
        case .unauthorized:
            return "The Unsplash access key was rejected."
        case .serverFailure:
            return "Unsplash is having trouble. Please try again."
        case .invalidData:
            return "That response could not be read."
        case .unexpectedStatusCode(let statusCode):
            return "Unexpected response from Unsplash (\(statusCode))."
        }
    }
}
