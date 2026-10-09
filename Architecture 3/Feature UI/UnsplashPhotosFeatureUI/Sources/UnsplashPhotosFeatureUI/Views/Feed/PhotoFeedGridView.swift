//
//  PhotoFeedGridView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreFoundational
import SwiftUI
import UnsplashPhotosFeature

public struct PhotoFeedGridView: View {
    @Bindable var viewModel: PhotosFeedViewModel

    @Namespace private var photoZoomNamespace

    public var body: some View {
        PhotoGridView(
            photoCellPresentationModels: viewModel.photoCellPresentationModels,
            gridLayoutModel: viewModel.gridLayoutModel,
            photoZoomNamespace: photoZoomNamespace,
            route: { FeedPhotoRoute(photoID: $0.id) },
            onPhotoDidAppear: { viewModel.photoDidAppear(withID: $0) },
            onRefresh: { await viewModel.refresh() }
        )
        .background(Color.black)
        .task {
            await viewModel.loadFirstPageIfNeeded()
            safePrint("Feed appeared")
        }
        .navigationDestination(for: FeedPhotoRoute.self) { route in
            photoDetail(forPhotoID: route.photoID)
        }
        .alert(
            "Couldn't load photos",
            isPresented: $viewModel.isShowingErrorAlert
        ) {
            Button("Try again") {
                Task { await viewModel.retryLoadingNextPage() }
            }
            Button("Cancel", role: .cancel) {
                viewModel.dismissErrorMessage()
            }
        } message: {
            Text(viewModel.errorMessage ?? .empty)
        }
    }
}

// MARK: - Detail
public extension PhotoFeedGridView {
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
