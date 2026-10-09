//
//  DateFormatter+Extensions.swift
//  Goats
//
//  Created  18/03/2023.
//

import Foundation

extension DateFormatter {
    public static let isoDateTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter
    }()
}
