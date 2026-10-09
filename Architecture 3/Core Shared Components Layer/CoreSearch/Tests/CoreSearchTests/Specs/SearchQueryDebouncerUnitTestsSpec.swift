//
//  SearchQueryDebouncerUnitTestsSpec.swift
//  CoreSearch
//
//  Created on 09/10/2026.
//

@MainActor
protocol SearchQueryDebouncerUnitTestsSpec {
    func test_queryDidChange_reportsTooShortForAQueryUnderTwoCharacters() async
    func test_queryDidChange_trimsWhitespaceBeforeSearching() async
    func test_queryDidChange_onlySearchesOnceWhenTypingQuickly() async
    func test_queryDidChange_skipsAQueryItHasAlreadyDispatched() async
    func test_cancelPendingSearch_stopsTheSearchFromRunning() async
}
