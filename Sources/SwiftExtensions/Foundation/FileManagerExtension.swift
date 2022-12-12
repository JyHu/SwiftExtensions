//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

public extension FileManager {
    /// document 目录
    static var documentDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
    }
    
    /// 缓存目录
    static var cacheDirectory: String? {
        return NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first
    }
    
    /// 创建一个一定存在的文档目录
    /// - Parameter folderName: 目录名称
    /// - Returns: 文件地址
    static func documentDirectory(with folderName: String) -> String? {
        guard let directory = documentDirectory else {
            return nil
        }
        
        return keepExists(of: NSString(string: directory).appendingPathComponent(folderName))
    }
    
    /// 创建一个一定存在的缓存目录
    /// - Parameter folderName: 目录名称
    /// - Returns: 文件地址
    static func cacheDirectory(with folderName: String) -> String? {
        guard let directory = cacheDirectory else {
            return nil
        }
        
        return keepExists(of: NSString(string: directory).appendingPathComponent(folderName))
    }
    
    /// 移除文件
    /// - Parameter path: 文件所在路径
    /// - Returns: 移除结果，成功还是失败
    static func removeFile(at path: String) -> Bool {
        if FileManager.default.fileExists(atPath: path) {
            return ((try? FileManager.default.removeItem(atPath: path)) != nil)
        }
        
        return true
    }
    
    private static func keepExists(of directory: String) -> String {
        if !FileManager.default.fileExists(atPath: directory) {
            try? FileManager.default.createDirectory(atPath: directory, withIntermediateDirectories: true, attributes: nil)
        }
        
        return directory
    }
    
    static func removeItems(at path: String) throws {
        if path.isEmpty { return }
        
        guard FileManager.default.fileExists(atPath: path) else {
            return
        }
        
        for file in try FileManager.default.contentsOfDirectory(atPath: path) {
            try FileManager.default.removeItem(atPath: file)
        }
    }
}

#endif
