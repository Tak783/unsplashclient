//
//  PhotoDetailView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher
import SwiftUI
import CoreNetworking
import UnsplashPhotosFeature

public struct PhotoDetailView: View {
    private static let fadeInDurationInSeconds = 0.15
    private static let closeButtonLeadingPadding: CGFloat = 16
    private static let closeButtonSize: CGFloat = 36
    private static let navigationBarHeight: CGFloat = 44
    private static let closeButtonBackgroundOpacity = 0.35

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: PhotoDetailViewModel

    public init(viewModel: PhotoDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        GeometryReader { _ in
            photoImage
                .overlay(alignment: .bottom) {
                    PhotoCaptionOverlay(
                        caption: viewModel.photoPresentationModel.caption,
                        style: .fullScreen
                    )
                }
                .ignoresSafeArea()
                .overlay(alignment: .topLeading) {
                    closeButton
                        .padding(.leading, Self.closeButtonLeadingPadding)
                        .padding(.top, Self.closeButtonTopPadding)
                }
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Subviews
public extension PhotoDetailView {
    private var photoImage: some View {
        GeometryReader { geometryProxy in
            KFImage(viewModel.photoPresentationModel.imageURL)
                .placeholder {
                    BlurredImagePlaceholderView(
                        blurHash: viewModel.photoPresentationModel.blurHash
                    )
                }
                .backgroundDecode()
                .fade(duration: Self.fadeInDurationInSeconds)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(
                    width: geometryProxy.size.width,
                    height: geometryProxy.size.height
                )
                .clipped()
        }
        .background(Color.black)
    }

    // Deliberately not a navigation bar item. In the navigation bar the button
    // sat on an opaque strip that broke the full bleed image. The enclosing
    // GeometryReader keeps this overlay inside the safe area even though the
    // photo ignores it, so the only padding needed is half the leftover bar
    // height, which lands the button on a bar item's centre line.
    private var closeButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "xmark")
                .font(.body.weight(.semibold))
                .foregroundStyle(.white)
                .frame(width: Self.closeButtonSize, height: Self.closeButtonSize)
                .background(
                    Circle().fill(.black.opacity(Self.closeButtonBackgroundOpacity))
                )
        }
    }
}

// MARK: - Layout
public extension PhotoDetailView {
    private static var closeButtonTopPadding: CGFloat {
        (navigationBarHeight - closeButtonSize) / 2
    }
}
