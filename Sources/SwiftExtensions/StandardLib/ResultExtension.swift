//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

public extension Result {
    /// Extracts the error from the result if it exists.
    /// - Returns: The failure value if the result is a failure, or nil if it's a success.
    var error: Failure? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }
    
    /// Extracts the success value from the result if it exists.
    /// - Returns: The success value if the result is a success, or nil if it's a failure.
    var result: Success? {
        switch self {
        case .success(let object): return object
        default: return nil
        }
    }
}
