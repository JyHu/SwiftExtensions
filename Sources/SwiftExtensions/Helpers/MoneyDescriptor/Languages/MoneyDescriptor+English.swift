//
//  File.swift
//  
//
//  Created by Jo on 2023/12/9.
//

import Foundation

private let __intToEnglish: [UInt: String] = [
    1: "ONE",
    2: "TWO",
    3: "THREE",
    4: "FOUR",
    5: "FIVE",
    6: "SIX",
    7: "SEVEN",
    8: "EIGHT",
    9: "NINE",
    10: "TEN",
    11: "ELEVEN",
    12: "TWELVE",
    13: "THIRTEEN",
    14: "FOURTEEN",
    15: "FIFTEEN",
    16: "SIXTEEN",
    17: "SEVENTEEN",
    18: "EIGHTEEN",
    19: "NINETEEN",
    20: "TWENTY",
    30: "THIRTY",
    40: "FORTY",
    50: "FIFTY",
    60: "SIXTY",
    70: "SEVENTY",
    80: "EIGHTY",
    90: "NINETY"
]

private let __englishUnits: [String] = [
    "",
    "THOUSAND",
    "MILLION",
    "BILLION",
    "TRILLION",
    "QUADRILLION"
]

private extension UInt {
    func toEnglish() throws -> String? {
        if self == 0 { return nil }
        if let numWord = __intToEnglish[self] { return numWord }
        
        if self < 100 {
            let unit = self % 10
            let tens = (self / 10) * 10
            
            let tensStr = try __intToEnglish.__val(for: tens)
            let unitStr = try __intToEnglish.__val(for: unit)
            
            return "\(tensStr)-\(unitStr)"
        }
        
        let hudStr = try __intToEnglish.__val(for: self / 100)
        
        if let under100Str = try (self % 100).toEnglish() {
            return "\(hudStr) HUNDRED AND \(under100Str)"
        }
        
        return "\(hudStr) HUNDRED"
    }
}

internal extension MoneyDecimal {
    /// 将金额转换为展示的字符串
    /// - Parameter style: 展示内容的格式
    /// - Returns: 格式化后的金额
    func convertToEnglishMoney(style: Language.EnglishStyle = .cents) throws -> String? {
        if integer == 0 && decimal == 0 { return nil }
        
        if integer == 0 {
            guard let decimalStr = try decimal.toEnglish() else { return nil }
            
            switch style {
            case .cents: return "CENTS \(decimalStr)"
            case .point: return "POINT \(decimalStr)"
            case .percent: return "\(decimalStr) \(decimal)/100"
            }
        }
        
        let intStr = try toIntParts(3).reversed().enumerated().compactMap { (index, num) in
            if num == 0 { return nil }
            
            guard let engStr = try num.toEnglish() else { return nil }
            
            if index == 0 { return engStr }
            
            return "\(engStr) \(__englishUnits[index])"
        }.reversed().joined(separator: ", ")
        
        guard let decimalStr = try decimal.toEnglish() else {
            return "\(intStr) ONLY"
        }
        
        switch style {
        case .cents: return "\(intStr) DOLLARS AND CENTS \(decimalStr)"
        case .point: return "\(intStr) DOLLARS AND POINT \(decimalStr)"
        case .percent: return "\(intStr) DOLLARS AND \(decimalStr) \(decimal)/100"
        }
    }
}
