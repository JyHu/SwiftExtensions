//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//


#if canImport(Foundation)

import Foundation

public extension FileWrapper {
    /// 移除一个备份数据
    /// - Parameter wrapperName: 备份的文件名
    func removeFileWrapper(with wrapperName: String) {
        if let wrapper = fileWrappers?[wrapperName] {
            removeFileWrapper(wrapper)
        }
    }
    
    /// 添加一个文件对象
    /// - Parameters:
    ///   - data: 文件数据
    ///   - preferredFilename: 文件名
    func addRegularFile(_ data: Data, preferredFilename: String) {
        /// 使用文件数据创建一个wrapper
        let wrapper = FileWrapper(regularFileWithContents: data)
        wrapper.preferredFilename = preferredFilename
        
        updateFileWrapper(wrapper, preferredFilename: preferredFilename)
    }
    
    /// 更新管理的子文档对象
    /// - Parameters:
    ///   - wrapper: 需要更新的文档数据
    ///   - preferredFilename: 文档数据名字
    func updateFileWrapper(_ fileWrapper: FileWrapper, preferredFilename: String) {
        if let wrappers = fileWrappers {
            /// 如果当前已有对应文件名的缓存数据，需要先执行移除，然后再保存
            if let preferredWrapper = wrappers[preferredFilename] {
                removeFileWrapper(preferredWrapper)
            }
        }
        
        addFileWrapper(fileWrapper)
    }
    
    func child(with representedFileName: String) -> FileWrapper? {
        return fileWrappers?[representedFileName]
    }
}

public extension FileWrapper {
    enum Err: Error {
        case noContent
    }
    
    /// 使用wrapper文件名读取对应的plist数据
    /// - Parameter representedFileName: wrapper名
    /// - Returns: plist文件对应的json数据
    func propertyList(with representedFileName: String, options: PropertyListSerialization.MutabilityOptions = []) -> Any? {
        guard let data = regularFileContents else { return nil }
        return try? data.toPropertyList(options: options)
    }
    
    /// 使用wrapper文件名读取对应的json数据
    /// - Parameter representedFileName: wrapper名
    /// - Returns: json文件对应的json数据
    func jsonObject(with representedFileName: String, options: JSONSerialization.ReadingOptions) -> Any? {
        guard let data = regularFileContents else { return nil }
        return try? data.toJsonObject(options: options)
    }
    
    func stringValue(encoding: String.Encoding) -> String? {
        guard let data = regularFileContents else { return nil }
        return String(data: data, encoding: .utf8)
    }
}

#endif
