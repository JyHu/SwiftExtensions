//
//  File.swift
//  
//
//  Created by Jo on 2023/4/20.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIResponder = NSResponder
#elseif canImport(UIKit)
import UIKit
public typealias NSUIResponder = UIResponder
#endif

public extension NSUIResponder {
    func nextResponder(till judgeBlock: ((NSUIResponder) -> Bool)) -> NSUIResponder? {
        if judgeBlock(self) { return self }
#if os(iOS)
        guard let next = next else { return nil }
#else
        guard let next = nextResponder else { return nil }
#endif
        return next.nextResponder(till: judgeBlock)
    }
    
    func nextResponder<T>() -> T? {
        return nextResponder { $0 is T } as? T
    }
}


#endif
