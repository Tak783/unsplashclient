//
//  PhotoFeedPresenting.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

@MainActor
public protocol PhotoFeedPresenting: AnyObject {
    var gridLayoutModel: GridLayoutModel { get }
    var photoCellPresentationModels: [PhotoFeedCellPresentationModel] { get }
    var isLoadingNextPage: Bool { get }
    var errorMessage: String? { get }
    var isShowingErrorAlert: Bool { get set }

    func photoDidAppear(withID photoID: String)
    func retryLoadingNextPage() async
    func dismissErrorMessage()
    func photo(withID photoID: String) -> UnsplashPhotoModel?
}
