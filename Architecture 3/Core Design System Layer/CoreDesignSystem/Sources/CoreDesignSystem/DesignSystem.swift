//
//  DesignSystem.swift
//  CoreDesignSystem
//
//  Created on 09/10/2026.
//

import CoreGraphics

public enum DesignSystem {}

// MARK: - Spacing
public extension DesignSystem {
    enum Spacing {
        public static let extraSmall: CGFloat = 6
        public static let small: CGFloat = 16
        public static let medium: CGFloat = 20
        public static let large: CGFloat = 24
    }
}

// MARK: - Gradient Height
public extension DesignSystem {
    enum GradientHeight {
        public static let short: CGFloat = 30
        public static let tall: CGFloat = 72
    }
}

// MARK: - Size
public extension DesignSystem {
    enum Size {
        public static let closeButton: CGFloat = 36
        public static let navigationBar: CGFloat = 44
    }
}

// MARK: - Opacity
public extension DesignSystem {
    enum Opacity {
        public static let placeholderFill = 0.15
        public static let buttonBackground = 0.35
        public static let gradientMiddle = 0.55
        public static let gradientBottom = 0.95
    }
}

// MARK: - Animation Duration
public extension DesignSystem {
    enum AnimationDuration {
        public static let imageFadeInInSeconds = 0.15
    }
}
