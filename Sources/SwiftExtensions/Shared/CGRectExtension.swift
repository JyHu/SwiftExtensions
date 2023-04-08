//
//  File.swift
//  
//
//  Created by Jo on 2023/3/27.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension CGRect {
    
    /// 将rect缩放到一定的比例
    ///   self = (0, 0, 100, 100)
    ///   rate = 0.8
    ///   -> (10, 10, 80, 80)
    ///
    /// - Parameter rate: 缩放比例
    /// - Returns: 缩放结果
    func inset(rate: Double) -> CGRect {
        if rate == 0 || rate == 1 { return self }
        
        guard rate < 1 else { return self }
        
        let twidth = width * rate
        let theight = height * rate
        
        return CGRect(
            x: minX + (width - twidth) / 2,
            y: minY + (height - theight) / 2,
            width: twidth,
            height: theight
        )
    }
}

#endif
