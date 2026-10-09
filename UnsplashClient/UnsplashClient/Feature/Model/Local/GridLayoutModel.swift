//
//  GridLayoutModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

struct GridLayoutModel {
    let columnCount: Int
    let spacingBetweenCells: Double
    let cellHeightAsMultipleOfWidth: Double

    init(
        columnCount: Int = 3,
        spacingBetweenCells: Double = 2,
        cellHeightAsMultipleOfWidth: Double = 1.25
    ) {
        self.columnCount = columnCount
        self.spacingBetweenCells = spacingBetweenCells
        self.cellHeightAsMultipleOfWidth = cellHeightAsMultipleOfWidth
    }
}
