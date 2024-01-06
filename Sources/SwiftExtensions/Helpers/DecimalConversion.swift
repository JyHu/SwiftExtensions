//
//  File.swift
//
//
//  Created by Jo on 2023/5/21.
//

import Foundation

///
/// 格式化内容的配置信息
/// 比如101001001001010010，这个看起来不是很好看，那么格式化后可以是这样的：
/// 0010 1001 0010 0101 0010
///
/// 再比如 E65F0AC2D4E1B9CF13FDF1FCE180D 格式化后：
/// 000E65F0 AC2D4E1B 9CF13FDF 1FCE180D
///
public struct DecimalConvertConfig {
    
    /// 分组大小，将数值以指定数量为一组
    public var groupSize: Int = 4
    
    /// 分组分隔符
    public var separator: Character?
    
    /// 对于分组的数值是否需要补全
    public var polishing: Bool = true
    
    private init() { }
    
    /// 初始化方法
    /// - Parameters:
    ///   - groupSize: 分组大小，将数值以指定的数量为一组处理
    ///   - separator: 分组分隔符
    ///   - polishing: 对于不满足数量的分组是否补全
    private init(groupSize: Int, separator: Character? = nil, polishing: Bool) {
        self.groupSize = groupSize
        self.separator = separator
        self.polishing = polishing
    }
    
    /// 创建一个格式化配置项
    public static func config(groupSize: Int = 4, separator: Character? = nil, polishing: Bool = false) -> DecimalConvertConfig {
        return DecimalConvertConfig(groupSize: groupSize, separator: separator, polishing: polishing)
    }
}

public enum DecimalConvertorError: Error {
    /// 用于转换的有效内容为空，无法正常转换
    case emptySource
    /// 用于进制转换的进制无效
    case invalidHex(Int)
    /// 用于进制转换的基数为空或无效
    case radixEmpty
}

///
/// 将源进制的数从以给定基数的进制转换为目标基数进制的值，
/// 如将 A21B 从以0123ABCD为基数的8进制转换为以ABCD1234为基数的8进制值
/// 如果数据量比较大或者数值比较大，可以加上异步处理，否则会很占用时间。
///
/// 如：
/// print(try "98789y987HJHYjhiuyo7yo78Y678687tigykjgut7tiyG7tUTGjkhghjkgfYTT67tuiygjkOYhiy8".convert(fromHex: 62, toHex: 10))
/// --->
/// 15215330655118794477130345738324172530828565828931039878600212706413841
/// 2318315093972525691995954222655501880481336215760744254234760055048
///
/// - Parameters:
///   - hex: 进制，支持2～62进制，用0～9、A-Z、a-z表示，需要注意的是，如果原数据是数值类型，那么fromHex必须是10
///   - radix: 进制基数，如2进制的基数就是01，16进制的基数就是0123456789ABCDEF，这里也支持自定义的进制
///   - config: 转换后的结果的优化处理方式
///
/// 如自定义的8进制以0123ABCD为基数，那么转换12AC0F为有效的10进制时可以:
/// "12AC0F".convert(fromRadix: "0123ABCD", toHex: 10)
///
public protocol DecimalConvertorProtocol { }

public extension DecimalConvertorProtocol {
    
    /// 将数值以指定进制转换为目标进制，并格式化返回
    /// 比如将16进制的 0xA28D 转换为 10 进制的数值
    /// - Parameters:
    ///   - fromHex: 源数值的进制，比如2进制、8进制、32进制等
    ///   - toHex: 转换到的目标进制，比如2进制、8进制、32进制等
    ///   - config: 数值转换为字符串后的格式化配置项
    /// - Returns: 转换后的格式化数值字符串
    func convert(fromHex: Int, toHex: Int, config: DecimalConvertConfig? = nil) throws -> String {
        return try _Calculator.shared.convert(convertedSource(hex: fromHex), fromHex: fromHex, toHex: toHex, config: config)
    }
    
