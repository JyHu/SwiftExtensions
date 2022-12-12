//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSGridView {
    func mergeCells(x: Int, xLength: Int, y: Int, yLength: Int) {
        mergeCells(inHorizontalRange: NSRange(location: x, length: xLength),
                   verticalRange: NSRange(location: y, length: yLength))
    }
}

#endif
