//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(Foundation)

import Foundation

public extension NSDecimalNumber {
    /// 防止string为""时，返回的结果为NAN，导致的可能崩溃
    convenience init(saftyString: String?) {
        guard let saftyString = saftyString else {
            self.init(string: "0")
            return
        }
        
        if saftyString.isEmpty {
            self.init(string: "0")
        } else {
            self.init(string: saftyString)
        }
    }
}

#endif
