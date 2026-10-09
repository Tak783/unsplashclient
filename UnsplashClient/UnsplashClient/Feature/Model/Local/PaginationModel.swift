//
//  PaginationModel.swift
//  UnsplashClient
//
//  Created on 08/10/2026.
//

struct PaginationModel {
    let itemsPerPage: Int
    let itemsFromEndThatTriggerNextPage: Int

    init(
        itemsPerPage: Int = 30,
        itemsFromEndThatTriggerNextPage: Int = 30
    ) {
        self.itemsPerPage = itemsPerPage
        self.itemsFromEndThatTriggerNextPage = itemsFromEndThatTriggerNextPage
    }
}
