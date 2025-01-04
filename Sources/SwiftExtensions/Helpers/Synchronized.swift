//
//  File.swift
//  
//
//  Created by Jo on 2023/3/31.
//

import Foundation

/// A property wrapper that synchronizes access to a value, ensuring thread safety in concurrent environments.
///
/// Usage:
///
/// struct Model {
///     @Synchronized var values: [String: String] = [:]
/// }
///
/// This property wrapper uses an `NSRecursiveLock` to guarantee that only one thread can access or modify
/// the `wrappedValue` at a time, preventing race conditions.
@propertyWrapper
public final class Synchronized<Value> {
    
    /// The lock used to synchronize access to the wrapped value.
    private var lock: NSRecursiveLock = NSRecursiveLock()

    /// The cached value of the wrapped property.
    private var cachedWrappedValue: Value

    /// The wrapped value.
    ///
    /// The getter and setter are synchronized with an `NSRecursiveLock` to ensure thread-safe access and modification.
    public var wrappedValue: Value {
        get {
            // Lock before accessing the value and unlock after.
            defer {
                lock.unlock()
            }
            
            lock.lock()
            return cachedWrappedValue
        }

        set {
            // Lock before modifying the value and unlock after.
            defer {
                lock.unlock()
            }
            
            lock.lock()
            cachedWrappedValue = newValue
        }
    }

    /// Initializes the `Synchronized` property wrapper with a given initial value.
    ///
    /// - Parameter value: The initial value of the wrapped property.
    public init(wrappedValue value: Value) {
        self.cachedWrappedValue = value
    }
}
