//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

public extension Result {
    var error: Failure? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }
    
    var result: Any? {
        switch self {
        case .success(let object): return object
        default: return nil
        }
    }
}
