//
//  PhotosRootView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI
import UnsplashPhotosFeature

public struct PhotosRootView: View {
    @State private var isSearchPresented = false
    @State private var feedViewModel: PhotosFeedViewModel

    public init(feedViewModel: PhotosFeedViewModel) {
        _feedViewModel = State(initialValue: feedViewModel)
    }

    public var body: some View {
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
public extension PhotosRootView {
    @ViewBuilder
    private var content: some View {
        if isSearchPresented {
            PhotosViewFactory.makePhotoSearchView(isSearchPresented: $isSearchPresented)
        } else {
            PhotoFeedGridView(viewModel: feedViewModel)
        }
    }
}
