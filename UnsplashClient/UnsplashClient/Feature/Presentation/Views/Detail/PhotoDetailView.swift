//
//  PhotoDetailView.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import Kingfisher
import SwiftUI

struct PhotoDetailView: View {
    private static let fadeInDurationInSeconds = 0.15
    private static let closeButtonLeadingPadding: CGFloat = 16
    private static let closeButtonSize: CGFloat = 36
    private static let navigationBarHeight: CGFloat = 44
    private static let closeButtonBackgroundOpacity = 0.35

    // Centres the button where a navigation bar item would sit: the bar is
    // 44 points tall and starts below the safe area, so its centre is 22
    // points down. Offset by half the button to land on that centre line.
    private static var closeButtonTopPadding: CGFloat {
        (navigationBarHeight / 2) - (closeButtonSize / 2)
    }

    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: PhotoDetailViewModel

    init(viewModel: PhotoDetailViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
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
            }
            .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - Subviews
extension PhotoDetailView {
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
    // sat on an opaque strip that broke the full bleed image, and the bar
    // reserved height even when hidden. Placing it as an overlay keeps the
    // photo edge to edge and lets us control the exact position and styling.
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
        .padding(.leading, Self.closeButtonLeadingPadding)
        .padding(.top, Self.closeButtonTopPadding)
        .safeAreaPadding(.top)
    }
}
