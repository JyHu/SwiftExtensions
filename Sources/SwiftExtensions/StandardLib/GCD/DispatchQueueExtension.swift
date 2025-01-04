//
//  File.swift
//  
//
//  Created by Jo on 2022/10/30.
//

import Foundation

public extension DispatchQueue {
    
    /// A helper struct for managing semaphore-based locking on a dispatch queue.
    /// This struct allows for locking and unlocking with a semaphore, ensuring thread safety in concurrent environments.
    struct SemaphoreLock {
        let semaphore: DispatchSemaphore
        
        /// Initializes the semaphore lock with a given initial value.
        /// - Parameter value: The initial value of the semaphore, typically 1 for binary semaphore (default is 1).
        /// - Note: The semaphore value cannot be set to 0 or negative; it is constrained to a minimum of 1.
        init(value: Int = 1) {
            semaphore = DispatchSemaphore(value: max(value, 1))
        }
        
        /// Acquires the lock, waiting indefinitely until the semaphore is available.
        /// - Note: This will block the current thread until the semaphore becomes available.
        func lock() {
            lockWithTimeout(DispatchTime.distantFuture)
        }
        
        /// Acquires the lock with a specified timeout.
        /// - Parameter timeout: The maximum amount of time to wait for the semaphore to become available.
        /// - Note: If the semaphore is not signaled within the timeout period, the wait will return without acquiring the lock.
        func lockWithTimeout(_ timeout: DispatchTime) {
            _ = semaphore.wait(timeout: timeout)
        }
        
        /// Releases the lock, signaling the semaphore to allow other threads to acquire the lock.
        func unlock() {
            semaphore.signal()
        }
    }
}
