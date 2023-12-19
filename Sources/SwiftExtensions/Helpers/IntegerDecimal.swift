//
//  File.swift
//  
//
//  Created by Jo on 2023/12/19.
//

import Foundation

/// 使用数据结构来做浮点数值的存储
public struct IntegerDecimal: CustomStringConvertible {
    /// 转换异常
    enum Err: Error {
        case notANumber
        case tooLong
    }
    
    /// 偏移后的整数值
    public var value: UInt
    /// 偏移的小数位数
    public var offset: Int
    /// 是否是负数
    public var isNegative: Bool = false
    
    public var description: String {
        return "IntegerDecimal(value: \(value), offset: \(offset), isNegative: \(isNegative))"
    }
    
    public init(value: UInt, offset: Int, isNegative: Bool = false) {
        self.value = value
        self.offset = offset
        self.isNegative = isNegative
    }
    
    public init(doubleValue: Double, maxDecimals: Int) throws {
        try self.init(numberString: String(format: "%.\(maxDecimals)f", doubleValue))
    }
    
    public init(numberString: String) throws {
        /// 转换的必须为有效数值
        guard numberString.isLegalNumber else { throw Err.notANumber }
        
        /// 如果带有 - 说明是负数
        let isNegative = numberString.hasPrefix("-")
        /// 截取有效的数值
        let purlNum = isNegative ? String(numberString.dropFirst()) : numberString
        
        /// 从前往后遍历移除0
        var startIndex: Int = 0
        while startIndex < purlNum.count {
            if purlNum[purlNum.index(purlNum.startIndex, offsetBy: startIndex)] == "0" {
                startIndex += 1
            } else {
                break
            }
        }
        
        /// 从后往前遍历移除0
        var endIndex: Int = purlNum.count - 1
        while endIndex > startIndex {
            if purlNum[purlNum.index(purlNum.startIndex, offsetBy: endIndex)] == "0" {
                endIndex -= 1
            } else {
                break
            }
        }
        
        /// 如果前后位置都相等，那么说明这个数全部都是0，那么也就是0
        if startIndex == endIndex {
            self.value = 0
            self.offset = 0
        } else {
            /// 截取中间有效数值部分
            guard let trimmedNum = purlNum[startIndex...endIndex] else { throw Err.notANumber }
            
            /// 如果为 . ，说明是一个0值，表示为小数的形式
            if trimmedNum == "." {
                self.value = 0
                self.offset = 0
            } else {
                /// 转换为NSString，方便处理
                let nsstring = NSString(string: trimmedNum)
                
                /// 获取小数点位置
                let range = nsstring.range(of: ".")
                
                /// 如果没有小数点，说明为一个整数，直接转换即可
                if range.location == NSNotFound {
                    guard trimmedNum.count < 19 else { throw Err.tooLong }
                    guard let intValue = UInt(trimmedNum) else { throw Err.tooLong }
                    self.value = intValue
                    self.offset = 0
                } else {
                    guard trimmedNum.count < 20 else { throw Err.tooLong }
                    let finalNum = trimmedNum.replacingOccurrences(of: ".", with: "")
                    guard let intValue = UInt(finalNum) else { throw Err.tooLong }
                    
                    self.value = intValue
                    self.offset = trimmedNum.count - range.location - 1
                }
            }
        }
        
        self.isNegative = isNegative
    }
}
