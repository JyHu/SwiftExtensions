//
//  File.swift
//  
//
//  Created by Jo on 2022/11/3.
//

#if canImport(Foundation) && canImport(CoreFoundation)

import Foundation
import CoreFoundation

public extension RunLoop {
    /// RunLoop 引用类型
    ///
    /// 用于指定监听当前线程或主线程的 RunLoop
    enum Ref {
        case current   // 当前线程的 RunLoop
        case main      // 主线程的 RunLoop

        var runLoop: CFRunLoop {
            switch self {
            case .main: return CFRunLoopGetMain()
            case .current: return CFRunLoopGetCurrent()
            }
        }
    }

    /// RunLoop 的生命周期监听器，用于在 RunLoop 生命周期某些阶段触发回调
    ///
    /// 用于监听如 .beforeWaiting、.afterWaiting 等活动，并触发对应处理逻辑。
    /// 例如可以监听 .beforeWaiting 阶段合并埋点数据上传。
    final class Observer {

        /// RunLoop 监听器的配置参数
        public struct Properties {
            public var ref: Ref = .main
            public var activities: CFRunLoopActivity = .allActivities
            public var mode: CFRunLoopMode = .commonModes

            public static let `default` = Properties() // 默认使用主线程、监听所有事件
        }

        private var observer: CFRunLoopObserver?
        private let callback: (CFRunLoopActivity) -> Void
        private let properties: Properties

        /// 初始化一个监听器
        /// - Parameters:
        ///   - properties: 配置参数（线程、监听阶段、模式）
        ///   - callback: 每次监听触发时执行的闭包
        public init(properties: Properties = .default, callback: @escaping (CFRunLoopActivity) -> Void) {
            self.callback = callback
            self.properties = properties

            observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, properties.activities.rawValue, true, 0) { _, activity in
                callback(activity)
            }

            if let observer = observer {
                CFRunLoopAddObserver(properties.ref.runLoop, observer, properties.mode)
            }
        }

        deinit {
            if let observer = observer {
                CFRunLoopRemoveObserver(properties.ref.runLoop, observer, properties.mode)
            }
        }
    }

    /// RunLoop 上执行缓存任务的通用工具结构
    ///
    /// 在埋点、日志、任务批处理等场景下非常适用。
    /// 每次调用 `append` 添加内容时，数据会被临时缓存，直到 RunLoop 生命周期某一阶段统一处理。
    ///
    /// - T: 缓存的数据类型（如 [String]、[String: Int] 等）
    ///
    /// 使用示例：
    /// ```swift
    /// // 示例 1：缓存数组内容
    /// let arrayWork = RunLoop.Work<[String]>(
    ///     merge: { $0 += $1 },
    ///     perform: { mergedArray in
    ///         print("处理数组：", mergedArray)
    ///     }
    /// )
    /// arrayWork.append(["A"])
    /// arrayWork.append(["B", "C"])
    /// // 将在 RunLoop 某个阶段统一触发 perform
    ///
    /// // 示例 2：缓存字典内容
    /// let dictWork = RunLoop.Work<[String: Int]>(
    ///     merge: { $0.merge($1, uniquingKeysWith: { _, new in new }) },
    ///     perform: { dict in
    ///         print("处理字典：", dict)
    ///     }
    /// )
    /// dictWork.append(["x": 1])
    /// dictWork.append(["y": 2])
    /// ```
    final class Work<T> {
        private var cache: T?
        private let merge: (inout T, T) -> Void
        private let perform: (T) -> Void
        private var observer: Observer?

        /// 初始化缓存处理器
        /// - Parameters:
        ///   - properties: RunLoop 监听配置（默认主线程）
        ///   - merge: 多次 append 时的缓存合并策略
        ///   - perform: RunLoop 生命周期触发时，统一处理缓存数据
        public init(
            properties: Observer.Properties = .default,
            merge: @escaping (inout T, T) -> Void,
            perform: @escaping (T) -> Void
        ) {
            self.merge = merge
            self.perform = perform

            self.observer = Observer(properties: properties) { [weak self] _ in
                self?.flush()
            }
        }

        /// 添加一批任务数据到缓存中，等待 RunLoop 生命周期时处理
        /// - Parameter value: 新的数据批次
        public func append(_ value: T) {
            if var current = cache {
                merge(&current, value)
                cache = current
            } else {
                cache = value
            }
        }

        /// 手动刷新（仅在必要时调用）
        private func flush() {
            if let value = cache {
                perform(value)
                cache = nil
            }
        }
    }
}


#endif
