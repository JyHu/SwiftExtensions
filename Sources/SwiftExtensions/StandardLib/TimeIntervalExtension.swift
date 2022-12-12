//
//  File.swift
//
//
//  Created by Jo on 2022/10/31.
//

import Foundation

public extension TimeInterval {
    static let daySEC: TimeInterval = 24 * 60 * 60
    static let hourSEC: TimeInterval = 60 * 60
    static let minuteSec: TimeInterval = 60
    
    static let dayMSEC: TimeInterval = daySEC * 1000
    static let hourMSEC: TimeInterval = hourSEC * 1000
    static let minuteMSEC: TimeInterval = 60 * 1000
    static let secondMSEC: TimeInterval = 1000
}

public extension TimeInterval {
    struct DateElements {
        private let days_: TimeInterval
        private let hours_: TimeInterval
        private let minutes_: TimeInterval
        private let seconds_: TimeInterval
        private let milliseconds_: TimeInterval
        
        var seconds: TimeInterval { milliseconds / 1000 }
        let milliseconds: TimeInterval
        
        fileprivate init(
            days: TimeInterval = 0,
            hours: TimeInterval = 0,
            minutes: TimeInterval = 0,
            seconds: TimeInterval = 0,
            milliseconds: TimeInterval = 0
        ) {
            
            self.milliseconds = days * .dayMSEC + hours * .hourMSEC + minutes * .minuteMSEC + seconds * 1000 + milliseconds
            
            self.seconds_ = seconds
            self.minutes_ = minutes
            self.hours_ = hours
            self.days_ = days
            self.milliseconds_ = milliseconds
        }
        
        static func + (lhs: DateElements, rhs: DateElements) -> DateElements {
            return DateElements(
                days: lhs.days_ + rhs.days_,
                hours: lhs.hours_ + rhs.hours_,
                minutes: lhs.minutes_ + rhs.minutes_,
                seconds: lhs.seconds_ + rhs.seconds_,
                milliseconds: lhs.milliseconds + rhs.milliseconds
            )
        }
        
        static func - (lhs: DateElements, rhs: DateElements) -> DateElements {
            return DateElements(
                days: lhs.days_ - rhs.days_,
                hours: lhs.hours_ - rhs.hours_,
                minutes: lhs.minutes_ - rhs.minutes_,
                seconds: lhs.seconds_ - rhs.seconds_,
                milliseconds: lhs.milliseconds - rhs.milliseconds
            )
        }
    }
    
    var days: DateElements {
        return DateElements(days: self)
    }
    
    var hours: DateElements {
        return DateElements(hours: self)
    }
    
    var minutes: DateElements {
        return DateElements(minutes: self)
    }
    
    var seconds: DateElements {
        return DateElements(seconds: self)
    }
    
    var milliseconds: DateElements {
        return DateElements(milliseconds: self)
    }
}

public protocol TimeIntervalDateComponents {
    var days: Int { get }
    var hours: Int { get }
    var minutes: Int { get }
    var seconds: Int { get }
    var milliseconds: Int { get }
}

public extension TimeInterval {
    fileprivate enum DateLevel {
        case seconds
        case milliseconds
    }
    
    fileprivate struct DateStruct: TimeIntervalDateComponents {
        private let level: DateLevel
        let interval: TimeInterval
        
        fileprivate init(level: DateLevel, interval: TimeInterval) {
            self.level = level
            self.interval = interval
        }
        
        var days: Int {
            return Int(floor(msinterval / .dayMSEC))
        }
        
        var hours: Int {
            return Int(floor(msinterval / .hourMSEC)) % 60
        }
        
        var minutes: Int {
            return Int(floor(msinterval / .minuteMSEC)) % 60
        }
        
        var seconds: Int {
            return Int(floor(msinterval / 1000)) % 60
        }
        
        var milliseconds: Int {
            return Int(floor(msinterval)) % 1000
        }
        
        private var msinterval: TimeInterval {
            if level == .seconds {
                return interval * 1000
            }
            
            return interval
        }
    }
    
    var S: TimeIntervalDateComponents {
        DateStruct(level: .seconds, interval: self)
    }
    
    var MS: TimeIntervalDateComponents {
        DateStruct(level: .milliseconds, interval: self)
    }
}

public extension TimeInterval {
    init(machTick: UInt64) {
        var timebaseInfo = mach_timebase_info_data_t()
        mach_timebase_info(&timebaseInfo)
        let msec = machTick * UInt64(timebaseInfo.numer / timebaseInfo.denom) / UInt64(1e6)
        self.init(floatLiteral: Double(msec))
    }
    
    init(fromMachBegining machBegining:  UInt64) {
        self.init(machTick: mach_absolute_time() - machBegining)
    }
}
