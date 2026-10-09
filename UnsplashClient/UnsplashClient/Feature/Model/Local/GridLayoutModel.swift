//
//  GridLayoutModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

struct GridLayoutModel {
    let columnCount: Int
    let spacingBetweenCells: Double

    init(
        columnCount: Int = 3,
        spacingBetweenCells: Double = 2
    ) {
        self.columnCount = columnCount
        self.spacingBetweenCells = spacingBetweenCells
    }
}
