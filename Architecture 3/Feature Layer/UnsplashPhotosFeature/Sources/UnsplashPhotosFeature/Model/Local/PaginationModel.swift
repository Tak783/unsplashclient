//
//  PaginationModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

public nonisolated struct PaginationModel: Sendable {
    public let itemsPerPage: Int
    public let itemsFromEndThatTriggerNextPage: Int

    public init(
        itemsPerPage: Int = 30,
        itemsFromEndThatTriggerNextPage: Int = 15
    ) {
        self.itemsPerPage = itemsPerPage
        self.itemsFromEndThatTriggerNextPage = itemsFromEndThatTriggerNextPage
    }
}
