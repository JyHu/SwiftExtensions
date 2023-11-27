//
//  File.swift
//  
//
//  Created by Jo on 2022/10/31.
//

#if canImport(Foundation)

import Foundation

public extension NSDecimalNumber {
    /// 防止string为""时，返回的结果为NAN，导致的可能崩溃
    convenience init(saftyString: String?) {
        guard let saftyString = saftyString else {
            self.init(string: "0")
            return
        }
        
        if saftyString.isEmpty {
            self.init(string: "0")
        } else {
            self.init(string: saftyString)
        }
    }
}

public extension NSDecimalNumber {
    func highOrderIncrease() -> Self {
        let decimal = self.decimalValue
        let exponent = decimal.exponent
//        let positive = exponent == 0 ? leng : leng + exponent - 1
//        principalValue = number.adding(NSDecimalNumber(value: 1).multiplying(byPowerOf10: Int16(positive))).stringValue
        
        return self
    }
    
    func highOrderDecrease() -> Self {
        return self
    }
    
    func lowOrderIncrease() -> Self {
        return self
    }
    
    func lowOrderDecrease() -> Self {
        return self
    }
}

/// 用于将任意数据类型转换为DecimalNumber的协议，方便各种数据类型间的运算
public protocol DecimalNumberCalculationProtocol {
    var decimalNumber: NSDecimalNumber { get }
}

extension DecimalNumberCalculationProtocol {
    public func adding(_ decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.adding(decimalSource.decimalNumber, withBehavior: behavior)
    }
    
    public func subtracting(_ decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.subtracting(decimalSource.decimalNumber, withBehavior: behavior)
    }
    
    public func multiplying(by decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.multiplying(by: decimalSource.decimalNumber, withBehavior: behavior)
    }
    
    public func multiplying(byPowerOf10 power: Int16, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.multiplying(byPowerOf10: power, withBehavior: behavior)
    }

    public func dividing(by decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.dividing(by: decimalSource.decimalNumber, withBehavior: behavior)
    }
    
    public func raising(toPower power: Int, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.raising(toPower: power, withBehavior: behavior)
    }

    public func rounding(accordingToBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.rounding(accordingToBehavior: behavior)
    }
}

extension DecimalNumberCalculationProtocol {
    public func adding(_ decimalSource: NSDecimalNumber, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.adding(decimalSource, withBehavior: behavior)
    }

    public func subtracting(_ decimalSource: NSDecimalNumber, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.subtracting(decimalSource, withBehavior: behavior)
    }

    public func multiplying(by decimalSource: NSDecimalNumber, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.multiplying(by: decimalSource, withBehavior: behavior)
    }
    
    public func dividing(by decimalSource: NSDecimalNumber, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return decimalNumber.dividing(by: decimalSource, withBehavior: behavior)
    }
}

extension NSDecimalNumber {
    public func adding(_ decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return adding(decimalSource.decimalNumber, withBehavior: behavior)
    }
    
    public func subtracting(_ decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return subtracting(decimalSource.decimalNumber, withBehavior: behavior)
    }

    public func multiplying(by decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return multiplying(by: decimalSource.decimalNumber, withBehavior: behavior)
    }
    
    public func dividing(by decimalSource: DecimalNumberCalculationProtocol, withBehavior behavior: NSDecimalNumberBehaviors? = nil) -> NSDecimalNumber {
        return dividing(by: decimalSource.decimalNumber, withBehavior: behavior)
    }
}

extension String: DecimalNumberCalculationProtocol {
    public var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(saftyString: self)
    }
}

extension NSNumber: DecimalNumberCalculationProtocol {
    public var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(decimal: decimalValue)
    }
}

extension Int: DecimalNumberCalculationProtocol {
    public var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self)
    }
}

extension Double: DecimalNumberCalculationProtocol {
    public var decimalNumber: NSDecimalNumber {
        return NSDecimalNumber(value: self)
    }
}

#endif
