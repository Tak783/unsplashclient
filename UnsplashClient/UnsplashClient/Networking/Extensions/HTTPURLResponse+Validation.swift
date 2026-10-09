//
//  HTTPURLResponse+Validation.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

extension HTTPURLResponse {
    private static let successfulStatusCodes = 200 ..< 300

    func validateStatusCode<Failure: HTTPStatusCodeError>(
        throwing failureType: Failure.Type
    ) throws {
        guard Self.successfulStatusCodes.contains(statusCode) else {
            throw failureType.init(statusCode: statusCode)
        }
    }
}
