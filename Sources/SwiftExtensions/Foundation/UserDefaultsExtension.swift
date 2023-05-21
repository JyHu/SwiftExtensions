//
//  File.swift
//  
//
//  Created by Jo on 2023/5/10.
//

#if canImport(Foundation) && canImport(CoreFoundation)

import Foundation

public extension UserDefaults {
    
    /// 获取缓存中groupName分组下defaultName对应的值，并根据推断出的范型强转为需要的数据类型
    /// - Parameters:
    ///   - defaultName: 需要查找的键
    ///   - groupName: 需要查找的分组
    /// - Returns: 查找到的值
    func object<T>(forKey defaultName: String, inGroup groupName: String) -> T? {
        return dictionary(forKey: groupName)?[defaultName] as? T
    }
    
    /// 缓存一个值到指定的分组下
    /// - Parameters:
    ///   - value: 需要缓存的值，如果为空，则会移除对应的key
    ///   - defaultName: 需要存储到的键
    ///   - groupName: 需要存储到的分组
    func set(_ value: Any?, forKey defaultName: String, inGroup groupName: String) {
        /// 如果值为空，则移除对应的键值对
        guard let value else {
            removeObject(forKey: defaultName, inGroup: groupName)
            return
        }
        
        var groupValues = dictionary(forKey: groupName) ?? [:]
        groupValues[defaultName] = value
        set(groupValues, forKey: groupName)
    }
    
    /// 移除groupName分组下defaultName键对应的值
    /// - Parameters:
    ///   - defaultName: 需要移除数据的对应的键
    ///   - groupName: 需要移除的数据所在的分组
    func removeObject(forKey defaultName: String, inGroup groupName: String) {
        guard var groupValues = dictionary(forKey: groupName) else { return }
        groupValues.removeValue(forKey: defaultName)
        set(groupValues, forKey: groupName)
    }
    
    /// 移除groupName分组下的所有的数据
    /// - Parameter groupName: 需要被移除的分组
    func removeAllObjects(inGroup groupName: String) {
        removeObject(forKey: groupName)
    }
}

#endif
