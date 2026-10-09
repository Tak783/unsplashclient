//
//  GridLayoutCalculator.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

enum GridLayoutCalculator {
    static func cellWidthAndHeight(
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

    static func gridColumns(
        cellWidthAndHeight: CGFloat,
        columnCount: Int,
        spacingBetweenCells: CGFloat
    ) -> [GridItem] {
        Array(
            repeating: GridItem(
                .fixed(cellWidthAndHeight),
                spacing: spacingBetweenCells
            ),
            count: columnCount
        )
    }
}
