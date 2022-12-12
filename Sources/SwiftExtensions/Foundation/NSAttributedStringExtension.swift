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
}

public extension Array where Element: NSAttributedString {
    func joined(separator: NSAttributedString) -> NSAttributedString {
        guard let firstElement = first else {
            return NSMutableAttributedString(string: "")
        }
        
        let result = NSMutableAttributedString(attributedString: firstElement)
        return dropFirst().reduce(result) { $0 + separator + $1 }
    }
    
    func joined(separator: String) -> NSAttributedString {
        return joined(separator: NSAttributedString(string: separator))
    }
}

#endif
