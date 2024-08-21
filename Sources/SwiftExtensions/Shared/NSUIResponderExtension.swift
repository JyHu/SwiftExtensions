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
    
    /// Finds the next responder in the responder chain that satisfies the provided condition.
    /// - Parameter judgeBlock: A closure that takes a responder and returns a Boolean value indicating whether the responder satisfies the condition.
    /// - Returns: The next responder that satisfies the condition, or nil if none is found.
    func nextResponder(till judgeBlock: ((NSUIResponder) -> Bool)) -> NSUIResponder? {
        if judgeBlock(self) { return self }
#if os(iOS)
        guard let next = next else { return nil }
#else
        guard let next = nextResponder else { return nil }
#endif
        return next.nextResponder(till: judgeBlock)
    }
    
    /// Finds the next responder in the responder chain of a specific type.
    /// - Returns: The next responder of the specified type, or nil if none is found.
    func nextResponder<T>() -> T? {
        return nextResponder { $0 is T } as? T
    }
}

#endif
