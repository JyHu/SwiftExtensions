//
//  File.swift
//  
//
//  Created by Jo on 2023/4/20.
//

import Foundation

public extension Comparable {
    ///
    /// 返回一个一定在val1～val2之间的数值，如果当前值在给定的最大最小值外，那么会就近返回最大或者最小值
    /// 
    func clamp(val1: Self, val2: Self) -> Self {
        if val1 == val2 {
            return val1
        }
        
        let maxVal = max(val1, val2)
        let minVal = min(val1, val2)
        
        if self > maxVal { return maxVal }
        if self < minVal { return minVal }
        return self
    }
}
