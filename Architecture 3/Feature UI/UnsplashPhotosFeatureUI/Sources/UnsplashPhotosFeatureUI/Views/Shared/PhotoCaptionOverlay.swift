//
//  PhotoCaptionOverlay.swift
//  UnsplashClient
//
//  Created on 09/10/2026.
//

import CoreDesignSystem
import CoreNetworking
import SwiftUI
import UnsplashPhotosFeature

public struct PhotoCaptionOverlay: View {
    public let caption: String
    public let style: Style

    public var body: some View {
        captionTextWithPadding
            .background(Self.backgroundGradient)
    }
}

// MARK: - Subviews
public extension PhotoCaptionOverlay {
    @ViewBuilder
    private var captionTextWithPadding: some View {
        if style.respectsBottomSafeArea {
            captionText.safeAreaPadding(.bottom)
        } else {
            captionText
        }
    }

    private var captionText: some View {
        Text(caption)
            .font(style.font)
            .foregroundStyle(.white)
            .lineLimit(style.lineLimit)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, style.horizontalPadding)
            .padding(.bottom, style.bottomPadding)
            .padding(.top, style.topPaddingForGradient)
    }
}

// MARK: - Style
public extension PhotoCaptionOverlay {
    public struct Style: Sendable {
        let font: Font
        let lineLimit: Int?
        let horizontalPadding: CGFloat
        let bottomPadding: CGFloat
        let topPaddingForGradient: CGFloat
        let respectsBottomSafeArea: Bool

        static let grid = Style(
            font: .caption2,
            lineLimit: 2,
            horizontalPadding: DesignSystem.Spacing.extraSmall,
            bottomPadding: DesignSystem.Spacing.extraSmall,
            topPaddingForGradient: DesignSystem.GradientHeight.short,
            respectsBottomSafeArea: false
        )

        static let fullScreen = Style(
            font: .subheadline,
            lineLimit: nil,
            horizontalPadding: DesignSystem.Spacing.medium,
            bottomPadding: DesignSystem.Spacing.large,
            topPaddingForGradient: DesignSystem.GradientHeight.tall,
            respectsBottomSafeArea: true
        )
    }
}

// MARK: - Background
public extension PhotoCaptionOverlay {
    private static var backgroundGradient: LinearGradient {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0),
                .init(color: .black.opacity(DesignSystem.Opacity.gradientMiddle), location: 0.45),
                .init(color: .black.opacity(DesignSystem.Opacity.gradientBottom), location: 1)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}
