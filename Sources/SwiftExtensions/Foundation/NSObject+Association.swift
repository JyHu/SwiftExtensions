//
//  File.swift
//  
//
//  Created by Jo on 2024/2/1.
//

import Foundation

///
/// 处理通过runtime的方式给一个对象在category中添加属性。
/// 一般的使用方式如：
///
///     let key = "com.itiger.associationkey"
///     objc_setAssociatedObject(self, &key, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
///
/// 这种方式使用key可以正常存取数据，但是在运行的时候会被编译器报警告，如：
/// Forming 'UnsafeRawPointer' to an inout variable of type String exposes the internal representation rather than the string contents.
///
/// 如果使用数值型的key也可以，比如 let key: Int = 100，但是category添加的属性是全局可查的，
/// 这就有可能导致key的重复，导致出问题，所以使用字符串是一个比较理想的方式，。
///
///
public extension NSObject {
    struct AssociationKey {
        let rawValue: String
        
        public init(rawValue: String) {
            self.rawValue = rawValue
        }
        
        public static func create(_ rawValue: String) -> AssociationKey {
            return AssociationKey(rawValue: rawValue)
        }
    }
    
    /// 数据缓存策略
    enum OBJCAssociationPolicy {
        case retainNonatomic
        case copyNonatomic
        case assign
        case retain
        case copy
        
        fileprivate var objcPolicy: objc_AssociationPolicy {
            switch self {
            case .retainNonatomic:  return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .copyNonatomic:    return .OBJC_ASSOCIATION_COPY_NONATOMIC
            case .assign:           return .OBJC_ASSOCIATION_ASSIGN
            case .retain:           return .OBJC_ASSOCIATION_RETAIN
            case .copy:             return .OBJC_ASSOCIATION_COPY
            }
        }
    }
    
    /// 使用 objc_setAssociatedObject 给当前对象设置一个属性值
    func setAssociatedObject<T>(_ object: T?, for key: AssociationKey, policy: OBJCAssociationPolicy) {
        objc_setAssociatedObject(self, key.rawValue.unsafePointer, object, policy.objcPolicy)
    }
    
    /// 使用 objc_getAssociatedObject 获取当前对象的一个属性值
    func associatedObject<T>(for key: AssociationKey) -> T? {
        return objc_getAssociatedObject(self, key.rawValue.unsafePointer) as? T
    }
    
    /// 移除通过runtime方式添加到当前对象上的所有属性值
    func removeAssociatedObjects() {
        objc_removeAssociatedObjects(self)
    }
}

public extension NSObject {
    private class _WeakAssociationObject {
        weak var object: AnyObject?
        init(object: AnyObject?) {
            self.object = object
        }
    }
    
    /// 动态添加weak属性
    /// @param object 要添加的属性值
    /// @param key 缓存的key
    func setAssociatedWeakObject<T>(_ weakObject: T, for key: AssociationKey) where T: AnyObject {
        objc_setAssociatedObject(self, key.rawValue.unsafePointer, _WeakAssociationObject(object: weakObject), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// 根据给定的key获取存储的weak类型的对象
    /// @param key key
    func associatedWeakObject<T>(for key: AssociationKey) -> T? where T: AnyObject {
        return (objc_getAssociatedObject(self, key.rawValue.unsafePointer) as? _WeakAssociationObject)?.object as? T
    }
}
