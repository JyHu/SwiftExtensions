//
//  File.swift
//  
//
//  Created by Jo on 2023/5/31.
//

import Foundation


/// http://www.xiaoniutxt.com/usDollarsConvert.html
/// 英文金额大写转换器,英文数字大写,英文金额大写规则,英文数字大写翻译,英文大写金额
/// 如果金额里面有小数，英文金额大写有3种表达方式:美分,美点,分数
/// 美分表达：小数点用CENTS表示，如USD888.88用美分表示为 SAY US DOLLARS EIGHT HUNDRED AND EIGHTY-EIGHT AND CENTS EIGHTY-EIGHT ONLY
/// 美点表达：小数点用POINT表示，如USD888.88用美点表示为 SAY US DOLLARS EIGHT HUNDRED AND EIGHTY-EIGHT AND POINT EIGHTY-EIGHT ONLY
/// 分数表达：就是把小数点后面的两位数字按百分比书写，如USD888.88转换到分数是: SAY US DOLLARS EIGHT HUNDRED AND EIGHTY-EIGHT AND EIGHTY-EIGHT 88/100 ONLY


/// http://www.xiaoniutxt.com/RMBConvert.html
/// 中文大写数字历史渊源
/// 大写数字的使用始于明朝。朱元璋因为当时的一件重大贪污案“郭桓案”而发布法令，其中明确要求记账的数字必须由“一、二、三、四、五、六、七、八、九、十、百、千”改为“壹、贰、叁、肆、伍、陆、柒、捌、玖、拾、佰（陌）、仟（阡）”等复杂的汉字，用以增加涂改帐册的难度。后来“陌”和“阡”被改写成“佰、仟”，并一直使用到现在。
/// 人民币大写数字注意事项
/// 中文大写金额数字应用正楷或行书填写，如壹(壹)、贰(贰)、叁、肆(肆)、伍(伍)、陆(陆)、柒、捌、玖、拾、佰、仟、万(万)、亿、元、角、分、零、整(正)等字样。不得用一、二(两)、三、四、五、六、七、八、九、十、念、毛、另(或0)填写，不得自造简化字。如果金额数字书写中使用繁体字，如贰、陆、亿、万、圆的，也应受理。
/// 一、中文大写金额数字到"元"为止的，在"元"之后，应写"整"(或"正")字，在"角"之后，可以不写"整"(或"正")字。大写金额数字有"分"的，"分"后面不写"整"(或"正")字。
/// 二、中文大写金额数字前应标明"人民币"字样，大写金额数字有"分"的，"分"后面不写"整"(或"正")字。
/// 三、中文大写金额数字前应标明"人民币"字样，大写金额数字应紧接"人民币"字样填写，不得留有空白。大写金额数字前未印"人民币"字样的，应加填"人民币"三字。在票据和结算凭证大写金额栏内不得预印固定的"仟、佰、拾、万、仟、佰、拾、元、角、分"字样。
/// 四、阿拉伯数字小写金额数字中有"0"时，中文大写应按照汉语语言规律、金额数字构成和防止涂改的要求进行书写。举例如下：
/// 1·阿拉伯数字中间有"0"时，中文大写要写"零"字，如￥1409.50，应写成人民币陆壹仟肆佰零玖元伍角。
/// 2·阿拉伯数字中间连续有几个"0"时，中文大写金额中间可以只写一个"零"字，如￥6007.14，应写成人民币陆仟零柒元壹角肆分。
/// 3·阿拉伯金额数字万位和元位是"0"，或者数字中间连续有几个"0"，万位、元位也是"0"，但千位、角位不是"0"时，中文大写金额中可以只写一个零字，也可以不写"零"字。如￥1680.32，应写成人民币壹仟陆佰捌拾元零叁角贰分，或者写成人民币壹仟陆佰捌拾元叁角贰分，又如￥107000.53，应写成人民币壹拾万柒仟元零伍角叁分，或者写成人民币壹拾万零柒仟元伍角叁分。
/// 4·阿拉伯金额数字角位是"0"，而分位不是"0"时，中文大写金额"元"后面应写"零"字。如￥16409.02，应写成人民币壹万陆仟肆佰零玖元零贰分；又如￥325.04，应写成人民币叁佰贰拾伍元零肆分。
/// 数字来历
/// 人类最早用来计数的工具是手指和脚趾，但它们只能表示20以内的数字。当数目很多时，大多数的原始人就用小石子来记数。渐渐地，人们又发明了打绳结来记数的方法，或者在兽皮、树木、石头上刻画记数。中国古代是用木、竹或骨头制成的小棍来记数，称为算筹。这些记数方法和记数符号慢慢转变成了最早的数字符号（数码）。如今，世界各国都使用阿拉伯数字为标准数字。

