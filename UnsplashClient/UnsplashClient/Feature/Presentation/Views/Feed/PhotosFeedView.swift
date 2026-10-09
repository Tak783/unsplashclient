//
//  PhotosFeedView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

struct PhotosFeedView: View {
    @State private var viewModel: PhotosFeedViewModel

    init(viewModel: PhotosFeedViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        GeometryReader { geometryProxy in
            let cellWidthAndHeight = cellWidthAndHeight(
                forParentViewWidth: geometryProxy.size.width
            )
            ScrollView {
                LazyVGrid(
                    columns: gridColumns(cellWidthAndHeight: cellWidthAndHeight),
                    spacing: viewModel.gridLayoutModel.spacingBetweenCells
                ) {
                    ForEach(
                        Array(viewModel.photos.enumerated()),
                        id: \.element.id
                    ) { photoIndex, photo in
                        PhotoFeedCell(
                            cellWidthAndHeight: cellWidthAndHeight,
                            photo: photo
                        )
                        .equatable()
                        .onAppear {
                            viewModel.photoDidAppear(atIndex: photoIndex)
                        }
                    }
                }
            }
            .refreshable {
                await viewModel.refresh()
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
    func cellWidthAndHeight(forParentViewWidth width: CGFloat) -> CGFloat {
        GridLayoutCalculator.cellWidthAndHeight(
            forParentViewWidth: width,
            columnCount: viewModel.gridLayoutModel.columnCount,
            spacingBetweenCells: viewModel.gridLayoutModel.spacingBetweenCells
        )
    }

    func gridColumns(cellWidthAndHeight: CGFloat) -> [GridItem] {
        GridLayoutCalculator.gridColumns(
            cellWidthAndHeight: cellWidthAndHeight,
            columnCount: viewModel.gridLayoutModel.columnCount,
            spacingBetweenCells: viewModel.gridLayoutModel.spacingBetweenCells
        )
    }
}
