//
//  CKRecord+.swift
//  SwiftExtensions
//
//  Created by hujinyou on 2026/1/30.
//

#if canImport(CloudKit)

import CloudKit

public extension CKRecord {
    struct PropertyLostError: Error {
        let property: String
        
        init(_ property: String) {
            self.property = property
        }
    }
    
    func createAt() throws -> Date {
        if let date = self.creationDate {
            return date
        }
        
        throw PropertyLostError("creationDate")
    }
    
    func updateAt() throws -> Date {
        if let date = self.modificationDate {
            return date
        }
        
        throw PropertyLostError("modificationDate")
    }
    
    func get<T>(_ key: String) -> T? {
        return self[key] as? T
    }
    
    func get<T: RawRepresentable>(_ key: String) -> T? {
        if let val = self[key] as? T.RawValue, let res = T(rawValue: val) {
            return res
        }
        
        return nil
    }
    
    func tryGet<T>(_ key: String) throws -> T {
        if let value = self[key] as? T {
            return value
        }
        
        throw PropertyLostError(key)
    }
    
    func tryGet<T: RawRepresentable>(_ key: String) throws -> T {
        if let val = self[key] as? T.RawValue, let res = T(rawValue: val) {
            return res
        }
        
        throw PropertyLostError(key)
    }
}

public extension CKRecord {
    func set<T>(_ value: T?, for key: String) {
        if let value {
            self[key] = value as? CKRecordValue
        }
    }
    
    func set<T: RawRepresentable>(_ value: T?, for key: String) {
        if let val = value?.rawValue {
            self[key] = val as? CKRecordValue
        }
    }
}

#endif
