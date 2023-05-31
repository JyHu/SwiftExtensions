//
//  File.swift
//  
//
//  Created by Jo on 2023/5/31.
//

import Foundation

///
///
///
/// 将一个数值转换为压缩模式，
/// 如： 40000可以转换为英文下的40K或者中文下的4万，
/// 需要什么级别的压缩和单位都可以根据自己需要传入
///
///
///

public extension Double {
    func compress(step: Int = 3, units: [String] = ["K", "M", "B", "T"]) -> String {
        for enuInd in 0 ..< units.count {
            let index = units.count - enuInd
            let compressedValue = self / pow(10, Double(step * index))

            if compressedValue > 1 {
                return String(format: "%.2f%@", arguments: [compressedValue, units[index - 1]])
            }
        }
        
        return "\(self)"
    }
}

public extension BinaryInteger {
    func compress(step: Int = 3, units: [String] = ["K", "M", "B", "T"]) -> String {
        return Double(self).compress(step: step, units: units)
    }
}
