//
//  PhotosFeedView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

struct PhotosFeedView: View {
    @State private var viewModel: PhotosFeedViewModel
    @Namespace private var photoZoomNamespace

    init(viewModel: PhotosFeedViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            GeometryReader { geometryProxy in
            let cellWidth = cellWidth(
                forParentViewWidth: geometryProxy.size.width
            )
            ScrollView {
                LazyVGrid(
                    columns: gridColumns(cellWidth: cellWidth),
                    spacing: viewModel.gridLayoutModel.spacingBetweenCells
                ) {
                    ForEach(
                        Array(viewModel.photoCellPresentationModels.enumerated()),
                        id: \.element.id
                    ) { photoIndex, photo in
                        NavigationLink(value: photo.id) {
                            PhotoFeedCell(
                                cellWidth: cellWidth,
                                cellHeight: cellHeight(forCellWidth: cellWidth),
                                photo: photo
                            )
                            .equatable()
                        }
                        .buttonStyle(.plain)
                        .matchedTransitionSource(id: photo.id, in: photoZoomNamespace)
                        .onAppear {
                            viewModel.photoDidAppear(atIndex: photoIndex)
                        }
                    }
                }
            }
            .background(Color.black)
            .refreshable {
                await viewModel.refresh()
            }
            }
            .background(Color.black)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: String.self) { photoID in
                if let photo = viewModel.photo(withID: photoID) {
                    PhotoDetailView(viewModel: PhotoDetailViewModel(photo: photo))
                        .navigationTransition(
                            .zoom(sourceID: photoID, in: photoZoomNamespace)
                        )
                }
            }
        }
        .task {
            await viewModel.loadFirstPageIfNeeded()
        }
        .alert(
            "Couldn't load photos",
            isPresented: $viewModel.isShowingErrorAlert
        ) {
            Button("Try again") {
                Task {
                    await viewModel.retryLoadingNextPage()
                }
            }
            Button("Cancel", role: .cancel) {
                viewModel.dismissErrorMessage()
            }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
    }
}

// MARK: - Grid Appearance Helpers
extension PhotosFeedView {
    func cellWidth(forParentViewWidth width: CGFloat) -> CGFloat {
        GridLayoutCalculator.cellWidth(
            forParentViewWidth: width,
            columnCount: viewModel.gridLayoutModel.columnCount,
            spacingBetweenCells: viewModel.gridLayoutModel.spacingBetweenCells
        )
    }

    func cellHeight(forCellWidth cellWidth: CGFloat) -> CGFloat {
        GridLayoutCalculator.cellHeight(
            forCellWidth: cellWidth,
            cellHeightAsMultipleOfWidth: viewModel.gridLayoutModel.cellHeightAsMultipleOfWidth
        )
    }

    func gridColumns(cellWidth: CGFloat) -> [GridItem] {
        GridLayoutCalculator.gridColumns(
            cellWidth: cellWidth,
            columnCount: viewModel.gridLayoutModel.columnCount,
            spacingBetweenCells: viewModel.gridLayoutModel.spacingBetweenCells
        )
    }
}
