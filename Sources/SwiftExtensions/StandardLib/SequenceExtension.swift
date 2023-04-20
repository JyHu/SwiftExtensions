//
//  File.swift
//  
//
//  Created by Jo on 2023/4/20.
//

import Foundation

public extension Sequence where Element: Equatable {
    func count(where isIncluded: (Element) -> Bool) -> Int {
        return filter(isIncluded).count
    }
}
