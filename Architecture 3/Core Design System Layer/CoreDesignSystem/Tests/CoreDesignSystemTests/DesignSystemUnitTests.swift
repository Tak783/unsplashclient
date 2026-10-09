//
//  DesignSystemUnitTests.swift
//  CoreDesignSystemTests
//
//  Created on 09/10/2026.
//

@testable import CoreDesignSystem
import Testing

@Suite
struct DesignSystemUnitTests {}

// MARK: - DesignSystemUnitTestsSpec
extension DesignSystemUnitTests: DesignSystemUnitTestsSpec {
    @Test("the spacing scale never goes backwards")
    func test_spacing_stepsUpInTheExpectedOrder() {
        let scale = [
            DesignSystem.Spacing.extraSmall,
            DesignSystem.Spacing.small,
            DesignSystem.Spacing.medium,
            DesignSystem.Spacing.large
        ]

        #expect(scale == scale.sorted())
        #expect(DesignSystem.GradientHeight.short < DesignSystem.GradientHeight.tall)
    }

    @Test(
        "every opacity is a usable fraction",
        arguments: [
            DesignSystem.Opacity.placeholderFill,
            DesignSystem.Opacity.buttonBackground,
            DesignSystem.Opacity.gradientMiddle,
            DesignSystem.Opacity.gradientBottom
        ]
    )
    func test_opacity_staysWithinZeroAndOne(opacity: Double) {
        #expect(opacity > 0)
        #expect(opacity <= 1)
    }

    @Test("the close button is smaller than the bar it is centred against")
    func test_closeButton_fitsInsideTheNavigationBar() {
        #expect(DesignSystem.Size.closeButton < DesignSystem.Size.navigationBar)
    }
}
