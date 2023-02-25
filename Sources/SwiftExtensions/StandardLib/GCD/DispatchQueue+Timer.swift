//
//  File.swift
//  
//
//  Created by Jo on 2022/12/16.
//

import Foundation

public protocol GCDTimer {
    // 启动
    func resume()
    // 暂停
    func suspend()
    // 取消
    func cancel()
    
    /// 反转状态，如果是暂停，那么会重启，如果是运行中，那么会暂停
    func reverseState()
    
    /// 定时器状态
    var state: DispatchQueue.TimerState { get }
}

public extension DispatchQueue {
    /// 当前Timer 运行状态
    enum TimerState {
        /// 正在运行
        case running
        /// 暂停
        case paused
        /// 被取消
        case cancelled
    }

    static func timer(interval: Int, repeats: Bool = true, async: Bool = true, task: (() -> ())?) -> GCDTimer? {
        
        guard let _ = task else { return nil }
        
        return _GCDTimer(task, deadline: .now(), repeating: repeats ? .seconds(interval):.never, async: async)
    }
}

private class _GCDTimer: GCDTimer {
    fileprivate var state: DispatchQueue.TimerState = .paused
    
    private var timer: DispatchSourceTimer?
    private var handler: (() -> ())?
    
    convenience init(_ exce: (() -> ())?, deadline: DispatchTime, repeating interval: DispatchTimeInterval = .never, leeway: DispatchTimeInterval = .seconds(0), async: Bool = true) {
        self.init()

        self.handler = exce
        
        let queue: DispatchQueue = async ? .global() : .main
        timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer?.schedule(deadline: deadline, repeating: interval, leeway: leeway)
        timer?.setEventHandler(handler: { [weak self] in
            if let strongSelf = self {
                strongSelf.handler?()
                print("---> timer loop")
            }
        })
    }
    
    func resume() {
        if state == .cancelled { return }
        guard state != .running else { return }
        state = .running
        timer?.resume()
    }
    
    func suspend() {
        if state == .cancelled { return }
        guard state != .paused else { return }
        state = .paused
        timer?.suspend()
    }
    
    func cancel() {
        guard state == .running else { return }
        state = .cancelled
        timer?.cancel()
    }
    
    func reverseState() {
        switch state {
        case .running: suspend()
        case .paused: resume()
        case .cancelled: return
        }
    }
    
    deinit {
        cancel()
    }
}
