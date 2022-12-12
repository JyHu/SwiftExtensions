//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

extension Error {
    var code: Int {
        return _code
    }
    
    var domain: String {
        return _domain
    }
}
