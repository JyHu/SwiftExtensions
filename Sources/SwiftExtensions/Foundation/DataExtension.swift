//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension Data {
    
    /// Convert data to bytes array
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}

#endif
