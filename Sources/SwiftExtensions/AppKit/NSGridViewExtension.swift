//
//  File.swift
//  
//
//  Created by Jo on 2022/10/28.
//

#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

public extension NSGridView {
    func removeAllRows() {
        while numberOfRows > 0 {
            removeRow(at: 0)
        }
    }

    func hideAllRows() {
        for rIndex in 0 ..< numberOfRows {
            row(at: rIndex).isHidden = true
        }
    }
    
    func mergeCells(x: Int, xLength: Int, y: Int, yLength: Int) {
        mergeCells(inHorizontalRange: NSRange(location: x, length: xLength),
                   verticalRange: NSRange(location: y, length: yLength))
    }
}

#endif
