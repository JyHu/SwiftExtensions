//
//  File.swift
//  
//
//  Created by hujinyou on 2024/9/25.
//

import Foundation

public extension RawRepresentable {
    /// Initializes an instance of the conforming type from a raw value.
    /// - Parameter anyValue: The raw value to initialize from.
    /// - Returns: An optional instance of the conforming type, or nil if initialization fails.
    init?(anyValue: Any?) {
        if let anyValue = anyValue as? RawValue {
            self.init(rawValue: anyValue)
        } else {
            return nil
        }
    }
}
