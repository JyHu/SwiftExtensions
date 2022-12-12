//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

public extension Optional {
    func orThrow(_ error: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else { throw error() }
        return value
    }
}
