//
//  LayoutModelInitialiserUnitTests.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

import Testing
@testable import UnsplashClient

@Suite
struct LayoutModelInitialiserUnitTests {}

// MARK: - LayoutModelInitialiserUnitTestsSpec
extension LayoutModelInitialiserUnitTests: LayoutModelInitialiserUnitTestsSpec {
    @Test("the grid defaults to three columns of 4:5 portrait tiles")
    func test_gridLayoutModel_defaultsToThreeColumnPortraitTiles() {
        let sut = GridLayoutModel()

        #expect(sut.columnCount == 3)
        #expect(sut.spacingBetweenCells == 2)
        #expect(sut.cellHeightAsMultipleOfWidth == 1.25)
    }

    @Test("the grid keeps values passed explicitly")
    func test_gridLayoutModel_keepsExplicitValues() {
        let sut = GridLayoutModel(
            columnCount: 2,
            spacingBetweenCells: 8,
            cellHeightAsMultipleOfWidth: 1
        )

        #expect(sut.columnCount == 2)
        #expect(sut.spacingBetweenCells == 8)
        #expect(sut.cellHeightAsMultipleOfWidth == 1)
    }

    @Test("pagination defaults to the Unsplash maximum of thirty per page")
    func test_paginationModel_defaultsToThirtyPerPage() {
        let sut = PaginationModel()

        #expect(sut.itemsPerPage == 30)
        #expect(sut.itemsFromEndThatTriggerNextPage == 30)
    }

    @Test("pagination keeps values passed explicitly")
    func test_paginationModel_keepsExplicitValues() {
        let sut = PaginationModel(
            itemsPerPage: 10,
            itemsFromEndThatTriggerNextPage: 4
        )

        #expect(sut.itemsPerPage == 10)
        #expect(sut.itemsFromEndThatTriggerNextPage == 4)
    }
}
