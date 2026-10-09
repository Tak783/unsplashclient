//
//  DesignSystemUnitTestsSpec.swift
//  CoreDesignSystem
//
//  Created on 09/10/2026.
//

protocol DesignSystemUnitTestsSpec {
    func test_spacing_stepsUpInTheExpectedOrder()
    func test_opacity_staysWithinZeroAndOne(opacity: Double)
    func test_closeButton_fitsInsideTheNavigationBar()
}
