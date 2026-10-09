//
//  GridLayoutCalculatorUnitTests.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Foundation
import SwiftUI
import Testing
@testable import UnsplashClient

@Suite
struct GridLayoutCalculatorUnitTests {
    @Test("cell width divides the width left after the gaps between cells")
    func test_cellWidth_dividesRemainingWidthAfterRemovingGaps() {
        let sut = GridLayoutCalculator.cellWidth(
            forParentViewWidth: 404,
            columnCount: 3,
            spacingBetweenCells: 2
        )

        #expect(sut == 133)
    }

    @Test("cell width rounds down so three cells plus gaps never exceed the width")
    func test_cellWidth_roundsDownSoCellsNeverOverflow() {
        let parentViewWidth: CGFloat = 402
        let columnCount = 3
        let spacingBetweenCells: CGFloat = 2

        let sut = GridLayoutCalculator.cellWidth(
            forParentViewWidth: parentViewWidth,
            columnCount: columnCount,
            spacingBetweenCells: spacingBetweenCells
        )

        let totalGaps = spacingBetweenCells * CGFloat(columnCount - 1)
        #expect(sut == 132)
        #expect(sut * CGFloat(columnCount) + totalGaps <= parentViewWidth)
    }

    @Test(
        "a column count of zero or less gives a zero width rather than dividing by zero",
        arguments: [0, -1]
    )
    func test_cellWidth_returnsZeroWhenColumnCountIsNotPositive(columnCount: Int) {
        let sut = GridLayoutCalculator.cellWidth(
            forParentViewWidth: 402,
            columnCount: columnCount,
            spacingBetweenCells: 2
        )

        #expect(sut == .zero)
    }

    @Test("spacing wider than the parent gives a zero width rather than a negative one")
    func test_cellWidth_returnsZeroWhenSpacingLeavesNoRoom() {
        let sut = GridLayoutCalculator.cellWidth(
            forParentViewWidth: 10,
            columnCount: 3,
            spacingBetweenCells: 100
        )

        #expect(sut == .zero)
    }

    @Test("cell height is the width multiplied by the configured ratio")
    func test_cellHeight_multipliesWidthByTheConfiguredRatio() {
        let sut = GridLayoutCalculator.cellHeight(
            forCellWidth: 132,
            cellHeightAsMultipleOfWidth: 1.25
        )

        #expect(sut == 165)
    }

    @Test("grid columns returns one fixed column per configured column")
    func test_gridColumns_returnsOneFixedColumnPerConfiguredColumn() {
        let sut = GridLayoutCalculator.gridColumns(
            cellWidth: 132,
            columnCount: 3,
            spacingBetweenCells: 2
        )

        #expect(sut.count == 3)
        #expect(sut.allSatisfy { $0.spacing == 2 })
    }
}

