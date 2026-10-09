//
//  PhotoGridView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreNetworking
import Kingfisher
import SwiftUI
import UnsplashPhotosFeature

public struct PhotoGridView<Route: Hashable>: View {
    public let photoCellPresentationModels: [PhotoFeedCellPresentationModel]
    public let gridLayoutModel: GridLayoutModel
    public let photoZoomNamespace: Namespace.ID
    public let route: (PhotoFeedCellPresentationModel) -> Route
    public let onPhotoDidAppear: (String) -> Void
    public let onRefresh: (() async -> Void)?

    @State private var numberOfPhotosAlreadyPrefetched = 0

    public var body: some View {
        GeometryReader { geometryProxy in
            let cellWidth = cellWidth(forParentViewWidth: geometryProxy.size.width)

            ScrollView {
                LazyVGrid(
                    columns: gridColumns(cellWidth: cellWidth),
                    spacing: gridLayoutModel.spacingBetweenCells
                ) {
                    ForEach(photoCellPresentationModels, id: \.id) { photo in
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
                            onPhotoDidAppear(photo.id)
                        }
                    }
                }
            }
            .refreshableIfAvailable(onRefresh)
        }
        .onChange(of: photoCellPresentationModels.count, initial: true) { _, _ in
            prefetchImagesForNewlyLoadedPhotos()
        }
    }
}

// MARK: - Prefetching
public extension PhotoGridView {
    private func prefetchImagesForNewlyLoadedPhotos() {
        guard photoCellPresentationModels.count > numberOfPhotosAlreadyPrefetched else {
            numberOfPhotosAlreadyPrefetched = photoCellPresentationModels.count
            return
        }

        let newlyLoadedPhotos = photoCellPresentationModels[
            numberOfPhotosAlreadyPrefetched...
        ]
        numberOfPhotosAlreadyPrefetched = photoCellPresentationModels.count

        let imageURLsToPrefetch = newlyLoadedPhotos.compactMap(\.imageURL)
        guard !imageURLsToPrefetch.isEmpty else { return }

        ImagePrefetcher(urls: imageURLsToPrefetch).start()
    }
}

// MARK: - Grid Appearance Helpers
public extension PhotoGridView {
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
