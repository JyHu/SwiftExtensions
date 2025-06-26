//
//  SelfCompatible.swift
//  SwiftUIExtension
//
//  Created by hujinyou on 2025/5/23.
//

import Foundation

public protocol SelfCompatible { }

public extension SelfCompatible {
    func makeValue<T>(builder: (Self) -> T) -> T {
        return builder(self)
    }
    
    func makeValue<T>(builder: (Self) -> T?) -> T? {
        return builder(self)
    }
}

// 添加更多基础类型的扩展
extension String: SelfCompatible { }
extension Int: SelfCompatible { }
extension Double: SelfCompatible { }
extension Bool: SelfCompatible { }
extension Array: SelfCompatible { }
extension Dictionary: SelfCompatible { }
extension Set: SelfCompatible { }
extension Optional: SelfCompatible { }
extension NSObject: SelfCompatible { }
