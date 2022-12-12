//
//  File.swift
//  
//
//  Created by Jo on 2022/11/20.
//

import Foundation

public protocol MirrorReadble {
    func toJSONModel() -> Any?
}

//扩展协议方法，实现一个通用的toJSONModel方法（反射实现）
public extension MirrorReadble {
    //将模型数据转成可用的字典数据，Any表示任何类型，除了方法类型
    func toJSONModel() -> Any? {
        //根据实例创建反射结构体Mirror
        let mirror = Mirror(reflecting: self)
        if mirror.children.count > 0  {
            //创建一个空字典，用于后面添加键值对
            var result: [String:Any] = [:]
            //遍历实例的所有属性集合
            for children in mirror.children {
                let propertyNameString = children.label!
                let value = children.value
                //判断value的类型是否遵循JSON协议，进行深度递归调用
                if let jsonValue = value as? MirrorReadble {
                    result[propertyNameString] = jsonValue.toJSONModel()
                }
            }
            return result
        }
        return self
    }
}

//扩展可选类型，使其遵循JSON协议，可选类型值为nil时，不转化进字典中
extension Optional: MirrorReadble {
    //可选类型重写toJSONModel()方法
    public func toJSONModel() -> Any? {
        if let x = self {
            if let value = x as? MirrorReadble {
                return value.toJSONModel()
            }
        }
        return nil
    }
}

extension String: MirrorReadble { }
extension Int: MirrorReadble { }
extension Bool: MirrorReadble { }
extension Dictionary: MirrorReadble { }
extension Array: MirrorReadble { }
