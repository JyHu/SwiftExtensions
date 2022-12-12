//
//  File.swift
//  
//
//  Created by Jo on 2022/11/3.
//

#if canImport(Foundation) && canImport(CoreFoundation)

import Foundation
import CoreFoundation

public protocol RunLoopObserverDelegate: NSObjectProtocol {
    func runLoopObserver(_ observer: RunLoop.Observer, activityChanged activity: CFRunLoopActivity)
}

public extension RunLoop {
    enum Ref {
        case current
        case main
    }
    
    class Observer {
        public struct Properties {
            public var ref: Ref = .main
            public var activities: CFRunLoopActivity = .allActivities
            public var mode: CFRunLoopMode = .commonModes
            
            public static let defaultMain = Properties()
        }
        
        public private(set) weak var delegate: RunLoopObserverDelegate?
        private(set) var properties: Properties!
        private var observer: CFRunLoopObserver?
        
        public init(delegate: RunLoopObserverDelegate, properties: Properties = .defaultMain) {
            self.delegate = delegate
            self.properties = properties
            
            observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, properties.activities.rawValue, true, 0) { [weak self] _, activity in
                self?.callback(activity)
            }
            
            CFRunLoopAddObserver(properties.ref.runLoop, observer, properties.mode)
        }
        
        private func callback(_ activity: CFRunLoopActivity) {
            self.delegate?.runLoopObserver(self, activityChanged: activity)
        }
        
        deinit {
            guard let observer = observer else { return }
            CFRunLoopRemoveObserver(properties.ref.runLoop, observer, properties.mode)
        }
    }
}

fileprivate extension RunLoop.Ref {
    var runLoop: CFRunLoop {
        switch self {
        case .main: return CFRunLoopGetMain()
        default: return CFRunLoopGetCurrent()
        }
    }
}

#endif
