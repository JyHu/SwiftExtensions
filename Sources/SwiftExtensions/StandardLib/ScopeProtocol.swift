//
//  File.swift
//  
//
//  Created by Jo on 2022/11/24.
//

import Foundation

public protocol ScopeProtocol { }

public extension ScopeProtocol where Self: Any {
    /// Applies a closure to a mutable copy of the object and returns the modified object.
    /// - Parameter closure: The closure to apply, which modifies the object.
    /// - Returns: The modified object after applying the closure.
    /// - Throws: Rethrows any error thrown by the closure.
    @inlinable
    func apply(_ closure: (inout Self) throws -> Void) rethrows -> Self {
        var mutableSelf = self
        try closure(&mutableSelf)
        return mutableSelf
    }
    
    /// Executes a closure with the object as a constant.
    /// - Parameter closure: The closure to execute.
    /// - Throws: Rethrows any error thrown by the closure.
    @inlinable
    func run(_ closure: (Self) throws -> Void) rethrows {
        try closure(self)
    }
}

public extension ScopeProtocol where Self: AnyObject {
    /// Applies a closure to the object and returns the object itself.
    /// - Parameter closure: The closure to apply, which modifies the object.
    /// - Returns: The object itself after applying the closure.
    /// - Throws: Rethrows any error thrown by the closure.
    @inlinable
    func apply(_ closure: (Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
}

extension NSObject: ScopeProtocol {}