    /// 将数值以指定进制转换为以给定基数为进制的目标值，并格式化返回
    /// 比如将16进制的0xA28D转换为以  ABCD 为基数的4进制
    /// - Parameters:
    ///   - fromHex: 源数值的进制，比如2进制、8进制、32进制等
    ///   - toRadix: 转换到的目标进制的基数，比如自定义的4进制的基数 ABCD 等
    ///   - config: 数值转换为字符串后的格式化配置项
    /// - Returns: 转换后的格式化数值字符串
    func convert(fromHex: Int, toRadix: String, config: DecimalConvertConfig? = nil) throws -> String {
        return try _Calculator.shared.convert(convertedSource(hex: fromHex), fromHex: fromHex, toRadix: toRadix, config: config)
    }
    
    /// 将数值以给定的进制基数转换为目标进制，并格式化返回
    /// 比如将自定义的以ABCD为基数的4进制数 ADDCBA 转换为10进制的数值
    /// - Parameters:
    ///   - fromRadix: 源数值的进制的基数，可以2进制的 01，8进制的01234567，自定义的4进制 ABCD 等等
    ///   - toHex: 转换到的目标进制，比如2进制、4进制、16进制等等
    ///   - config: 数值转换为字符串时的格式化配置项
    /// - Returns: 转换后的格式化数值字符串
    func convert(fromRadix: String, toHex: Int, config: DecimalConvertConfig? = nil) throws -> String {
        return try _Calculator.shared.convert(convertedSource(), fromRadix: fromRadix, toHex: toHex, config: config)
    }
    
    /// 将数值以给定的进制基数转换为以给定基数的进制的数值，并格式化返回
    /// - Parameters:
    ///   - fromRadix: 源数值的进制的基数
    ///   - toRadix: 目标进制的基数
    ///   - config: 数值转换为字符串时的格式化配置项
    /// - Returns: 转换后的格式化数值字符串
    func convert(fromRadix: String, toRadix: String, config: DecimalConvertConfig? = nil) throws -> String {
        return try _Calculator.shared.convert(convertedSource(), fromRadix: fromRadix, toRadix: toRadix, config: config)
    }
    
    private func convertedSource(hex: Int? = nil) -> String {
        /// 如果原数据是字符串
        if let str = self as? String {
            /// 如果小于36进制，都按大写去转换
            if let hex, hex < 36 {
                return str.uppercased()
            }
            
            return str
        }
        
        /// 否则都转成字符串
        return String(describing: self)
    }
}

extension String: DecimalConvertorProtocol { }
extension Substring: DecimalConvertorProtocol { }
extension Int: DecimalConvertorProtocol { }
extension Int8: DecimalConvertorProtocol { }
extension Int16: DecimalConvertorProtocol { }
extension Int32: DecimalConvertorProtocol { }
extension Int64: DecimalConvertorProtocol { }
extension UInt: DecimalConvertorProtocol { }
extension UInt8: DecimalConvertorProtocol { }
extension UInt32: DecimalConvertorProtocol { }
extension UInt64: DecimalConvertorProtocol { }

/// 将给定进制的数值转换为10进制基数的数组
/// 如，将8A1F转换转换获得的结果为 [3, 5, 3, 5, 9]
public extension String {
    func baseDecimals(fromHex: Int) throws -> [Int] {
        return try baseDecimals(fromRadix: try _Calculator.shared.radix(of: fromHex))
    }
    
    func baseDecimals(fromRadix: String) throws -> [Int] {
        let fromRadix = fromRadix.trimming.replacing(" ", target: "")
        if fromRadix.isEmpty { throw DecimalConvertorError.emptySource }
        let source = trimming.replacing(" ", target: "")
        if source.isEmpty { throw DecimalConvertorError.emptySource }
        let decimals = source.compactMap { fromRadix.distance(of: $0) }
        return decimals.decimal_toDecimals(from: fromRadix.count)
    }
}

public extension Substring {
    func baseDecimals(fromHex: Int) throws -> [Int] {
        return try String(self).baseDecimals(fromHex: fromHex)
    }
    
    func baseDecimals(fromRadix: String) throws -> [Int] {
        return try String(self).baseDecimals(fromRadix: fromRadix)
    }
}

/// 将10进制源数据列表转换为目标进制的数值字符串
/// 如将10进制的基数数组 [3, 5, 3, 5, 9] 转换为16进制的数值 8A1F
public extension Array where Element == Int {
    
    /// 将当前的数值数组转换为目标进制的数值字符串，并格式化返回
    /// - Parameters:
    ///   - toHex: 目标进制
    ///   - config: 格式化配置项
    /// - Returns: 转换后的结果
    func convert(toHex: Int, config: DecimalConvertConfig? = nil) throws -> String {
        return try convert(toRadix: try _Calculator.shared.radix(of: toHex), config: config)
    }
    
