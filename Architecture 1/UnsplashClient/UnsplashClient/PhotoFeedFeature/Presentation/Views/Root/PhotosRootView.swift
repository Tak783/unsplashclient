//
//  PhotosRootView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

struct PhotosRootView: View {
    @State private var isSearchPresented = false
    @State private var feedViewModel = PhotosFeedViewModel()

    var body: some View {
        NavigationStack {
            content
                .background(Color.black)
                .toolbar(.hidden, for: .navigationBar)
                .searchable(
                    text: .constant(.init()),
                    isPresented: $isSearchPresented,
                    placement: .toolbar,
                    prompt: "Search photos"
                )
        }
    }
}

// MARK: - Content
extension PhotosRootView {
    @ViewBuilder
    private var content: some View {
        if isSearchPresented {
            PhotoSearchView(isSearchPresented: $isSearchPresented)
        } else {
            PhotoFeedGridView(viewModel: feedViewModel)
        }
    }
}
