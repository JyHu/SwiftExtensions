//
//  File.swift
//  
//
//  Created by Jo on 2023/1/29.
//

import Foundation

public extension Int {
    var numberOfDigits: Int {
        var num = self
        var res: Int = 0
        while num > 0 {
            res += 1
            num /= 10
        }
        
        return res
    }
}