public extension Double {
    /// 将金额转换为展示的字符串
    /// - Parameter language: 需要转换到的语言
    /// - Returns: 转换的结果
    func amountInWords(_ language: MoneyDecimal.Language) throws -> String? {
        return try MoneyDecimal(money: self).amountInWords(language)
    }
}

public struct MoneyDecimal {
    public enum DError: Error {
        /// 无法转换为有效数值
        case invalidMoneyString
        /// 数值过大，最大支持不超过1e18
        case excessive
    }
    
    /// 金额的整数部分，最大不超过1e18
    public private(set) var integer: UInt = 0
    /// 金额的小数部分，默认只到分，即2位
    public private(set) var decimal: UInt = 0
    /// 金额字符串，格式化后的2位小数的金额
    public private(set) var moneyString: String
    
    /// 初始化方法
    /// - Parameter money: 需要转换的金额数值
    public init(money: Double) throws {
        guard money >= 0 && money < 1e18 else { throw DError.excessive }
        
        /// 先向下取整
        let floorValue = floor(money)
        /// 转换整数部分
        integer = UInt(floorValue)
        /// 四舍五入获取整数部分
        decimal = UInt(round((money - floorValue) * 100))
        
        moneyString = String(format: "%.2f", money)
    }
    
    /// 初始化方法
    /// - Parameters:
    ///   - integer: 金额的整数部分
    ///   - decimal: 金额的小数部分
    public init(integer: UInt, decimal: UInt = 0) {
        self.integer = integer
        self.decimal = decimal
        
        if decimal == 0 {
            self.moneyString = String(describing: integer)
        } else {
            self.moneyString = String(format: "\(integer)%02d", decimal)
        }
    }
    
    /// 初始化方法
    /// - Parameter moneyString: 需要转换的金额字符串
    public init(moneyString: String) throws {
        guard let doubleMoney = Double(moneyString) else {
            throw DError.invalidMoneyString
        }
        
        try self.init(money: doubleMoney)
    }
}

private extension MoneyDecimal {
    func dividen(_ perLength: UInt) -> UInt {
        if perLength == 2 { return 100 }
        if perLength == 3 { return 1000 }
        if perLength == 4 { return 10000 }
        if perLength == 5 { return 100000 }
        fatalError()
    }
    
    /// 按一定的数量级来拆分数值，比如美元是千进制，中文是万进制，把13600000001可以拆分成
    /// 中文：[136, 0, 1]
    /// 英文：[13, 600, 0, 1]
    func toIntParts(_ perLength: UInt) -> [UInt] {
        if integer == 0 { return [] }
        
        var num = integer
        var results: [UInt] = []
        while num > 0 {
            let part = num % dividen(perLength)
            results.insert(part, at: 0)
            num = num / dividen(perLength)
        }
        
        return results
    }
}

