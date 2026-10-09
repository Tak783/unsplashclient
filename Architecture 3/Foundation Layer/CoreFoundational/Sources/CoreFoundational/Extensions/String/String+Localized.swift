//
//  String+Localized.swift
//  CoreBreakfree
//
//  Created  15/05/2025.
//

import Foundation

extension String {
    public var localized: String {
        NSLocalizedString(self, comment: "")
    }
}
