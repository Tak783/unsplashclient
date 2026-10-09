//
//  PhotoSearchView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

struct PhotoSearchView: View {
    @State private var viewModel: PhotoSearchViewModel
    @Namespace private var photoZoomNamespace

    init(viewModel: PhotoSearchViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        resultsOrPlaceholder
            .background(Color.black)
            .searchable(
                text: $viewModel.searchQuery,
                isPresented: .constant(true),
                placement: .toolbar,
                prompt: "Search photos"
            )
            .searchToolbarBehavior(.minimize)
            .navigationDestination(for: SearchPhotoRoute.self) { route in
                photoDetail(forPhotoID: route.photoID)
            }
            .alert(
                "Couldn't search photos",
                isPresented: $viewModel.isShowingErrorAlert
            ) {
                Button("Try again") {
                    Task { await viewModel.retryLoadingNextPage() }
                }
                Button("Cancel", role: .cancel) {
                    viewModel.dismissErrorMessage()
                }
            } message: {
                Text(viewModel.errorMessage ?? .init())
            }
    }
}

// MARK: - Content
extension PhotoSearchView {
    @ViewBuilder
    private var resultsOrPlaceholder: some View {
        if !viewModel.photoCellPresentationModels.isEmpty {
            resultsGrid
        } else if viewModel.isLoadingNextPage {
            centredMessage { ProgressView().tint(.white) }
        } else if viewModel.hasSearched {
            centredMessage {
                Text("No photos found")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        } else {
            centredMessage {
                Text("Type to search Unsplash for photos")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var resultsGrid: some View {
        PhotoGridView(
            photoCellPresentationModels: viewModel.photoCellPresentationModels,
            gridLayoutModel: viewModel.gridLayoutModel,
            photoZoomNamespace: photoZoomNamespace,
            route: { SearchPhotoRoute(photoID: $0.id) },
            onPhotoDidAppear: { viewModel.photoDidAppear(atIndex: $0) },
            onRefresh: nil
        )
    }

    private func centredMessage<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Detail
extension PhotoSearchView {
    @ViewBuilder
    private func photoDetail(forPhotoID photoID: String) -> some View {
        if let photo = viewModel.photo(withID: photoID) {
            PhotoDetailView(viewModel: PhotoDetailViewModel(photo: photo))
                .navigationTransition(
                    .zoom(sourceID: photoID, in: photoZoomNamespace)
                )
        }
    }
}
