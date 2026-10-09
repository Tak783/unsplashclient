//
//  GridLayoutCalculatorUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol GridLayoutCalculatorUnitTestsSpec {
    func test_cellWidth_dividesRemainingWidthAfterRemovingGaps()
    func test_cellWidth_roundsDownSoCellsNeverOverflow()
    func test_cellWidth_returnsZeroWhenColumnCountIsNotPositive()
    func test_cellWidth_returnsZeroWhenSpacingLeavesNoRoom()
    func test_cellHeight_multipliesWidthByTheConfiguredRatio()
    func test_gridColumns_returnsOneFixedColumnPerConfiguredColumn()
}
