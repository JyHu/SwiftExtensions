//
//  File.swift
//  
//
//  Created by Jo on 2023/3/31.
//

import Foundation

///
///
/// Usage:
///
/// struct Model {
///     @Synchronized var values: [String: String] = [:]
/// }
///
@propertyWrapper
public final class Synchronized<Value> {
    private var lock: NSRecursiveLock = NSRecursiveLock()

    private var cachedWrappedValue: Value

    public var wrappedValue: Value {
        get {
            defer {
                lock.unlock()
            }
            
            lock.lock()
            return cachedWrappedValue
        }

        set {
            defer {
                lock.unlock()
            }
            
            lock.lock()
            cachedWrappedValue = newValue
        }
    }

    public init(wrappedValue value: Value) {
        self.cachedWrappedValue = value
    }
}
