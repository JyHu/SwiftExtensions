//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension NSRegularExpression {
    private func nsrange<S>(in string: S, of range: Range<String.Index>? = nil) -> NSRange where S: StringProtocol {
        if let range = range { return NSRange(range, in: string) }
        return NSRange(location: 0, length: string.count)
    }
    
    /// 获取第一个匹配结果
    /// - Parameter string: 要匹配的字符串
    /// - Returns: 匹配结果
    func firstMatch(in string: String, options: MatchingOptions = .reportCompletion, range: Range<String.Index>? = nil) -> NSTextCheckingResult? {
        return firstMatch(in: string, options: options, range: nsrange(in: string, of: range))
    }
    
    /// 获取匹配结果
    /// - Parameter string: 要匹配的字符串
    /// - Returns: 匹配结果列表
    func matches(in string: String, options: MatchingOptions = .reportCompletion, range: Range<String.Index>? = nil) -> [NSTextCheckingResult] {
        return matches(in: string, options: options, range: nsrange(in: string, of: range))
    }
    
    /// 截取字符串中匹配到的所有字符串
    ///
    /// 因为正则匹配可以分组，所以返回结果会是一个二维数组，比如：
    ///
    /// string -> 1234aa5678bbb
    /// reg -> (\d)(\d)(\d+)
    /// result ->
    /// [
    ///  [      --> 匹配到的第一条数据
    ///   1234, --> 第一条数据的分组0
    ///   1,    --> 第一条数据的分组1
    ///   2,    --> 第一条数据的分组2
    ///   34    --> 第一条数据的分组3
    ///  ],
    ///  [      --> 匹配到的第二条数据
    ///   5678, --> 第二条数据的分组0
    ///   5,    --> 第一条数据的分组1
    ///   6,    --> 第一条数据的分组2
    ///   78    --> 第一条数据的分组3
    ///  ]
    /// ]
    ///
    /// - Parameter string: 要进行匹配的字符串
    /// - Returns: 匹配结果 [[String]]
    func groupedResults(in string: String, options: MatchingOptions = .reportCompletion, range: Range<String.Index>? = nil) -> [[String]] {
        return matches(in: string, options: options, range: range)
            .map { check -> [String] in
                (0 ..< check.numberOfRanges).map {
                    String(string[check.range(at: $0)] ?? "")
                }
            }
    }
    
    typealias Enumerator = (_ result: NSTextCheckingResult?, _ flags: MatchingFlags, _ stop: inout Bool) -> Void
    func enumerateMatches(in string: String, options: MatchingOptions = [], range: Range<String.Index>? = nil, using block: Enumerator) {
        let efficentRange = {
            if let range = range { return NSRange(range, in: string) }
            return NSRange(location: 0, length: string.count)
        }()
        
        enumerateMatches(in: string, options: options, range: efficentRange) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop {
                stop.pointee = true
            }
        }
    }
    
    func stringByReplacingMatches(in string: String, options: MatchingOptions = [], range: Range<String.Index>? = nil, withTemplate templ: String) -> String {
        return stringByReplacingMatches(in: string, options: options, range: nsrange(in: string, of: range), withTemplate: templ)
    }
}

private extension NSObject.AssociationKey {
    static let groups = NSObject.AssociationKey(rawValue: "com.auu.regex.groups")
}

private let _groupPattern = "\\(\\?<(\\w+)>"
private let _groupRegex = try? NSRegularExpression(pattern: _groupPattern)

public extension NSRegularExpression {
    var namedCaptureGroups: [String] {
        if let cachedGroups: [String] = associatedObject(for: .groups) {
            return cachedGroups
        }
        
        var enumeratedGroups: [String] = []
        
        if let regex = _groupRegex {
            let checkingResults = regex.matches(in: pattern)
            for checkingResult in checkingResults {
                if let groupName = pattern[checkingResult.range(at: 1)] {
                    enumeratedGroups.append(groupName)
                }
            }
        }
        
        setAssociatedObject(enumeratedGroups, for: .groups, policy: .retainNonatomic)
        
        return enumeratedGroups
    }
}

#endif
