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
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start...end])
    }
    
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    
    subscript (bounds: PartialRangeUpTo<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex..<end])
    }
    
    subscript (bounds: PartialRangeThrough<Int>) -> String {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[startIndex...end])
    }
    
    subscript (bounds: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        return String(self[start..<endIndex])
    }
    
    subscript (nsrange: NSRange) -> String? {
        if nsrange.location == NSNotFound ||
            nsrange.location + nsrange.length > count {
            return nil
        }
        
        let start = index(startIndex, offsetBy: nsrange.location)
        let end = index(start, offsetBy: nsrange.length)
        return String(self[start ..< end])
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
    func replacing(_ string: String, target: String, options: NSString.CompareOptions = .caseInsensitive) -> String {
        return replacingOccurrences(of: string, with: target, options: options, range: rangeValue)
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
            return replacingCharacters(in: range, with: relativePath)
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
                return self + pathComponent[1...]
            }
            
            return self + pathComponent
        } else {
            if pathComponent.hasPrefix("/") {
                return self + pathComponent
            }
            
            return self + "/" + pathComponent
        }
    }
    
    mutating func append(pathComponent: String) {
        if hasSuffix("/") {
            if pathComponent.hasPrefix("/") {
                self.append(pathComponent[1...])
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
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
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
}
