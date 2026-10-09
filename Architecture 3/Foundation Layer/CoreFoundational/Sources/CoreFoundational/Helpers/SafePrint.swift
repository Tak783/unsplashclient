//
//  SafePrint.swift
//  
//
//  Created  19/03/2023.
//

import Foundation

public func safePrint(_ anything: Any) {
    #if DEBUG
        print(anything)
    #endif
}

public func safePrint(_ anything: Any...) {
    #if DEBUG
        print(anything)
    #endif
}
