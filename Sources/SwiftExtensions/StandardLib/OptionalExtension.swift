//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

public extension Optional {
    /// Unwraps the optional value, or throws an error if the value is nil.
    /// - Parameter error: The error to throw if the optional is nil.
    /// - Throws: The provided error if the optional is nil.
    /// - Returns: The wrapped value if it exists.
    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else { throw error() }
        return value
    }
}
