//
//  File.swift
//  
//
//  Created by hujinyou on 2024/9/25.
//

import Foundation

public extension RawRepresentable {
    init?(anyValue: Any?) {
        if let anyValue = anyValue as? RawValue {
            self.init(rawValue: anyValue)
        } else {
            return nil
        }
    }
}
