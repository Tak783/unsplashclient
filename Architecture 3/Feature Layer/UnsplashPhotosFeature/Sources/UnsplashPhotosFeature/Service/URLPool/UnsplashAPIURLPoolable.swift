//
//  UnsplashAPIURLPoolable.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation
import CoreNetworking

public nonisolated protocol UnsplashAPIURLPoolable {
    static func photosFeedRequest(
        pageNumber: Int,
        photosPerPage: Int,
        accessKey: String
    ) throws -> URLRequest

    static func searchPhotosRequest(
        query: String,
        pageNumber: Int,
        photosPerPage: Int,
        accessKey: String
    ) throws -> URLRequest
}