private struct __MoneyUnits {
    static let intToEnglish: [UInt: String] = [
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

    static let englishUnits = [
        "",
        "THOUSAND",
        "MILLION",
        "BILLION",
        "TRILLION",
        "QUADRILLION"
    ]

    static let intToChinese: [UInt: String] = [
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

    static let chineseUnits = [
        "",
        "万",
        "亿",
        "兆",
        "京"
    ]
}

private extension UInt {
    func toEnglish() throws -> String? {
        if self == 0 { return nil }
        if let numWord = __MoneyUnits.intToEnglish[self] { return numWord }
        
        if self < 100 {
            let unit = self % 10
            let tens = (self / 10) * 10
            
            let tensStr = try __MoneyUnits.intToEnglish.__val(for: tens)
            let unitStr = try __MoneyUnits.intToEnglish.__val(for: unit)
            
            return "\(tensStr)-\(unitStr)"
        }
        
        let hudStr = try __MoneyUnits.intToEnglish.__val(for: self / 100)
        
        if let under100Str = try (self % 100).toEnglish() {
            return "\(hudStr) HUNDRED AND \(under100Str)"
        }
        
        return "\(hudStr) HUNDRED"
    }
    
    func toChinese() throws -> String? {
        if self == 0 { return nil }
        if let numWord = __MoneyUnits.intToChinese[self] { return numWord }
        
        var result: String = ""
        var hasZero: Bool = false
        
        let val1000 = self / 1000
        if val1000 != 0 {
            let numChn = try __MoneyUnits.intToChinese.__val(for: val1000)
            result.append(numChn + "仟")
        }
        
        let val100 = (self / 100) % 10
        if val100 == 0 {
            hasZero = !result.isEmpty
        } else {
            let numChn = try __MoneyUnits.intToChinese.__val(for: val100)
            result.append(numChn + "佰")
        }
        
        let val10 = (self / 10) % 10
        if val10 == 0 {
            if !hasZero {
                hasZero = !result.isEmpty
            }
        } else {
            let numChn = try __MoneyUnits.intToChinese.__val(for: val10)
            if hasZero {
                result.append("零" + numChn + "拾")
            } else {
                result.append(numChn + "拾")
            }
            
            hasZero = false
        }
        
        let val1 = self % 10
        if val1 != 0 {
            let numChn = try __MoneyUnits.intToChinese.__val(for: val1)
            if hasZero {
                result.append("零")
            }
            
            result.append(numChn)
        }
        
        return result
    }
    
    func toChineseDecimal() throws -> (Bool, String) {
        if self < 10 {
            let numChn = try __MoneyUnits.intToChinese.__val(for: self)
            return (true, "\(numChn)分")
        }
        
        var result: String = ""
        
        let num10 = self / 10
        if num10 > 0 {
            let numChn = try __MoneyUnits.intToChinese.__val(for: num10)
            result.append("\(numChn)角")
        }
        
        let num1 = self % 10
        if num1 > 0 {
            let numChn = try __MoneyUnits.intToChinese.__val(for: num1)
            result.append("\(numChn)分")
        }
        
        return (false, result)
    }
}

public extension MoneyDecimal {
    enum Language {
        /// 转换为英文时的格式
        public enum EnglishStyle {
            /// 美分
            case cents
            /// 美点
            case point
            /// 分数
            case percent
        }
        
        /// 中文
        case chinese(allowsZero: Bool = true)
        /// 英文
        case english(style: EnglishStyle = .cents)
    }
    
    func amountInWords(_ language: Language) throws -> String? {
        switch language {
        case .chinese(let allowsZero): return try convertToChinaMoney(allowsZero: allowsZero)
        case .english(let style): return try convertToEnglishMoney(style: style)
        }
    }
}

private extension MoneyDecimal {
    /// 将金额转换为展示的字符串
    /// - Parameter style: 展示内容的格式
    /// - Returns: 格式化后的金额
    func convertToEnglishMoney(style: Language.EnglishStyle = .cents) throws -> String? {
        if integer == 0 && decimal == 0 { return nil }
        
        if integer == 0 {
            guard let decimalStr = try decimal.toEnglish() else { return nil }
            
            switch style {
            case .cents: return "CENTS \(decimalStr) ONLY"
            case .point: return "POINT \(decimalStr) ONLY"
            case .percent: return "\(decimalStr) \(decimal)/100 ONLY"
            }
        }
        
        let intStr = try toIntParts(3).reversed().enumerated().compactMap { (index, num) in
            if num == 0 { return nil }
            
            guard let engStr = try num.toEnglish() else { return nil }
            
            if index == 0 { return engStr }
            
            return "\(engStr) \(__MoneyUnits.englishUnits[index])"
        }.reversed().joined(separator: ", ")
        
        guard let decimalStr = try decimal.toEnglish() else {
            return "\(intStr) ONLY"
        }
        
        switch style {
        case .cents: return "\(intStr) AND CENTS \(decimalStr) ONLY"
        case .point: return "\(intStr) AND POINT \(decimalStr) ONLY"
        case .percent: return "\(intStr) AND \(decimalStr) \(decimal)/100 ONLY"
        }
    }
    
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
                let unit = __MoneyUnits.chineseUnits[intParts.count - index - 1]
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

private extension Dictionary where Key == UInt, Value == String {
    func __val(for num: Key) throws -> Value {
        guard let target = self[num] else {
            throw MoneyDecimal.DError.excessive
        }
        
        return target
    }
}
