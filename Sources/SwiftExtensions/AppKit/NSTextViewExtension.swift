//
//  File.swift
//
//
//  Created by Jo on 2022/10/29.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSTextView {
    var attributeString: NSAttributedString? {
        get {
            return layoutManager?.attributedString()
        }
        
        set {
            if let textStorage = textStorage, let attributedString = newValue {
                textStorage.setAttributedString(attributedString)
            }
        }
    }
    
    /// 将内容简单化
    func simplefied() {
        textStorage?.setAttributedString(NSAttributedString(string: string, attributes: [.foregroundColor: NSColor.textColor]))
    }
    
    func disableAutomaticOperating() {
        isAutomaticTextReplacementEnabled = false
        isAutomaticSpellingCorrectionEnabled = false
        isAutomaticDataDetectionEnabled = false
        isAutomaticLinkDetectionEnabled = false
        isAutomaticDashSubstitutionEnabled = false
        isAutomaticQuoteSubstitutionEnabled = false
        isAutomaticTextCompletionEnabled = false
    }
}

#endif
