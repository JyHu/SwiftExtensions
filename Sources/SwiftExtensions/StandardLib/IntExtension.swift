//
//  File.swift
//  
//
//  Created by Jo on 2023/1/29.
//

import Foundation

private let __lowerChar = "0123456789abcdef"
private let __upperChar = "0123456789ABCDEF"

public extension BinaryInteger {
    var numberOfDigits: Int {
        var num = self
        var res: Int = 0
        while num != 0 {
            res += 1
            num /= 10
        }
        
        return res
    }
    
    /// 将uint64转成hex string
    /// - Parameters:
    ///   - prefix: 前缀，0x 0X 或者其他
    ///   - length: 限定长度，比如转换后的结果是 A44 ，需要显示成 0x00000A44 ，则限定长度为8即可，会自动的补0
    ///   - uppercase: hex string是否大写，
    /// - Returns: 转换后的 hex string 结果
    func hexString(prefix: String = "", length: Int = 0, uppercase: Bool = false) -> String {
        var hex = ""
        var num = self
        
        /// 将值转换成16进制的字符
        func getchar() -> Character? {
            return (uppercase ? __upperChar : __lowerChar).char(at: Int(num % 16))
        }
        
        /// 限定转换结果长度，自动补0
        if length == 0 {
            while num != 0 {
                hex = "\(getchar() ?? "0")\(hex)"
                num /= 16
            }
        } else {
            var bit = 0
            while bit < 16 {
                hex = "\(getchar() ?? "0")\(hex)"
                bit += 1
                num /= 16
            }
        }
        
        return "\(prefix)\(hex)"
    }
}
