//
//  SearchQueryDebouncer.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Foundation

@MainActor
final class SearchQueryDebouncer {
    private static let minimumQueryLength = 2
    private static let typingPauseInSeconds = 0.4

    private var pendingSearchTask: Task<Void, Never>?
    private var lastDispatchedQuery: String?
}

// MARK: - Query Changes
extension SearchQueryDebouncer {
    func queryDidChange(
        _ rawQuery: String,
        perform search: @escaping (String) async -> Void,
        onQueryTooShort: @escaping () -> Void
    ) {
        pendingSearchTask?.cancel()

        let query = Self.normalised(rawQuery)

        guard query.count >= Self.minimumQueryLength else {
            lastDispatchedQuery = nil
            onQueryTooShort()
            return
        }

        guard query != lastDispatchedQuery else { return }

        pendingSearchTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(Self.typingPauseInSeconds))
            guard !Task.isCancelled, let self else { return }
            lastDispatchedQuery = query
            await search(query)
        }
    }

    func submitImmediately(
        _ rawQuery: String,
        perform search: @escaping (String) async -> Void
    ) {
        pendingSearchTask?.cancel()

        let query = Self.normalised(rawQuery)
        guard query.count >= Self.minimumQueryLength else { return }

        pendingSearchTask = Task { [weak self] in
            guard let self else { return }
            lastDispatchedQuery = query
            await search(query)
        }
    }

    func cancelPendingSearch() {
        pendingSearchTask?.cancel()
        pendingSearchTask = nil
        lastDispatchedQuery = nil
    }
}

// MARK: - Helpers
extension SearchQueryDebouncer {
    private static func normalised(_ rawQuery: String) -> String {
        rawQuery.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
