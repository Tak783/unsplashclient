//
//  LayoutModelInitialiserUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol LayoutModelInitialiserUnitTestsSpec {
    func test_gridLayoutModel_defaultsToThreeColumnPortraitTiles()
    func test_gridLayoutModel_keepsExplicitValues()
    func test_paginationModel_defaultsToThirtyPerPage()
    func test_paginationModel_keepsExplicitValues()
}
