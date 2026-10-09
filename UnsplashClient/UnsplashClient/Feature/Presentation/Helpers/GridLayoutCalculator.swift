//
//  GridLayoutCalculator.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

enum GridLayoutCalculator {
    static func cellWidth(
        forParentViewWidth parentViewWidth: CGFloat,
        columnCount: Int,
        spacingBetweenCells: CGFloat
    ) -> CGFloat {
        guard columnCount > .zero else { return .zero }

        let numberOfGapsBetweenCells = columnCount - 1
        let totalSpaceBetweenCells = spacingBetweenCells * CGFloat(numberOfGapsBetweenCells)
        let widthAvailableForCells = parentViewWidth - totalSpaceBetweenCells

        guard widthAvailableForCells > .zero else {
            return .zero
        }
        return (widthAvailableForCells / CGFloat(columnCount)).rounded(.down)
    }

    static func cellHeight(
        forCellWidth cellWidth: CGFloat,
        cellHeightAsMultipleOfWidth: CGFloat
    ) -> CGFloat {
        (cellWidth * cellHeightAsMultipleOfWidth).rounded(.down)
    }

    static func gridColumns(
        cellWidth: CGFloat,
        columnCount: Int,
        spacingBetweenCells: CGFloat
    ) -> [GridItem] {
        Array(
            repeating: GridItem(
                .fixed(cellWidth),
                spacing: spacingBetweenCells
            ),
            count: columnCount
        )
    }
}
