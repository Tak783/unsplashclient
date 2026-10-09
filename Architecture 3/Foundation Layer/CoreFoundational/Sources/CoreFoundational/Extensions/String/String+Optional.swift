//
//  String+Optional.swift
//
//
//  Created  14/12/2023.
//

import Foundation

extension Swift.Optional where Wrapped == String {
    public var isEmptyOrNil: Bool {
        if self == Optional.none {
            return true
        }
        if let value = self {
            return value.isEmpty
        }
        return false
    }
}
