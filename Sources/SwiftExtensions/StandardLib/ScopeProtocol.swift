//
//  File.swift
//  
//
//  Created by Jo on 2022/11/24.
//

import Foundation

public protocol ScopeProtocol { }
public extension ScopeProtocol where Self: Any {
    @inlinable
    func apply(_ closure: (inout Self) throws -> Void) rethrows -> Self {
        var mutableSelf = self
        try closure(&mutableSelf)
        return mutableSelf
    }
    
    @inlinable
    func run(_ closure: (Self) throws -> Void) rethrows {
        try closure(self)
    }
}

public extension ScopeProtocol where Self: AnyObject {
    @inlinable
    func apply(_ closure: (Self) throws -> Void) rethrows -> Self {
        try closure(self)
        return self
    }
}

extension NSObject: ScopeProtocol {}
