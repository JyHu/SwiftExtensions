//
//  File.swift
//  
//
//  Created by Jo on 2024/2/2.
//

import Foundation

public extension NSTextCheckingResult {
    func matchedResultsOf(groups: [String], in string: String) -> [String: String] {
        var results: [String: String] = [:]
        for group in groups {
            let range = range(withName: group)
            if let value = string[range] {
                results[group] = value
            }
        }
        
        return results
    }
}
