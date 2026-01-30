//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

public extension Result {
    /// Extracts the error from the result if it exists.
    /// - Returns: The failure value if the result is a failure, or nil if it's a success.
    var error: Failure? {
        switch self {
        case .failure(let error): return error
        default: return nil
        }
    }
    
    /// Extracts the success value from the result if it exists.
    /// - Returns: The success value if the result is a success, or nil if it's a failure.
    var result: Success? {
        switch self {
        case .success(let object): return object
        default: return nil
        }
    }
}

extension Result {
    /// 判断 Result 是否为失败状态
    ///
    /// **使用示例**：
    /// ```swift
    /// let saveResults: [CKRecord.ID: Result<CKRecord, Error>] = ...
    /// let failedCount = saveResults.values.filter { $0.isFailed }.count
    /// print("Failed: \(failedCount) records")
    /// ```
    ///
    /// **等价于**：
    /// ```swift
    /// if case .failure = result {
    ///     // 失败
    /// }
    /// ```
    ///
    /// - Returns: true 如果是 .failure，false 如果是 .success
    var isFailed: Bool {
        if case .failure(_) = self {
            return true
        }
        
        return false
    }
    
    /// 判断 Result 是否为成功状态
    ///
    /// **使用示例**：
    /// ```swift
    /// let saveResults: [CKRecord.ID: Result<CKRecord, Error>] = ...
    /// let successCount = saveResults.values.filter { $0.isSuccessed }.count
    /// print("Succeeded: \(successCount) records")
    ///
    /// // 过滤成功的记录
    /// let successRecords = saveResults.filter { $0.value.isSuccessed }
    /// ```
    ///
    /// **等价于**：
    /// ```swift
    /// if case .success = result {
    ///     // 成功
    /// }
    /// ```
    ///
    /// - Returns: true 如果是 .success，false 如果是 .failure
    var isSuccessed: Bool {
        if case .success(_) = self {
            return true
        }
        
        return false
    }
}