    func convert(toRadix: String, config: DecimalConvertConfig? = nil) throws -> String {
        /// 目标进制的基数字符个数
        let toHex = toRadix.count
        
        /// 将10进制的数值转换成目标进制的结果数组
        /// 如，将8A1F转换转换获得的结果为 [8, 10, 15]
        let targetDecimals = decimal_binHexOct(to: toHex)
        
        /// 将目标基数值转换为目标进制的字符列表
        var targetCharacters = targetDecimals.compactMap { toRadix.char(at: $0) }
        
        /// 做特殊的展示格式化
        if let config = config, config.groupSize > 0, let separator = config.separator {
            var index: Int = targetDecimals.count - config.groupSize
            while index > 0 {
                targetCharacters.insert(separator, at: index)
                index -= config.groupSize
            }
            
            if config.polishing {
                let remainder = targetDecimals.count % config.groupSize
                if remainder > 0 {
                    var neededCount = config.groupSize - targetDecimals.count % config.groupSize
                    while neededCount > 0 {
                        targetCharacters.insert("0", at: 0)
                        neededCount -= 1
                    }
                }
            }
        }
        
        return String(targetCharacters)
    }
}

/// 默认的全量基数，任意有效进制的基数都可以通过获取前n个字符来作为基数
private var _baseRadix = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

private class _Calculator {
    static var shared = _Calculator()
    
    /// 缓存的所有进制基数
    private var radixes: [Int: String] = [:]
    
    /// 获取指定进制的基数
    func radix(of hex: Int) throws -> String {
        guard hex >= 2 && hex <= 62 else {
            throw DecimalConvertorError.invalidHex(hex)
        }
        
        if let radix = radixes[hex] {
            return radix
        }
        
        if let res = _baseRadix[0 ..< hex] {
            radixes[hex] = res
            return res
        }
        
        throw DecimalConvertorError.invalidHex(hex)
    }
    
    /// 将需要转换的原始数值做调整，因为对于小于11～36进制来说，都是以数值加大写字母作为基数的，
    /// 而在实际的使用中，传进来的有可能带有小写字母，为了避免无法有效转换，需要特别处理一下
    /// - Parameters:
    ///   - source: 需要转换的原始数值
    ///   - hex: 原始数值所对应的进制
    /// - Returns: 转换后的有效的数值字符串
    func insensitive(_ source: String, hex: Int) -> String {
        if hex <= 10 || hex > 36 {
            return source
        }
        
        return source.uppercased()
    }
    
    func convert(_ source: String, fromHex: Int, toHex: Int, config: DecimalConvertConfig? = nil) throws -> String {
        return try convert(insensitive(source, hex: fromHex), fromRadix: try radix(of: fromHex), toRadix: try radix(of: toHex), config: config)
    }
    
    func convert(_ source: String, fromHex: Int, toRadix: String, config: DecimalConvertConfig? = nil) throws -> String {
        return try convert(insensitive(source, hex: fromHex), fromRadix: try radix(of: fromHex), toRadix: toRadix, config: config)
    }
    
    func convert(_ source: String, fromRadix: String, toHex: Int, config: DecimalConvertConfig? = nil) throws -> String {
        return try convert(source, fromRadix: fromRadix, toRadix: try radix(of: toHex), config: config)
    }
    
    func convert(_ source: String, fromRadix: String, toRadix: String, config: DecimalConvertConfig? = nil) throws -> String {
        /// 将源数值转成10进制的数值的数组，方便后续计算
        return try source.baseDecimals(fromRadix: fromRadix)
            .convert(toRadix: toRadix, config: config)
    }
}

private extension Int {
    /// 计算乘方
    /// - Parameter power: 幂
    /// - Returns: 乘方结果
    func decimal_powerTo(_ power: Int) -> [Int] {
        var result: [Int] = []
        for _ in 0 ..< power {
            result.decimal_multiply(self)
        }
        return result
    }
}

