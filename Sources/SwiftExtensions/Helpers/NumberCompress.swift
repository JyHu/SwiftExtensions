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
/// 万（W）： 表示万，即10^4，例如： 一万（10,000）
/// 亿（Y）： 表示亿，即10^8，例如： 一亿（100,000,000）
/// 兆（Z）： 表示兆，即10^12，例如： 一兆（1,000,000,000,000）
/// 京（J）： 表示京，即10^16，例如： 一京（10,000,000,000,000,000）
/// 垓（G）： 表示垓，即10^20
/// 秭（Zi）： 表示秭，即10^24
/// 穰（Rang）： 表示穰，即10^28
/// 沟（Gou）： 表示沟，即10^32
/// 涧（Jian）： 表示涧，即10^36
/// 正（Zheng）： 表示正，即10^40
/// 载（Zai）： 表示载，即10^44
/// 极（Ji）： 表示极，即10^48

public extension Double {
    /// 需要转换的语言，不同的语言单位不同
    enum Language {
        /// 英文格式
        case english
        
        /// 中文格式，4位长度，比如万、亿等
        case chinese
        
        /// 中文格式，3位长度，跟英文格式匹配，如千、百万、十亿等
        case chinese3
    }
    
    /// 将当前数值压缩展示
    ///
    /// - Description: 根据给定的单位列表和步长来压缩显示的数值。
    ///       比如对于中文的万、亿等单位，步长为4
    ///       对于英文中的 K、M、B 等单位，步长为3
    ///       也可以根据需要自定义步长和单位，比如自定义单位为 A、B、C、D，步长为3，
    ///       那么将数值压缩后，就会以给定的参数显示，比如1234567890，保留2位小数后压缩展示为 1.23C，
    ///
    /// - Warning: 这里有一点需要注意，如果给定的单位列表不足以满足最大的数字位，那么会以最大的单位来压缩。
    ///       比如单位列表为 [K, M, B]，步长为3，但是给定的数值很大，如1 234 567 890 123，这个数
    ///       会需要5个单位级数，但是给定的单位只有3个，那么压缩后就只会压缩到最大的单位 B ，压缩
    ///       后的结果就是 1234.58B。
    ///
    /// - Parameters:
    ///   - step: 针对于给定单位列表的步长
    ///   - units: 缩写单位
    ///   - decimals: 保留小数位数
    /// - Returns: 压缩展示的字符串内容
    func compress(step: Int = 3, units: [String], decimals: Int = 2) -> String {
        for enuInd in 0 ..< units.count {
            let index = units.count - enuInd
            let compressedValue = self / pow(10, Double(step * index))

            if compressedValue >= 1 {
                return String(format: "%.\(decimals)f%@", arguments: [compressedValue, units[index - 1]])
            }
        }
        
        return "\(self)"
    }
    
    /// 按照预设的语言类型对当前数值做压缩展示操作
    /// - Parameters:
    ///   - language: 需要使用的单位对应的语言类型
    ///   - decimals: 保留的小数位数
    /// - Returns: 压缩后的展示字符串内容
    func compress(using language: Language, decimals: Int = 2) -> String {
        switch language {
        case .english: return compress(step: 3, units: Double.englishUnits, decimals: decimals)
        case .chinese: return compress(step: 4, units: Double.chineseUnits, decimals: decimals)
        case .chinese3: return compress(step: 3, units: Double.chinese3Units, decimals: decimals)
        }
    }
}

public extension BinaryInteger {
    /// 同 Double.compress
    func compress(step: Int = 3, units: [String] = ["K", "M", "B", "T"], decimals: Int) -> String {
        return Double(self).compress(step: step, units: units, decimals: decimals)
    }
    
    /// 同 Double.compress
    func compress(using language: Double.Language, decimals: Int = 2) -> String {
        return Double(self).compress(using: language, decimals: decimals)
    }
}

fileprivate extension Double {
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
        "沟", /// 10000穰
        "涧", /// 10000溝
        "正", /// 10000澗
        "载",
        "极"
    ]
    
    static let chinese3Units = [
        "千", /// 10000
        "百万", /// 10000万
        "十亿", /// 10000亿
        "兆", /// 10000亿
        "千兆", /// 10000亿
        "百京", /// 10000兆
        "十垓", /// 10000京
        "秭", /// 10000垓
        "千秭", /// 10000垓
        "百穰", /// 10000秭
        "十沟", /// 10000穰
        "涧", /// 10000溝
        "千涧", /// 10000澗
        "百正", /// 10000澗
        "十载",
        "极",
        "千极"
    ]
}
