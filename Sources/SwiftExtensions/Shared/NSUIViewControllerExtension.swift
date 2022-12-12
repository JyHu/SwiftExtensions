//
//  File.swift
//  
//
//  Created by Jo on 2022/11/1.
//

#if !os(Linux)

#if canImport(AppKit) && !targetEnvironment(macCatalyst)
import AppKit
public typealias NSUIViewController = NSViewController
#elseif canImport(UIKit)
import UIKit
public typealias NSUIViewController = UIViewController
#endif

extension NSUIViewController {
    
}

#endif
