//
//  File.swift
//  
//
//  Created by Jo on 2023/12/27.
//

import Foundation

public extension NSRange {
    var upper: Int {
        return location + length
    }
}
