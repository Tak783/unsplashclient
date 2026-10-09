//
//  URLMakeUnitTestsSpec.swift
//  UnsplashClientTests
//
//  Created on 09/10/2026.
//

protocol URLMakeUnitTestsSpec {
    func test_make_buildsURLFromSchemeHostAndPath() throws
    func test_make_appendsQueryItemsInOrder() throws
    func test_make_percentEncodesQueryItemValues() throws
    func test_make_omitsTheQueryStringWhenNoItemsAreGiven() throws
    func test_urlScheme_rawValuesMatchTheirNames()
}
