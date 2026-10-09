//
//  PhotoGridView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import SwiftUI

struct PhotoGridView<Route: Hashable>: View {
    let photoCellPresentationModels: [PhotoFeedCellPresentationModel]
    let gridLayoutModel: GridLayoutModel
    let photoZoomNamespace: Namespace.ID
    let route: (PhotoFeedCellPresentationModel) -> Route
    let onPhotoDidAppear: (Int) -> Void
    let onRefresh: (() async -> Void)?

    var body: some View {
        GeometryReader { geometryProxy in
            let cellWidth = cellWidth(forParentViewWidth: geometryProxy.size.width)

            ScrollView {
                LazyVGrid(
                    columns: gridColumns(cellWidth: cellWidth),
                    spacing: gridLayoutModel.spacingBetweenCells
                ) {
                    ForEach(
                        Array(photoCellPresentationModels.enumerated()),
                        id: \.element.id
                    ) { photoIndex, photo in
                        NavigationLink(value: route(photo)) {
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
                            onPhotoDidAppear(photoIndex)
                        }
                    }
                }
            }
            .refreshableIfAvailable(onRefresh)
        }
    }
}

// MARK: - Grid Appearance Helpers
extension PhotoGridView {
    private func cellWidth(forParentViewWidth width: CGFloat) -> CGFloat {
        GridLayoutCalculator.cellWidth(
            forParentViewWidth: width,
            columnCount: gridLayoutModel.columnCount,
            spacingBetweenCells: gridLayoutModel.spacingBetweenCells
        )
    }

    private func cellHeight(forCellWidth cellWidth: CGFloat) -> CGFloat {
        GridLayoutCalculator.cellHeight(
            forCellWidth: cellWidth,
            cellHeightAsMultipleOfWidth: gridLayoutModel.cellHeightAsMultipleOfWidth
        )
    }

    private func gridColumns(cellWidth: CGFloat) -> [GridItem] {
        GridLayoutCalculator.gridColumns(
            cellWidth: cellWidth,
            columnCount: gridLayoutModel.columnCount,
            spacingBetweenCells: gridLayoutModel.spacingBetweenCells
        )
    }
}

// MARK: - Optional Refresh
private extension View {
    @ViewBuilder
    func refreshableIfAvailable(_ onRefresh: (() async -> Void)?) -> some View {
        if let onRefresh {
            refreshable { await onRefresh() }
        } else {
            self
        }
    }
}
