//
//  File.swift
//  
//
//  Created by Jo on 2023/4/20.
//

import Foundation

public extension Comparable {
    /// Clamps the current value between two given values.
    ///
    /// - Description:
    ///     - If the current value is within the range of `val1` and `val2`, it returns the current value.
    ///     - If the current value is outside the range, it returns either the minimum or maximum of the two given values, whichever is closer.
    ///     - If `val1` and `val2` are equal, the method will return that value, regardless of the current value.
    ///
    /// - Parameters:
    ///   - val1: The lower or upper bound of the range, depending on the comparison.
    ///   - val2: The upper or lower bound of the range, depending on the comparison.
    ///
    /// - Returns: The value that is clamped within the range of `val1` and `val2`.
    ///
    /// Example usage:
    /// ```swift
    /// let number = 10
    /// let clampedValue = number.clamp(val1: 5, val2: 15)
    /// print(clampedValue)  // Output: 10
    ///
    /// let number2 = 20
    /// let clampedValue2 = number2.clamp(val1: 5, val2: 15)
    /// print(clampedValue2)  // Output: 15
    ///
    /// let number3 = 2
    /// let clampedValue3 = number3.clamp(val1: 5, val2: 15)
    /// print(clampedValue3)  // Output: 5
    ///
    /// let equalClampedValue = 10.clamp(val1: 10, val2: 10)
    /// print(equalClampedValue)  // Output: 10
    /// ```
    func clamp(val1: Self, val2: Self) -> Self {
        // If the two values are equal, return that value as the clamp.
        if val1 == val2 {
            return val1
        }
        
        // Determine the maximum and minimum values between val1 and val2.
        let maxVal = max(val1, val2)
        let minVal = min(val1, val2)
        
        // Return the clamped value based on the current value's relationship to the bounds.
        if self > maxVal { return maxVal }
        if self < minVal { return minVal }
        return self
    }
}
