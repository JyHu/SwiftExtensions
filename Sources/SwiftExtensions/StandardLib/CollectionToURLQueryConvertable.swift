//
//  File.swift
//  
//
//  Created by Jo on 2023/5/18.
//

import Foundation

public extension Dictionary where Key == String {
    
    ///
    /// 将当前字典转为urlquery参数，即拼接在一起，支持数组及多层嵌套
    ///
    /// 如：
    /// let params: [String: Any] = [
    ///     "a": "a",
    ///     "b": [
    ///         "1",
    ///         "2"
    ///     ],
    ///     "c": [
    ///         "d": "e",
    ///         "f": "g",
    ///         "h": [
    ///             "0",
    ///             "1",
    ///             "2"
    ///         ],
    ///         "j": [
    ///             "k": "l",
    ///             "m": "n"
    ///         ]
    ///     ]
    /// ]
    ///
    /// 转为query参数后
    /// a=a&b[0]=1&b[1]=2&c.d=e&c.f=g&c.h[0]=0&c.h[1]=1&c.h[2]=2&c.j.k=l&c.j.m=n
    ///
    func toURLQuery() -> String {
        return toURLQueryParams()
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
    }
}

private func __collectionToURLQuery(prefix: String, value: Any) -> [String: String] {
    if let dict = value as? [String: Any] {
        return dict.toURLQueryParams(prefix: prefix)
    } else if let arr = value as? [Any] {
        return arr.toURLQueryParams(prefix: prefix)
    } else {
        return [prefix: String(describing: value)]
    }
}

private extension Dictionary where Key == String {
    func toURLQueryParams(prefix: String? = nil) -> [String: String] {
        var result: [String: String] = [:]
        
        /// 字典中的value为数组、字典时处理
        for (key, value) in self {
            let prefix = prefix != nil ? "\(prefix!).\(key)" : key
            result.merge(__collectionToURLQuery(prefix: prefix, value: value))
        }
        
        return result
    }
}

private extension Array {
    func toURLQueryParams(prefix: String) -> [String: String] {
        var result: [String: String] = [:]
        
        for (index, value) in self.enumerated() {
            let prefix = "\(prefix)[\(index)]"
            result.merge(__collectionToURLQuery(prefix: prefix, value: value))
        }
        
        return result
    }
}