private extension Array where Element == Int {
    /// 将n进制的数据转换成10进制的数组
    /// 如：将16进制的A0转换成10进制为160，然后转成数组 [1, 6, 0]
    /// 这样做是因为如果入参为一个超大数，那么转换后的10进制可能就堆栈溢出了，
    /// 转成数组可以处理无限大的数
    /// - Parameters:
    ///   - decimals: 源数值，如16进制的 A28D，这里表示为 [10, 2, 8, 13]
    ///   - hex: 源数值的进制
    /// - Returns: 转换后对应的10进制的数值列表，如A28D转换为10进制后为41613，
    ///     那么结果就是[4,1,6,1,3]
    func decimal_toDecimals(from hex: Int) -> [Int] {
        var res: [Int] = []
        for (index, num) in reversed().enumerated() {
            res.decimal_add(hex.decimal_powerTo(index).decimal_multipling(num))
        }
        return res
    }
    
    /// 从后往前数第index个数据是什么
    func decimal_backward(at index: Int) -> Int? {
        let index = count - index - 1
        if index < 0 || index >= count { return nil }
        return self[index]
    }
    
    /// 转换为指定的进制的数字索引
    /// 如，将8A1F转换转换获得的结果为 [8, 10, 1, 15]
    func decimal_binHexOct(to scale: Int) -> [Int] {
        var result: [Int] = []
        
        var quotients = self
        while !quotients.isEmpty {
            let (nextQuotiens, md) = quotients.decimal_mode(to: scale)
            result.append(md)
            quotients = nextQuotiens
        }
        
        return result.reversed()
    }
    
    /// 将当前数值数列对给定数值取模
    /// - Returns: 取模后的结果和余数
    func decimal_mode(to hex: Int) -> ([Int], Int) {
        var quotients: [Int] = []
        var tmpVal: Int = 0
        
        for num in self {
            tmpVal = tmpVal * 10 + num
            if tmpVal < hex {
                if !quotients.isEmpty {
                    quotients.append(0)
                }
            } else {
                quotients.append(tmpVal / hex)
                tmpVal = tmpVal % hex
            }
        }
        
        return (quotients, tmpVal)
    }
}

private extension Array where Element == Int {
    mutating func decimal_add(_ nums: [Int], scale: Int = 10) {
        let maxCount = Swift.max(nums.count, count)
        var backIndex: Int = 0
        var carry: Int = 0
        while backIndex < maxCount {
            let value = (decimal_backward(at: backIndex) ?? 0) + (nums.decimal_backward(at: backIndex) ?? 0) + carry
            if backIndex < count {
                self[count - backIndex - 1] = value % scale
            } else {
                insert(value % scale, at: 0)
            }
            carry = value / scale
            backIndex += 1
        }
        
        /// 如果有剩余，说明当前计算往前进位了，需要插入数组首位。
        if carry > 0 {
            insert(carry, at: 0)
        }
    }
    
    mutating func decimal_add(_ num: Int, scale: Int = 10) {
        var ind: Int = count - 1
        var addend: Int = num
        
        while ind >= 0 {
            addend += self[ind]
            self[ind] = addend % scale
            addend = addend / scale
            ind -= 1
        }
        
        while addend > 0 {
            insert(addend % scale, at: 0)
            addend /= scale
        }
    }
    
    func decimal_adding(_ nums: [Int], scale: Int = 10) -> [Int] {
        var res = self
        res.decimal_add(nums, scale: scale)
        return res
    }
    
    func decimal_adding(_ num: Int, scale: Int = 10) -> [Int] {
        var res = self
        res.decimal_add(num, scale: scale)
        return res
    }
}

private extension Array where Element == Int {
    /// 将大数数组乘以一个数值
    /// - Parameter num: 乘数
    mutating func decimal_multiply(_ num: Int) {
        if isEmpty {
            var num = num
            while num > 0 {
                insert(num % 10, at: 0)
                num = num / 10
            }
        } else {
            var index = count - 1
            var carry: Int = 0
            while index >= 0 {
                let num = self[index] * num + carry
                self[index] = num % 10
                carry = num / 10
                index -= 1
            }
            
            while carry > 0 {
                insert(carry % 10, at: 0)
                carry = carry / 10
            }
        }
    }
    
    /// 将大数数组乘以一个数并返回结果
    /// - Parameter num: 乘数
    /// - Returns: 计算结果
    func decimal_multipling(_ num: Int) -> [Int] {
        var res = self
        res.decimal_multiply(num)
        return res
    }
}
