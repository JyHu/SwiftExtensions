//
//  File.swift
//
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

#if (canImport(AppKit) && !targetEnvironment(macCatalyst)) || canImport(UIKit)
public extension NSAttributedString {
    
    /// 将图表转换为富文本时的处理闭包
    typealias AttributedImageCreator = ((NSUIImage, Int) -> CGPoint)
    
    /// 使用一个数组内容转换为富文本字符串内容
    /// - Parameters:
    ///   - sources: 组成富文本的数据源
    ///   - attributes: 富文本的属性样式列表
    ///   - imageOffsetCreator: 对于图表资源的处理闭包
    convenience init?(sources: [Any], attributes: [Key: Any] = [:], imageOffsetCreator: AttributedImageCreator? = nil) {
        
        if sources.isEmpty { return nil }
        
        let mutableAttributedString = NSMutableAttributedString(string: "")
        
        /// 遍历所有资源，以此加入到富文本中
        for (index, element) in sources.enumerated() {
            /// 普通字符串内容
            if let string = element as? String {
                mutableAttributedString.append(string)
            } 
            /// 图片资源
            else if let image = element as? NSUIImage {
                mutableAttributedString.append(image) {
                    imageOffsetCreator?(image, index) ?? .zero
                }
            } 
            /// 富文本资源
            else if let attributedString = element as? NSAttributedString {
                mutableAttributedString.append(attributedString)
            } 
            /// 文本附件对象，常用于图片转换为富文本时使用
            else if let attachment = element as? NSTextAttachment {
                mutableAttributedString.append(NSAttributedString(attachment: attachment))
            }
            /// 需要添加进来的子的富文本数据列表，需要转换为富文本后再添加进来
            else if let subSources = element as? [Any] {
                if let subAttr = subSources.toAttributedString(attributes: attributes, imageOffsetCreator: imageOffsetCreator) {
                    mutableAttributedString.append(subAttr)
                }
            }
            /// 其他不常见的字符串内容
            else {
                mutableAttributedString.append("\(element)")
            }
        }
        
        guard mutableAttributedString.length != 0 else { return nil }
        
        /// 添加额外的富文本属性
        if !attributes.isEmpty {
            mutableAttributedString.addAttributes(attributes)
        }
        
        /// 初始化富文本字符串内容
        self.init(attributedString: mutableAttributedString)
    }
    
    /// 对当前富文本内容添加下划线
    func applyingUnderline(style: NSUnderlineStyle, color: NSUIColor? = nil, range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = {
            if let target = self as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: self)
        }()
        
        if let color = color {
            return mutableAttributedString.applying(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue,
            ], range: range)
        } else {
            return mutableAttributedString.applying(attributes: [
                .underlineStyle: style.rawValue,
            ], range: range)
        }
    }
}
#endif

public extension NSAttributedString {
    class var lineFeed: Self {
        return self.init(string: "\n")
    }
    
    class var empty: Self {
        return self.init(string: "")
    }
}

public extension NSAttributedString {
    func applying(attributes: [Key: Any], range: NSRange? = nil) -> NSAttributedString {
        let mutableAttributedString = {
            if let target = self as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: self)
        }()
        
        mutableAttributedString.addAttributes(attributes, range: range ?? NSMakeRange(0, length))
        return mutableAttributedString
    }
}

public extension NSAttributedString {
    static func += (lhs: inout NSAttributedString, rhs: NSAttributedString) {
        let mutableAttributedString = {
            if let target = lhs as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: lhs)
        }()
        mutableAttributedString.append(rhs)
        lhs = mutableAttributedString
    }
    
    static func += (lhs: inout NSAttributedString, rhs: String) {
        lhs += NSAttributedString(string: rhs)
    }
    
    static func + (lhs: NSAttributedString, rhs: NSAttributedString) -> NSMutableAttributedString {
        let mutableAttributedString = {
            if let target = lhs as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: lhs)
        }()
        mutableAttributedString.append(rhs)
        return mutableAttributedString
    }
    
    static func + (lhs: NSAttributedString, rhs: String) -> NSMutableAttributedString {
        return lhs + NSAttributedString(string: rhs)
    }
    
    func appending(_ string: String?, attributes: [NSAttributedString.Key: Any] = [:]) -> Self {
        guard let string, !string.isEmpty else { return self }
        return appending(NSAttributedString(string: string, attributes: attributes))
    }
    
    func appending(_ attributedString: NSAttributedString) -> Self {
        func getMutableAttributedString() -> NSMutableAttributedString {
            if let mutable = self as? NSMutableAttributedString {
                return mutable
            }
            return NSMutableAttributedString(attributedString: self)
        }
        
        let mutableAttributedString = getMutableAttributedString()
        mutableAttributedString.append(attributedString)
        return mutableAttributedString as! Self
    }
}

public extension Array where Element: NSAttributedString {
    func attributedStringByJoined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else {
            return NSMutableAttributedString(string: "")
        }
        
        let result = NSMutableAttributedString(attributedString: firstElement)
        return dropFirst().reduce(result) { $0 + separator + $1 }
    }
    
    func attributedStringByJoined(separator: String) -> NSAttributedString {
        return attributedStringByJoined(separator: NSAttributedString(string: separator))
    }
}

#endif
