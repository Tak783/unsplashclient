//
//  NSObject+Extensions.swift
//  Core
//
//  Created on 14/04/2021.
//

import Foundation

extension NSObject {
    public var className: String {
        return "\(type(of: self))"
    }
    
    public static var className: String {
        return "\(self)"
    }
}
