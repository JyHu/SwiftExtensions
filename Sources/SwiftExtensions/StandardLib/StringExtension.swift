//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension String {
    var localized: String {
        NSLocalizedString(self, comment: self)
    }
    
    func localized(withTableName tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "") -> String {
        NSLocalizedString(self, tableName: tableName, bundle: bundle, value: value, comment: self)
    }
}

#endif

public extension String {
    subscript (bounds: CountableClosedRange<Int>) -> String? {
        guard bounds.lowerBound >= 0 && bounds.upperBound < count else { return nil }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String? {
        guard bounds.lowerBound >= 0 && bounds.upperBound <= count else { return nil }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> String? {
        guard bounds.upperBound <= count else { return nil }
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> String? {
        guard bounds.upperBound < count else { return nil }
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String? {
        guard bounds.lowerBound >= 0 && bounds.lowerBound < count else { return nil }
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
    
    subscript (nsrange: NSRange) -> String? {
        if nsrange.location == NSNotFound ||
            nsrange.location < 0 || nsrange.length < 0 ||
            nsrange.location + nsrange.length > count {
            return nil
        }
        
        let start = index(startIndex, offsetBy: nsrange.location)
        let end = index(start, offsetBy: nsrange.length)
        return String(self[start ..< end])
    }
    
    func subString(from index: Int) -> String? {
        return self[index...]
    }
    
    func subString(to index: Int) -> String? {
        return self[...index]
    }
    
    func subStringWith(pattern: String) -> String? {
        guard let range = range(of: pattern, options: .regularExpression) else {
            return nil
        }
        
        return String(self[range])
    }
    
    /// Get the character value of current string at the given index.
    /// - Parameter index: Character index
    /// - Returns: Character
    func char(at index: Int) -> Character? {
        if index >= count { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Get all ranges of given string in current string.
    /// - Parameters:
    ///   - string: Searched string
    ///   - options: Match options
    /// - Returns: All mached ranges
    func ranges(of string: String, options: CompareOptions = .caseInsensitive) -> [Range<String.Index>] {
        if options == .regularExpression {
            return textCheckingResults(with: string).map { rangeValue(from: $0.range) }
        }
        
        
        func nextRange(from beginIndex: String.Index, result: [Range<String.Index>]) -> [Range<String.Index>] {
            guard let targetRange = range(of: string, options: options, range: beginIndex ..< endIndex) else {
                return result
            }
            
            return nextRange(from: targetRange.upperBound, result: result + [targetRange])
        }
        
        return nextRange(from: startIndex, result: [])
    }
    
    func nsranges(of string: String, options: NSString.CompareOptions = []) -> [NSRange] {
        if options == .regularExpression {
            return textCheckingResults(with: string).map { $0.range }
        }
        
        let nsstring = NSString(string: self)
        
        func nextRange(from beginIndex: Int, result: [NSRange]) -> [NSRange] {
            if beginIndex >= count {
                return result
            }
            
            let range = nsstring.range(of: string, options: options, range: NSRange(location: beginIndex, length: count - beginIndex))
            
            if range.location == NSNotFound {
                return result
            }
            
            return nextRange(from: range.location + range.length, result: result + [range])
        }
        
        return nextRange(from: 0, result: [])
    }
    
    /// 获取给定的字符串在当前字符串的位置
    /// - Parameters:
    ///   - subString: 要判断的字符串
    ///   - backwards: 是否从后面开始搜索，如果backwards参数设置为true，则返回最后出现的位置，默认false
    /// - Returns: 搜索结果，如果搜索不到，则返回-1
    func position(of subString: String, backwards: Bool = false) -> Int {
        // 如果没有找到就返回-1
        if let range = range(of: subString, options: backwards ? .backwards : .literal) {
            if !range.isEmpty {
                return distance(from: startIndex, to: range.lowerBound)
            }
        }
        return -1
    }
}

public extension String {
    func textCheckingResults(with pattern: String) -> [NSTextCheckingResult] {
        return (try? NSRegularExpression(pattern: pattern, options: .caseInsensitive))?.matches(in: self) ?? []
    }
    
    /// 替换当前字符串中的指定字符
    /// - Parameters:
    ///   - string: 要替换的字符串
    ///   - target: 要替换成的字符串
    ///   - options: 替换方式，默认字符串匹配方式
    /// - Returns: 替换后的字符串
    func replacing(_ string: String, target: String, options: NSString.CompareOptions = .caseInsensitive, range: Range<Index>? = nil) -> String {
        return replacingOccurrences(of: string, with: target, options: options, range: range)
    }
    
    private static let desensitizationReg = try? NSRegularExpression(pattern: "[\\.\\\\\\^\\$\\*\\+\\?\\[\\]\\{\\}\\(\\)\\|]", options: .caseInsensitive)
    
    /// 字符串正则脱敏
    var regexDesensitization: String {
        if let reg = String.desensitizationReg {
            return reg.stringByReplacingMatches(in: self, options: .reportCompletion, range: NSRange(location: 0, length: count), withTemplate: "\\\\$0")
        }
        
        return self
    }
}

public extension String {
    /// 跟给定路径的相对路径
    ///
    /// self = A/B/C/D
    /// path = A/B
    ///
    /// self.relat(to: path) = ~/C/D
    ///
    /// - Parameter path: 要简化掉的路径
    func relate(to path: String?, relativePath: String = "") -> String {
        guard let path = path else {
            return self
        }
        
        guard let range = range(of: path) else {
            return self
        }
        
        if range.lowerBound == startIndex {
            let target = replacingCharacters(in: range, with: relativePath)
            
            if target.hasPrefix("/") {
                return relativePath + target
            } else {
                return relativePath + "/" + target
            }
        }
        
        return self
    }
    
    /// 获取当前字符串的最后路径
    var lastPathComponent: String? {
        guard let range = range(of: "/", options: .backwards) else {
            return nil
        }
        
        return String(self[index(after: range.lowerBound) ..< index(startIndex, offsetBy: count)])
    }
    
    /// 获取字符串文件类型
    var pathExtension: String? {
        guard let range = range(of: ".", options: .backwards) else {
            return nil
        }
        
        return String(self[index(after: range.lowerBound) ..< index(startIndex, offsetBy: count)])
    }
    
    /// 在字路径符串后面拼接一个文件名或地址
    /// - Parameter pathComponent: 文件名或地址
    /// - Returns: 拼接后的字符串
    func stringByAppending(pathComponent: String) -> String {
        if hasSuffix("/") {
            if pathComponent.hasPrefix("/") {
                return self + String(pathComponent.dropFirst())
            }
            
            return self + pathComponent
        } else {
            if pathComponent.hasPrefix("/") {
                return self + pathComponent
            }
            
            return self + "/" + pathComponent
        }
    }
    
    func replacingOccurrences(of keyword: String, with replacement: String, options: CompareOptions = [], maxReplacements: Int) -> String {
        var count = 0
        var result = self
        
        while let range = result.range(of: keyword, options: options) {
            result = result.replacingCharacters(in: range, with: replacement)
            count += 1
            
            if count == maxReplacements {
                return result
            }
        }
        
        return result
    }
    
    mutating func append(pathComponent: String) {
        if hasSuffix("/") {
            if pathComponent.hasPrefix("/") {
                self.append(String(pathComponent.dropFirst()))
            } else {
                self.append(pathComponent)
            }
        } else {
            if pathComponent.hasPrefix("/") {
                self.append(pathComponent)
            } else {
                self.append("/" + pathComponent)
            }
        }
    }
    
    /// 去除字符串开头结尾的空白字符
    var trimming: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// 获取当前字符串的range对象
    var rangeValue: Range<String.Index>! {
        return startIndex ..< index(startIndex, offsetBy: count)
    }
    
    /// 将Swift的Range对象转换成OC的NSRange对象
    /// - Parameter range: swift的Range对象
    /// - Returns: 转换后的OC的NSRange对象
    func nsRangeValue(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }
    
    func rangeValue(from nsrange: NSRange) -> Range<String.Index> {
        let startIndex = index(startIndex, offsetBy: nsrange.location)
        let endIndex = index(startIndex, offsetBy: nsrange.length)
        return startIndex ..< endIndex
    }
    
    var wordCount: Int {
        guard let regex = try? NSRegularExpression(pattern: "\\w+") else { return 0 }
        return regex.numberOfMatches(in: self, range: NSMakeRange(0, count))
    }
    
    var asURL: URL? { URL(string: self) }
}

public extension String {
    /// 根据给定的正则表达式判断当前字符串是否符合
    func isLegal(with pattern: String) -> Bool {
        return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self)
    }
    
    /// 是否是有效的url地址
    var isLegalURL: Bool {
        return isLegal(with: "(https://|http://)?([\\w-]+\\.)+[\\w-]+(/[\\w- ./?%&=]*)?")
    }
    
    /// 是否是有效的电话号码
    var isLegalPhoneNumber: Bool {
        return isLegal(with: "^1[0-9]{10}$")
    }
    
    /// 是否是有效整数
    var isLegalPureIntNumber: Bool {
        return isLegal(with: "^\\d+$")
    }
    
    var isLegalNumber: Bool {
        return isLegal(with: "^-?\\d+(\\.\\d+)?$")
    }
}

public extension String {
    /// 将一个普通的字符串转换为utf8二进制数据
    func toUTF8Data(allowLossyConversion: Bool = false) -> Data? {
        return data(using: .utf8, allowLossyConversion: false)
    }
    
    /// 将一个base64字符串转换为二进制数据
    func base64StringToData(options: Data.Base64DecodingOptions = []) -> Data? {
        return Data(base64Encoded: self, options: options)
    }
    
    /// 将一个base64字符串转换为一个普通的字符串
    func base64StringToString(options: Data.Base64DecodingOptions = [], encoding: String.Encoding = .utf8) -> String? {
        guard let data = base64StringToData(options: options) else { return nil }
        return String(data: data, encoding: encoding)
    }
    
    /// 将一个普通的字符串转换为一个base64的二进制数据
    func toBase64String(options: Data.Base64EncodingOptions = []) -> String? {
        return data(using: .utf8)?.base64EncodedString(options: options)
    }
    
    /// 将一个普通的字符串转换为base64的二进制数据
    func toBase64Data(encodingOptions: Data.Base64EncodingOptions = [], decodingOptions: Data.Base64DecodingOptions = []) -> Data? {
        return toBase64String(options: encodingOptions)?.base64StringToData(options: decodingOptions)
    }
    
    func toHexData() -> Data? {
        if count % 2 != 0 { return nil }
        
        var bytes: [UInt8] = []
        var sum: Int = 0
        
        let intRange = 48...57
        let lowerCaseRange = 97...102
        let upperCaseRange = 65...70
        
        for (index, c) in self.utf8CString.enumerated() {
            var intc = Int(c.byteSwapped)
            
            if intc == 0 { break }
            if intRange.contains(intc) {
                intc -= 48
            } else if lowerCaseRange.contains(intc) {
                intc -= 87
            } else if upperCaseRange.contains(intc) {
                intc -= 55
            } else {
                assertionFailure("输入字符串格式不对")
            }
            
            sum = sum * 16 + intc
            if index % 2 != 0 {
                bytes.append(UInt8(sum))
                sum = 0
            }
        }
        
        return Data(bytes: bytes, count: bytes.count)
    }
}

public extension String {
    /// 添加自定义的富文本属性
    /// - Parameter attributes: 富文本属性列表
    /// - Returns: 处理后的富文本
    func attributed(_ attributes: [NSAttributedString.Key: Any] = [:]) -> NSMutableAttributedString {
        if attributes.isEmpty {
            return NSMutableAttributedString(string: self)
        }

        return NSMutableAttributedString(string: self, attributes: attributes)
    }
    
    func hypertextLinkTo(_ link: Any, attributes: [NSAttributedString.Key: Any] = [:]) -> NSMutableAttributedString {
        if attributes.count == 0 {
            return attributed([.link: link])
        }
        
        var attributes = attributes
        attributes[.link] = link
        return attributed(attributes)
    }
}

public extension String {
    
    /// 将字符串转换 unsafe raw pointer 格式，可以在 objc association 中使用
    var unsafePointer: UnsafeRawPointer {
        return withCString { cString in
            return UnsafeRawPointer(cString)
        }
    }
}
