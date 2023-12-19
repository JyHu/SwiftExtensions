//
//  File.swift
//  
//
//  Created by Jo on 2023/12/9.
//

import Foundation

private let __intToChinese: [UInt: String] = [
    1: "壹",
    2: "贰",
    3: "叁",
    4: "肆",
    5: "伍",
    6: "陆",
    7: "柒",
    8: "捌",
    9: "玖"
]

private let __chineseUnits = [
    "",
    "万",
    "亿",
    "兆",
    "京"
]

private extension UInt {
    func toChinese() throws -> String? {
        if self == 0 { return nil }
        if let numWord = __intToChinese[self] { return numWord }
        
        var result: String = ""
        var hasZero: Bool = false
        
        let val1000 = self / 1000
        if val1000 != 0 {
            let numChn = try __intToChinese.__val(for: val1000)
            result.append(numChn + "仟")
        }
        
        let val100 = (self / 100) % 10
        if val100 == 0 {
            hasZero = !result.isEmpty
        } else {
            let numChn = try __intToChinese.__val(for: val100)
            result.append(numChn + "佰")
        }
        
        let val10 = (self / 10) % 10
        if val10 == 0 {
            if !hasZero {
                hasZero = !result.isEmpty
            }
        } else {
            let numChn = try __intToChinese.__val(for: val10)
            if hasZero {
                result.append("零" + numChn + "拾")
            } else {
                result.append(numChn + "拾")
            }
            
            hasZero = false
        }
        
        let val1 = self % 10
        if val1 != 0 {
            let numChn = try __intToChinese.__val(for: val1)
            if hasZero {
                result.append("零")
            }
            
            result.append(numChn)
        }
        
        return result
    }
    
    func toChineseDecimal() throws -> (Bool, String) {
        if self < 10 {
            let numChn = try __intToChinese.__val(for: self)
            return (true, "\(numChn)分")
        }
        
        var result: String = ""
        
        let num10 = self / 10
        if num10 > 0 {
            let numChn = try __intToChinese.__val(for: num10)
            result.append("\(numChn)角")
        }
        
        let num1 = self % 10
        if num1 > 0 {
            let numChn = try __intToChinese.__val(for: num1)
            result.append("\(numChn)分")
        }
        
        return (false, result)
    }
}

internal extension MoneyDecimal {
    /// 将金额转换为展示的中文大写
    /// - Parameter allowsZero: 在出现连续的0时，是否需要在转换后的内容也带上“零”
    /// - Returns: 转换后的大写金额
    func convertToChinaMoney(allowsZero: Bool = true) throws -> String? {
        if integer == 0 && decimal == 0 { return nil }
        
        func positiveString() throws -> String {
            if integer == 0 {
                return "零元"
            }
            
            let intParts = toIntParts(4)
            var hasZero: Bool = false
            var result: String = ""
            
            for (index, intPart) in intParts.enumerated() {
                let unit = __chineseUnits[intParts.count - index - 1]
                guard let chnNum = try intPart.toChinese() else { return result }
                if index > 0 && intPart / 1000 == 0 {
                    hasZero = true
                }
                
                if hasZero && allowsZero {
                    result.append("零")
                }
                
                result.append(chnNum + unit)
                
                hasZero = false
            }
            
            result.append("元")
            
            return result
        }
        
        var result: String = ""
        result.append(try positiveString())
        
        if decimal > 0 {
            let (decimalSpacing, decimalString) = try decimal.toChineseDecimal()
            
            if allowsZero {
                if integer > 0 {
                    if integer % 10 == 0 || decimalSpacing {
                        result.append("零")
                    }
                } else {
                    if decimalSpacing {
                        result.append("零")
                    }
                }
            }
            
            result.append(decimalString)
        } else {
            result.append("整")
        }
        
        return result
    }
}
