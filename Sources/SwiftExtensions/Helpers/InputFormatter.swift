//
//  File.swift
//  
//
//  Created by Jo on 2024/1/31.
//

import Foundation

public final class InputFormatter: Formatter {
    // MARK: - 枚举
    
    /// 用于指定不同过滤条件的枚举。
    public enum Filters {
        case maxLength(_ maxLength: UInt)
        case validater(_ validater: (String) -> Bool)
        case regularExpression(_ pattern: String)
    }

    // MARK: - 属性
    
    /// 当前应用于格式化器的过滤器。
    public private(set) var filter: Filters!

    /// 一个标志，指示是否允许输入中包含空格。
    public var isSpaceEnabled: Bool = true
    
    /// 在输入中拒绝的字符集。
    public var rejectiveChars: CharacterSet?
    
    /// 包含在验证期间要替换的字符串对的字典。
    public var replacedStringPairs: [String: String] = [:]

    // MARK: - 初始化
    
    /// 使用指定的过滤器初始化格式化器。
    public init(filter: Filters) {
        super.init()
        self.filter = filter
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 公共方法

    /// 验证部分字符串是否有效。
    public override func isPartialStringValid(_ partialString: String, newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?, errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool {
        var formattedString = partialString
        var shouldResetPartialString: Bool = false

        if replacedStringPairs.count > 0 {
            for (replacement, target) in replacedStringPairs {
                if formattedString.contains(replacement) {
                    formattedString = formattedString.replacingOccurrences(of: replacement, with: target)
                    shouldResetPartialString = true
                }
            }
        }
        
        if !isSpaceEnabled && formattedString.contains(" ") {
            return false
        }
        
        if let rejectiveChars, let _ = formattedString.rangeOfCharacter(from: rejectiveChars) {
            return false
        }
        
        switch filter {
        case .maxLength(let maxLength):
            if partialString.count > maxLength {
                return false
            }
            
        case .regularExpression(let pattern):
            if formattedString.range(of: pattern, options: .regularExpression) == nil {
                return false
            }
            
        case .validater(let validater):
            if !validater(formattedString) {
                return false
            }
        case .none:
            break
        }
        
        if shouldResetPartialString {
            newString?.pointee = NSString(string: formattedString)
        }
        
        return true
    }
}
