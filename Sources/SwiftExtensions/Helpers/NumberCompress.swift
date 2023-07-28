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

///
/// 英文单位：
/// K (千): 1000 (thousand)
/// M (百万): 1000K (million)
/// B (十亿): 1000M (billion)
/// T (兆): 1000B (trillion)
/// Q (千兆): 1000T (quadrillion)
/// Quint (百兆): 1000Q (quintillion)
/// Sext (千百兆): 1000Quint (sextillion)
/// Sept (千千兆): 1000Sext (septillion)
/// Oct (百千兆): 1000Sept (octillion)
/// Non (千百千兆): 1000Oct (nonillion)
/// Dec (百千千兆): 1000Non (decillion)
/// Undec (千百千千兆): 1000Dec (undecillion)
/// Duodec (千千百千千兆): 1000Undec (duodecillion)
/// Tredec (百千千百千千兆): 1000Duodec (tredecillion)
///
/// 中文单位：
/// 1兆 = 10000亿
/// 1京 = 10000兆
/// 1垓 = 10000京
/// 1秭 = 10000垓
/// 1穰 = 10000秭
/// 1溝 = 10000穰
/// 1澗 = 10000溝
/// 1正 = 10000澗

public extension Double {
    enum Language {
        case english
        case chinese
    }
    
    func compress(step: Int = 3, units: [String] = englishUnits) -> String {
        for enuInd in 0 ..< units.count {
            let index = units.count - enuInd
            let compressedValue = self / pow(10, Double(step * index))

            if compressedValue > 1 {
                return String(format: "%.2f%@", arguments: [compressedValue, units[index - 1]])
            }
        }
        
        return "\(self)"
    }
    
    func compress(using language: Language) -> String {
        switch language {
        case .english: return compress(step: 3, units: Double.englishUnits)
        case .chinese: return compress(step: 4, units: Double.chineseUnits)
        }
    }
}

public extension BinaryInteger {
    func compress(step: Int = 3, units: [String] = ["K", "M", "B", "T"]) -> String {
        return Double(self).compress(step: step, units: units)
    }
    
    func compress(using language: Double.Language) -> String {
        return Double(self).compress(using: language)
    }
}

public extension Double {
    static let englishUnits = [
        "K",        /// (千): 1000 (thousand)
        "M",        /// (百万): 1000K (million)
        "B",        /// (十亿): 1000M (billion)
        "T",        /// (兆): 1000B (trillion)
        "Q",        /// (千兆): 1000T (quadrillion)
        "Quint",    /// (百兆): 1000Q (quintillion)
        "Sext",     /// (千百兆): 1000Quint (sextillion)
        "Sept",     /// (千千兆): 1000Sext (septillion)
        "Oct",      /// (百千兆): 1000Sept (octillion)
        "Non",      /// (千百千兆): 1000Oct (nonillion)
        "Dec",      /// (百千千兆): 1000Non (decillion)
        "Undec",    /// (千百千千兆): 1000Dec (undecillion)
        "Duodec",   /// (千千百千千兆): 1000Undec (duodecillion)
        "Tredec",   /// (百千千百千千兆): 1000Duodec (tredecillion)
    ]
    
    static let chineseUnits = [
        "万", /// 10000
        "亿", /// 10000万
        "兆", /// 10000亿
        "京", /// 10000兆
        "垓", /// 10000京
        "秭", /// 10000垓
        "穰", /// 10000秭
        "溝", /// 10000穰
        "澗", /// 10000溝
        "正", /// 10000澗
    ]
}
