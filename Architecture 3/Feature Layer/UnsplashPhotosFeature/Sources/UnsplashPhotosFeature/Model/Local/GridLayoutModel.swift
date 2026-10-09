//
//  GridLayoutModel.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreNetworking
public nonisolated struct GridLayoutModel: Sendable {
    public let columnCount: Int
    public let spacingBetweenCells: Double
    public let cellHeightAsMultipleOfWidth: Double

    public init(
        columnCount: Int = 3,
        spacingBetweenCells: Double = 2,
        cellHeightAsMultipleOfWidth: Double = 1.25
    ) {
        self.columnCount = columnCount
        self.spacingBetweenCells = spacingBetweenCells
        self.cellHeightAsMultipleOfWidth = cellHeightAsMultipleOfWidth
    }
}
