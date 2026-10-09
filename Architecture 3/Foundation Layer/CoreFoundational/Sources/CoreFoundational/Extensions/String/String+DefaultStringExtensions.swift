//
//  String+DefaultStringExtensions.swift
//
//
//  Created  19/03/2023.
//

import Foundation

extension String {
    public static let empty = String.init()
    public static let dash = "-"
    public static let forwardSlash = "/"
    public static let newLine = "\n"
    public static let comma = ","
    public static let dot = "."
    public static let space = " "
    public static let commaAndSpace = ", "
    public static let unknown = "unknown"
    public static let error = "error"
    public static let ok = "Ok"
    public static let standardDefault = "default"
}

extension String {
    public var stringByRemovingWhitespaces: String {
        replacingOccurrences(of: String.empty, with: String.empty)
    }
}

extension String {
    public var containsWhitespace: Bool {
        return(self.rangeOfCharacter(from: .whitespacesAndNewlines) != nil)
    }
}

extension String {
    public var containsSpecialChracters: Bool {
        return stringByRemovingWhitespaces.range(of: ".*[^A-Za-z0-9].*", options: .regularExpression) != nil
    }
    
    /// Include only digits, decimal point, and negative sign/
    public func removingSpecialCharactersFromNumber() -> String {
        return self.filter { "0123456789.-".contains($0) }
    }
}
