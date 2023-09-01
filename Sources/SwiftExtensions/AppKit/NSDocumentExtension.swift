//
//  File.swift
//  
//
//  Created by Jo on 2023/9/1.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import Cocoa

public extension NSDocument {
    
    ///
    /// https://developer.apple.com/library/archive/releasenotes/AppKit/RN-AppKitOlderNotes/
    /// https://www.appsloveworld.com/swift/100/135/best-practice-to-implement-canclosewithdelegateshouldclosecontextinfo
    ///
    /// 对于`func canClose(withDelegate:shouldClose:contextInfo:)`使用支持，
    /// 使用方法如：
    ///
    /// ```
    /// override func canClose(withDelegate delegate: Any,
    ///                        shouldClose shouldCloseSelector: Selector?,
    ///                        contextInfo: UnsafeMutableRawPointer?) {
    ///
    ///     /// 这里可以执行一些异步的操作，如大文件的存储、复杂逻辑的执行等
    ///     /// 这里可以带一个是否关闭窗口的参数，比如在执行保存操作的时候用户没有选择有效的
    ///     /// 文件路径，那么就可能不能让用户关闭窗口避免数据丢失，等类似的操作
    ///     do_something_async_work(close) {
    ///
    ///         /// 在异步操作执行结束后，来执行真正的关闭document的操作
    ///         performCloseDocumentAction(
    ///             withDelegate: delegate,
    ///             shouldCloseSelector: shouldCloseSelector,
    ///             contextInfo: contextInfo,
    ///             shouldClosed: close
    ///         )
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - delegate: `func canClose(withDelegate:shouldClose:contextInfo:)`的参数
    ///   - shouldCloseSelector: `func canClose(withDelegate:shouldClose:contextInfo:)`的参数
    ///   - contextInfo: `func canClose(withDelegate:shouldClose:contextInfo:)`的参数
    ///   - shouldClosed: 是否需要真正的关闭document窗口
    public func performCloseDocumentAction(
        withDelegate delegate: Any,
        shouldCloseSelector: Selector?,
        contextInfo: UnsafeMutableRawPointer?,
        shouldClosed: Bool
    ) {
        guard let Class: AnyClass = object_getClass(delegate),
              let shouldCloseSelector else {
            return
        }
        
        let obj: AnyObject = delegate as AnyObject
        let method = class_getMethodImplementation(Class, shouldCloseSelector)
        typealias Signature = @convention(c) (AnyObject, Selector, AnyObject, Bool, UnsafeMutableRawPointer?) -> Void
        let function = unsafeBitCast(method, to: Signature.self)
        
        function(obj, shouldCloseSelector, self, shouldClosed, contextInfo)
    }
}

#endif
