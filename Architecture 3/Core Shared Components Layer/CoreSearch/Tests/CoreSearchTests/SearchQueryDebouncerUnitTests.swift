//
//  SearchQueryDebouncerUnitTests.swift
//  CoreSearchTests
//
//  Created on 09/10/2026.
//

import Foundation
import Testing
@testable import CoreSearch

@Suite
@MainActor
struct SearchQueryDebouncerUnitTests {
    private static let longerThanTheTypingPauseInSeconds = 0.6
}

// MARK: - SearchQueryDebouncerUnitTestsSpec
extension SearchQueryDebouncerUnitTests: SearchQueryDebouncerUnitTestsSpec {
    @Test("a query under two characters is reported as too short and never searched")
    func test_queryDidChange_reportsTooShortForAQueryUnderTwoCharacters() async {
        let recorder = QueryRecorder()
        let sut = SearchQueryDebouncer()

        sut.queryDidChange("t", perform: recorder.record, onQueryTooShort: recorder.recordTooShort)
        await waitForTheTypingPause()

        #expect(recorder.queriesSearched.isEmpty)
        #expect(recorder.tooShortCount == 1)
    }

    @Test("surrounding whitespace is trimmed before the search runs")
    func test_queryDidChange_trimsWhitespaceBeforeSearching() async {
        let recorder = QueryRecorder()
        let sut = SearchQueryDebouncer()

        sut.queryDidChange("  tigers  ", perform: recorder.record, onQueryTooShort: recorder.recordTooShort)
        await waitForTheTypingPause()

        #expect(recorder.queriesSearched == ["tigers"])
    }

    @Test("typing quickly searches once, for the last query typed")
    func test_queryDidChange_onlySearchesOnceWhenTypingQuickly() async {
        let recorder = QueryRecorder()
        let sut = SearchQueryDebouncer()

        for query in ["ti", "tig", "tige", "tiger"] {
            sut.queryDidChange(query, perform: recorder.record, onQueryTooShort: recorder.recordTooShort)
        }
        await waitForTheTypingPause()

        #expect(recorder.queriesSearched == ["tiger"])
    }

    @Test("a query already dispatched is not searched a second time")
    func test_queryDidChange_skipsAQueryItHasAlreadyDispatched() async {
        let recorder = QueryRecorder()
        let sut = SearchQueryDebouncer()

        sut.queryDidChange("tigers", perform: recorder.record, onQueryTooShort: recorder.recordTooShort)
        await waitForTheTypingPause()
        sut.queryDidChange("tigers", perform: recorder.record, onQueryTooShort: recorder.recordTooShort)
        await waitForTheTypingPause()

        #expect(recorder.queriesSearched == ["tigers"])
    }

    @Test("cancelling before the pause ends stops the search running at all")
    func test_cancelPendingSearch_stopsTheSearchFromRunning() async {
        let recorder = QueryRecorder()
        let sut = SearchQueryDebouncer()

        sut.queryDidChange("tigers", perform: recorder.record, onQueryTooShort: recorder.recordTooShort)
        sut.cancelPendingSearch()
        await waitForTheTypingPause()

        #expect(recorder.queriesSearched.isEmpty)
    }
}

// MARK: - Helpers
extension SearchQueryDebouncerUnitTests {
    private func waitForTheTypingPause() async {
        try? await Task.sleep(for: .seconds(Self.longerThanTheTypingPauseInSeconds))
    }
}

// MARK: - Recorder
@MainActor
private final class QueryRecorder {
    private(set) var queriesSearched = [String]()
    private(set) var tooShortCount = 0

    func record(_ query: String) async {
        queriesSearched.append(query)
    }

    func recordTooShort() {
        tooShortCount += 1
    }
}
