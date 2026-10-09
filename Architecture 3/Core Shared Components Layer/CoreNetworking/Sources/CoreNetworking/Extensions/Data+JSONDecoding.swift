//
//  Data+JSONDecoding.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

import Foundation

public nonisolated extension Data {
    func decodeJSON<Decoded: Decodable, Failure: DataDecodingError>(
        as decodedType: Decoded.Type = Decoded.self,
        throwing failureType: Failure.Type
    ) throws -> Decoded {
        do {
            return try Self.makeSnakeCaseJSONDecoder().decode(decodedType, from: self)
        } catch {
            throw failureType.invalidData
        }
    }

    private static func makeSnakeCaseJSONDecoder() -> JSONDecoder {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }
}
