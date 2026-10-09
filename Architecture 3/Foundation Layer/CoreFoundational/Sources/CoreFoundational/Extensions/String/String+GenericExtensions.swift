//
//  String+GenericExtensions.swift
//  
//
//  Created  20/03/2023.
//

import Foundation
import os

extension String {
    public func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                os_log("%@", error.localizedDescription)
            }
        }
        return nil
    }
    
    public func convertJsonStringToData() -> Data? {
        guard let jsonData = self.data(using: .utf8) else {
            print("Failed to convert string to data")
            return nil
        }
        
        return jsonData
    }
    
    public var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
    
    public func removeCommas() -> String {
        replacingOccurrences(of: String.comma, with: String.space)
    }
    
    public func removeNewLine() -> String {
        replacingOccurrences(of: String.newLine, with: String.empty)
    }
    
    public func sanitizeString() -> String {
        self.replacingOccurrences(of: "\n", with: " ")
            .replacingOccurrences(of: "\r", with: " ")
    }

    public func firstAndLastnameSplitByFirstSpace() -> (String, String)? {
        guard let spaceRange = self.range(of: String.space) else {
            return nil // No space found
        }

        let firstPart = String(self[..<spaceRange.lowerBound])
        let secondPart = String(self[spaceRange.upperBound...])

        return (firstPart, secondPart)
    }
    
    public func isValidEmail() -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    public func capitalizeFirstLetter() -> String {
        guard !self.isEmpty else { return self }
        return self.prefix(1).uppercased() + self.dropFirst()
    }
}
