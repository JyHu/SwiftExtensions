//
//  File.swift
//  
//
//  Created by Jo on 2023/4/20.
//

import Foundation

public extension Comparable {
    func clamp(low: Self, high: Self) -> Self {
        if self > high { return high }
        if self < low { return low }
        return self
    }
}
