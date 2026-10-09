//
//  NSObject+Extensions.swift
//  Core
//
//  Created by Takomborerwa Mazarura on 14/04/2021.
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
