//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

import Foundation

public extension DispatchQueue {
    struct SemaphoreLock {
        let semaphore: DispatchSemaphore
        
        init(value: Int = 1) {
            semaphore = DispatchSemaphore(value: max(value, 1))
        }
        
        func lock() {
            lockWithTimeout(DispatchTime.distantFuture)
        }
        
        func lockWithTimeout(_ timeout: DispatchTime) {
            _ = semaphore.wait(timeout: timeout)
        }
        
        func unlock() {
            semaphore.signal()
        }
    }
}
