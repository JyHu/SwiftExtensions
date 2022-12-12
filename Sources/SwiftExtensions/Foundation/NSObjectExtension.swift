//
//  File.swift
//  
//
//  Created by Jo on 2022/10/29.
//

#if canImport(Foundation)

import Foundation

func synchronized(_ object: AnyObject, closure: () -> Void) {
    objc_sync_enter(object)
    closure()
    objc_sync_exit(object)
}

public protocol ClassNameProtocol {
    static var className: String { get }
    var className: String { get }
}

public extension ClassNameProtocol {
    static var className: String {
        String(describing: self)
    }
    
    var className: String {
        Self.className
    }
}

extension NSObject: ClassNameProtocol {}

public extension NSObjectProtocol {
    var propertyDescription: String {
        Mirror(reflecting: self)
            .children
            .map { "\($0.label ?? "Unknown"): \($0.value)" }
            .joined(separator: "\n")
    }
}

public extension NSObject {
    func setAssociated<T>(value: T, associatedKey: UnsafeRawPointer, policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC) -> Void {
        objc_setAssociatedObject(self, associatedKey, value, policy)
    }
    
    func getAssociated<T>(associatedKey: UnsafeRawPointer) -> T? {
        return objc_getAssociatedObject(self, associatedKey) as? T
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
    func set(weakObject: AnyObject, for key: String) {
        objc_setAssociatedObject(self, strdup(key), _WeakAssociationObject(object: weakObject), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    /// 根据给定的key获取存储的weak类型的对象
    /// @param key key
    func weakObject(for key: String) -> AnyObject? {
        return (objc_getAssociatedObject(self, strdup(key)) as? _WeakAssociationObject)?.object
    }
}

#endif
