//
//  File.swift
//  
//
//  Created by Jo on 2023/1/16.
//

import Foundation

public extension Timer {
    func pause() {
        fireDate = .distantFuture
    }
    
    func resume() {
        fireDate = Date()
    }
}
