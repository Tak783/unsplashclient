//
//  PaginationModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

nonisolated struct PaginationModel: Sendable {
    let itemsPerPage: Int
    let itemsFromEndThatTriggerNextPage: Int

    init(
        itemsPerPage: Int = 30,
        itemsFromEndThatTriggerNextPage: Int = 15
    ) {
        self.itemsPerPage = itemsPerPage
        self.itemsFromEndThatTriggerNextPage = itemsFromEndThatTriggerNextPage
    }
}
