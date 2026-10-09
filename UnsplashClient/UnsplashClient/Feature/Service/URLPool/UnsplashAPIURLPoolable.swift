//
//  UnsplashAPIURLPoolable.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

protocol UnsplashAPIURLPoolable {
    static func photosFeedRequest(
        pageNumber: Int,
        photosPerPage: Int,
        accessKey: String
    ) throws -> URLRequest
}
