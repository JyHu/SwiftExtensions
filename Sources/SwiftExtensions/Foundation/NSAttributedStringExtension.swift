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
    convenience init?(sources: [Any], attributes: [Key: Any] = [:], imageOffsetCreator: ((NSUIImage, Int) -> CGPoint)? = nil) {
        if sources.isEmpty { return nil }
        
        let mutableAttributedString = NSMutableAttributedString(string: "")
        
        for (index, element) in sources.enumerated() {
            if let string = element as? String {
                mutableAttributedString.append(string)
            } else if let image = element as? NSUIImage {
                mutableAttributedString.append(image) {
                    imageOffsetCreator?(image, index) ?? .zero
                }
            } else if let attributedString = element as? NSAttributedString {
                mutableAttributedString.append(attributedString)
            } else if let attachment = element as? NSTextAttachment {
                mutableAttributedString.append(NSAttributedString(attachment: attachment))
            } else if let subSources = element as? [Any] {
                if let subAttr = subSources.toAttributedString(attributes: attributes, imageOffsetCreator: imageOffsetCreator) {
                    mutableAttributedString.append(subAttr)
                }
            } else {
                mutableAttributedString.append("\(element)")
            }
        }
        
        if mutableAttributedString.length == 0 {
            if !attributes.isEmpty {
                mutableAttributedString.addAttributes(attributes)
            }
            
            self.init(attributedString: mutableAttributedString)
        } else {
            return nil
        }
    }
    
    func applyingUnderline(style: NSUnderlineStyle, color: NSUIColor? = nil) -> NSAttributedString {
        let mutableAttributedString = {
            if let target = self as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: self)
        }()
        
        if let color = color {
            return mutableAttributedString.applying(attributes: [
                .underlineColor: color,
                .underlineStyle: style.rawValue,
            ])
        } else {
            return mutableAttributedString.applying(attributes: [
                .underlineStyle: style.rawValue,
            ])
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
    func applying(attributes: [Key: Any]) -> NSAttributedString {
        let mutableAttributedString = {
            if let target = self as? NSMutableAttributedString { return target }
            return NSMutableAttributedString(attributedString: self)
        }()
        
        mutableAttributedString.addAttributes(attributes, range: NSMakeRange(0, length))
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
